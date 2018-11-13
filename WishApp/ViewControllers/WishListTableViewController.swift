//
//  WishListTableViewController.swift
//  WishApp
//
//  Created by Janosch Hübner on 05.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import UIKit
import StoreKit
import RealmSwift
import MBProgressHUD

class WishListTableViewController: UITableViewController {

    static private let items = DatabaseManager.shared.getObjects(for: WishListItem.self)
    
    private var itemData: ItemData = WishListTableViewController.composeItemData()
    private var previousItemData: (items: [WishListItem], fulfilledItems: [WishListItem])? = nil
    
    private var noContentLabel: UILabel?
    
    private var priceFormatter: NumberFormatter = NumberFormatter()
    
    private var buildUIDispatchQueue: DispatchQueue = DispatchQueue(label: "wishapp.ui")
    
    private typealias ItemChanges = (deleted: [IndexPath], inserted: [IndexPath])
    private typealias ItemData = (items: Results<WishListItem>, fulfilledItems: Results<WishListItem>)
    
    private enum Section {
        case items
        case fulfilledItems
    }
    
    private var sectionData: [Section] = []
    
    private func sectionIndex(for section: Section) -> Int? {
        if let index = self.sectionData.index(where: { (arg0) -> Bool in
            return arg0 == section
        }) {
            return index
        }
        return nil
    }
    
    private static func composeItemData() -> ItemData {
        let items = WishListTableViewController.items.filter("fulfilled = 0")
        let fulfilledItems = WishListTableViewController.items.filter("fulfilled = 1")
        switch SettingsManager.shared.sortOption {
        case .byDate:
            return (items.sorted(byKeyPath: "dateAdded", ascending: false), fulfilledItems.sorted(byKeyPath: "dateCompleted", ascending: false))
        case .byPrice:
            return (items.sorted(byKeyPath: "price", ascending: false), fulfilledItems.sorted(byKeyPath: "name"))
        case .byName:
            return (items.sorted(byKeyPath: "name"), fulfilledItems.sorted(byKeyPath: "name"))
        }
    }
    
    private func markItemChanges() -> ItemChanges {
        // if there is no previous data, we do not need to return the changes
        guard let previousData = self.previousItemData else {
            // we need to initialize it, if it was nil
            self.previousItemData = (items: Array(self.itemData.items), fulfilledItems: Array(self.itemData.fulfilledItems))
            return (deleted: [], inserted: [])
        }
        
        var deletes: [IndexPath] = []
        var inserts: [IndexPath] = []
        if let sectionIndex = self.sectionIndex(for: .items) {
            // deletes from first section
            for (index, item) in previousData.items.enumerated() {
                if !self.itemData.items.contains(item) {
                    deletes.append(IndexPath(row: index, section: sectionIndex))
                }
            }
            // inserts from first section
            for (index, item) in self.itemData.items.enumerated() {
                if !previousData.items.contains(item) {
                    inserts.append(IndexPath(row: index, section: sectionIndex))
                }
            }
        }
        if let sectionIndex = self.sectionIndex(for: .fulfilledItems) {
            // deletes from second section
            for (index, item) in previousData.fulfilledItems.enumerated() {
                if !self.itemData.fulfilledItems.contains(item) {
                    deletes.append(IndexPath(row: index, section: sectionIndex))
                }
            }
            // inserts from second section
            for (index, item) in self.itemData.fulfilledItems.enumerated() {
                if !previousData.fulfilledItems.contains(item) {
                    inserts.append(IndexPath(row: index, section: sectionIndex))
                }
            }
        }
        
        // at the end we set the previous data to the now data
        self.previousItemData = (items: Array(self.itemData.items), fulfilledItems: Array(self.itemData.fulfilledItems))
        return (deleted: deletes, inserted: inserts)
    }
    
    private func buildSections() {
        self.sectionData.removeAll()
        
        if self.itemData.items.count > 0 {
            self.sectionData.append(.items)
        }
        
        if self.itemData.fulfilledItems.count > 0 {
            self.sectionData.append(.fulfilledItems)
        }
    }
    
    private func buildUI() {
        self.buildUIDispatchQueue.sync {
            self.tableView.beginUpdates()
            
            let oldItemsSectionIndex: Int? = self.sectionIndex(for: .items)
            let oldFulfilledSectionIndex: Int? = self.sectionIndex(for: .fulfilledItems)
            
            self.buildSections()
            
            let newItemsSectionIndex: Int? = self.sectionIndex(for: .items)
            let newFulfilledSectionIndex: Int? = self.sectionIndex(for: .fulfilledItems)

            var insertSectionsIndices: [Int] = []
            var deleteSectionIndices: [Int] = []

            if oldItemsSectionIndex == nil, let newSectionIndex = newItemsSectionIndex {
                insertSectionsIndices.append(newSectionIndex)
            } else if let oldSectionIndex = oldItemsSectionIndex, newItemsSectionIndex == nil {
                deleteSectionIndices.append(oldSectionIndex)
            }

            if oldFulfilledSectionIndex == nil, let newSectionIndex = newFulfilledSectionIndex {
                insertSectionsIndices.append(newSectionIndex)
            } else if let oldSectionIndex = oldFulfilledSectionIndex, newFulfilledSectionIndex == nil {
                deleteSectionIndices.append(oldSectionIndex)
            }
            
            let itemChanges: ItemChanges = self.markItemChanges()
            self.tableView.deleteRows(at: itemChanges.deleted, with: .fade)
            self.tableView.insertRows(at: itemChanges.inserted, with: .fade)
            
            self.tableView.deleteSections(IndexSet(deleteSectionIndices), with: .fade)
            self.tableView.insertSections(IndexSet(insertSectionsIndices), with: .fade)
            
            self.tableView.endUpdates()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.buildUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.accessibilityIdentifier = "wish_list_nav_bar"
        
        self.priceFormatter.allowsFloats = true
        self.priceFormatter.locale = Locale.current
        self.priceFormatter.numberStyle = .currency
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.sortOptionDidChange, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            self.itemData = WishListTableViewController.composeItemData()
            self.previousItemData = nil
            
            var reloadSectionsIndices: [Int] = []
            if let itemsSectionIndex: Int = self.sectionIndex(for: .items) {
                reloadSectionsIndices.append(itemsSectionIndex)
            }
            if let fulfilledItemsSectionInset: Int = self.sectionIndex(for: .fulfilledItems) {
                reloadSectionsIndices.append(fulfilledItemsSectionInset)
            }
            self.tableView.reloadSections(IndexSet(reloadSectionsIndices), with: .none)
            
            self.buildUI()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.needsWishListRefresh, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            self.buildUI()
        }

        self.title = "WISH_LIST".localized
        
        self.tableView.register(WishListItemTableViewCell.self, forCellReuseIdentifier: "ItemCell")
        
        self.tableView.backgroundColor = UIColor.darkJungleGreen
        self.tableView.separatorStyle = .none
        self.view.backgroundColor = UIColor.darkJungleGreen
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Info")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleInfoButton(pressed:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchButton(pressed:)))
        self.navigationItem.rightBarButtonItem?.accessibilityIdentifier = "search_button"
    }
    
    @objc private func handleInfoButton(pressed: UIBarButtonItem) -> Void {
        let infoViewController = InfoTableViewController(style: .grouped)
        let navigationController = UINavigationController(rootViewController: infoViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func handleSearchButton(pressed: UIBarButtonItem) -> Void {
        let searchTableViewController = SearchTableViewController()
        self.navigationController?.pushViewController(searchTableViewController, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = self.sectionData.count
        if numberOfSections == 0 {
            self.noContentLabel = UILabel(frame: .zero)
            self.noContentLabel!.text = "NO_APPS_ON_WISHLIST".localized
            self.noContentLabel!.textColor = UIColor.lightGray
            self.noContentLabel!.textAlignment = .center
            self.noContentLabel!.numberOfLines = 0
            self.noContentLabel!.translatesAutoresizingMaskIntoConstraints = false
            
            let backgroundView = UIView(frame: .zero)
            backgroundView.backgroundColor = UIColor.clear
            backgroundView.addSubview(self.noContentLabel!)
            
            self.noContentLabel!.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.9).isActive = true
            self.noContentLabel!.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
            self.noContentLabel!.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
            self.noContentLabel!.heightAnchor.constraint(greaterThanOrEqualToConstant: 10.0).isActive = true
            
            tableView.isScrollEnabled = false
            tableView.backgroundView = backgroundView
        } else {
            self.noContentLabel = nil
            tableView.backgroundView = nil
            tableView.isScrollEnabled = true
        }
        return numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableViewSection: Section = self.sectionData[section]
        if tableViewSection == .items {
            return self.itemData.items.count
        } else if tableViewSection == .fulfilledItems {
            return self.itemData.fulfilledItems.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WishListItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! WishListItemTableViewCell
        cell.backgroundColor = UIColor.dark
        
        let tableViewSection: Section = self.sectionData[indexPath.section]
        let items = (tableViewSection == .items ? self.itemData.items : self.itemData.fulfilledItems)
        
        let item: WishListItem = items[indexPath.row]
        
        if !TestingManager.shared.isTesting {
            
            cell.itemNameLabel.text = item.name
            cell.itemDevelopedByLabel.text = item.developer
            
            if let imageName = item.imageName, let iconsURL: URL = ImageManager.shared.iconsURL {
                let fileURL: URL = iconsURL.appendingPathComponent(imageName)
                if let imageData: Data = try? Data(contentsOf: fileURL) {
                    cell.iconImageView.image = UIImage(data: imageData)
                }
            }
        } else {
            cell.iconImageView.backgroundColor = UIColor.darkJungleGreen
            cell.itemNameLabel.backgroundColor = UIColor.darkJungleGreen
            cell.itemDevelopedByLabel.backgroundColor = UIColor.darkJungleGreen
        }
        
        cell.tintColor = UIColor.white
        
        if item.fulfilled {
            cell.shouldShowSeparator = indexPath.row != self.itemData.fulfilledItems.count-1
            cell.priceString = nil
            cell.accessoryType = .checkmark
            cell.itemNameLabel.textColor = UIColor.lightGray
            cell.itemDevelopedByLabel.textColor = UIColor.lightGray
        } else {
            cell.shouldShowSeparator = indexPath.row != self.itemData.items.count-1
            cell.priceString = (item.price <= 0.0 ? "FREE".localized : self.priceFormatter.string(from: NSNumber(value: item.price)))
            cell.accessoryType = .none
            cell.itemNameLabel.textColor = UIColor.white
            cell.itemDevelopedByLabel.textColor = UIColor.white
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tableViewSection: Section = self.sectionData[section]
        if tableViewSection == .items {
            return "WISH_ITEMS".localized
        } else if tableViewSection == .fulfilledItems {
            return "FULFILLED_ITEMS".localized
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true //!TestingManager.shared.isTesting
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WishListItemTableViewCell.preferredCellHeight
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let tableViewSection: Section = self.sectionData[indexPath.section]
        if tableViewSection == .fulfilledItems {
            return nil
        }
        
        let item: WishListItem = self.itemData.items[indexPath.row]
        
        let markAction = UIContextualAction(style: .normal, title:  nil, handler: { (action: UIContextualAction, view: UIView, success:(Bool) -> Void) in
            success(true)
            DatabaseManager.shared.write {
                item.fulfilled = true
                item.dateCompleted = Date()
            }
            self.buildUI()
        })
        markAction.image = UIImage(named: "MarkRow")
        markAction.backgroundColor = UIColor.greenWish
        
        let updateAction = UIContextualAction(style: .normal, title:  nil, handler: { (action: UIContextualAction, view: UIView, success:(Bool) -> Void) in
            success(true)
            let hud: MBProgressHUD = MBProgressHUD.showAdded(to: tableView, animated: true)
            hud.mode = MBProgressHUDMode.indeterminate
            hud.label.text = "UPDATING_APP".localized
            hud.label.textColor = UIColor.white
            hud.contentColor = UIColor.white
            hud.bezelView.color = UIColor.dark
            hud.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
            iTunesSearchAPI.shared.lookupApp(for: item.bundleIdentifier, completion: { (app: App?) in
                DispatchQueue.main.async {
                   hud.hide(animated: true, afterDelay: 0.5)
                }
                if let app = app {
                    DatabaseManager.shared.write {
                        item.update(with: app)
                    }
                    DispatchQueue.main.async {
                        tableView.reloadRows(at: [indexPath], with: .fade)
                    }
                }
            })
        })
        updateAction.image = UIImage(named: "UpdateRow")
        updateAction.backgroundColor = UIColor.blueWish
        return UISwipeActionsConfiguration(actions: [markAction,updateAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let tableViewSection: Section = self.sectionData[indexPath.section]
        let items = (tableViewSection == .items ? self.itemData.items : self.itemData.fulfilledItems)
        let item: WishListItem = items[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title:  nil, handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            success(true)
            ImageManager.shared.deleteImage(for: item)
            DatabaseManager.shared.delete(object: item)
            self.buildUI()
        })
        deleteAction.image = UIImage(named: "DeleteRow")
        deleteAction.backgroundColor = UIColor.redWish
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let tableViewSection: Section = self.sectionData[indexPath.section]
        
        let item: WishListItem = (tableViewSection == .items ? self.itemData.items[indexPath.row] : self.itemData.fulfilledItems[indexPath.row])
        if let appURL: URL = URL(string: item.appStoreURL), UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            let productViewController: SKStoreProductViewController = SKStoreProductViewController()
            productViewController.delegate = self
            productViewController.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: item.storeIdentifier]) { (success: Bool, error: Error?) in
                print("Done loading product")
            }
            self.present(productViewController, animated: true, completion: nil)
        }
    }
}

extension WishListTableViewController : SKStoreProductViewControllerDelegate {
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
