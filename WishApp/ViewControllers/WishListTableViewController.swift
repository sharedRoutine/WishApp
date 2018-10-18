//
//  WishListTableViewController.swift
//  WishApp
//
//  Created by Janosch Hübner on 05.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import UIKit
import StoreKit

class WishListTableViewController: UITableViewController {

    static private let items = DatabaseManager.shared.getObjects(for: WishListItem.self).sorted(byKeyPath: "name")
    private var wishListItems = WishListTableViewController.items.filter("fulfilled = 0")
    private var fulfilledItems = WishListTableViewController.items.filter("fulfilled = 1")
    
    private var noContentLabel: UILabel?
    
    private var buildUIDispatchQueue: DispatchQueue = DispatchQueue(label: "wishapp.ui")
    
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
    
    private func buildRows() {
        self.sectionData.removeAll()
        
        if self.wishListItems.count > 0 {
            self.sectionData.append(.items)
        }
        
        if self.fulfilledItems.count > 0 {
            self.sectionData.append(.fulfilledItems)
        }
    }
    
    private func buildUI() {
        self.buildUIDispatchQueue.sync {
            self.tableView.beginUpdates()
            
            let oldItemsSectionIndex: Int? = self.sectionIndex(for: .items)
            let oldFulfilledSectionIndex: Int? = self.sectionIndex(for: .fulfilledItems)
            
            self.buildRows()
            
            let newItemsSectionIndex: Int? = self.sectionIndex(for: .items)
            let newFulfilledSectionIndex: Int? = self.sectionIndex(for: .fulfilledItems)
            
            var insertSectionsIndices: [Int] = []
            var reloadSectionIndices: [Int] = []
            var deleteSectionIndices: [Int] = []
            
            if oldItemsSectionIndex == nil, let newSectionIndex = newItemsSectionIndex {
                insertSectionsIndices.append(newSectionIndex)
            } else if let oldSectionIndex = oldItemsSectionIndex, newItemsSectionIndex != nil {
                reloadSectionIndices.append(oldSectionIndex)
            } else if let oldSectionIndex = oldItemsSectionIndex, newItemsSectionIndex == nil {
                deleteSectionIndices.append(oldSectionIndex)
            }
            
            if oldFulfilledSectionIndex == nil, let newSectionIndex = newFulfilledSectionIndex {
                insertSectionsIndices.append(newSectionIndex)
            } else if let oldSectionIndex = oldFulfilledSectionIndex, newFulfilledSectionIndex != nil {
                reloadSectionIndices.append(oldSectionIndex)
            } else if let oldSectionIndex = oldFulfilledSectionIndex, newFulfilledSectionIndex == nil {
                deleteSectionIndices.append(oldSectionIndex)
            }
            
            self.tableView.insertSections(IndexSet(insertSectionsIndices), with: .fade)
            self.tableView.reloadSections(IndexSet(reloadSectionIndices), with: .fade)
            self.tableView.deleteSections(IndexSet(deleteSectionIndices), with: .fade)
            
            self.tableView.endUpdates()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buildRows()

        self.title = "WISH_LIST".localized
        
        self.tableView.register(WishListItemTableViewCell.self, forCellReuseIdentifier: "ItemCell")
        
        self.tableView.backgroundColor = UIColor.darkJungleGreen
        self.tableView.separatorColor = UIColor.darkJungleGreen
        self.view.backgroundColor = UIColor.darkJungleGreen
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Info")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleInfoButton(pressed:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchButton(pressed:)))
    }
    
    @objc private func handleInfoButton(pressed: UIBarButtonItem) -> Void {
        let infoViewController = InfoTableViewController(style: .grouped)
        let navigationController = UINavigationController(rootViewController: infoViewController)
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
            
            tableView.backgroundView = backgroundView
        } else {
            self.noContentLabel = nil
            tableView.backgroundView = nil
        }
        return numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableViewSection: Section = self.sectionData[section]
        if tableViewSection == .items {
            return self.wishListItems.count
        } else if tableViewSection == .fulfilledItems {
            return self.fulfilledItems.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WishListItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! WishListItemTableViewCell
        cell.backgroundColor = UIColor.dark
        
        let tableViewSection: Section = self.sectionData[indexPath.section]
        let items = (tableViewSection == .items ? self.wishListItems : self.fulfilledItems)
        
        let item: WishListItem = items[indexPath.row]
        cell.itemNameLabel.text = item.name
        cell.itemDevelopedByLabel.text = item.developer
        if let imageName = item.imageName, let iconsURL: URL = ImageManager.shared.iconsURL {
            let fileURL: URL = iconsURL.appendingPathComponent(imageName)
            if let imageData: Data = try? Data(contentsOf: fileURL) {
                cell.iconImageView.image = UIImage(data: imageData)
            }
        }
        
        cell.tintColor = UIColor.white
        
        if item.fulfilled {
            cell.priceString = nil
            cell.accessoryType = .checkmark
            cell.itemNameLabel.textColor = UIColor.lightGray
            cell.itemDevelopedByLabel.textColor = UIColor.lightGray
        } else {
            cell.priceString = (item.price > 0 ? item.priceString : "FREE".localized)
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
        return true
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WishListItemTableViewCell.preferredCellHeight
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let tableViewSection: Section = self.sectionData[indexPath.section]
        if tableViewSection == .fulfilledItems {
            return nil
        }
        let markAction = UIContextualAction(style: .normal, title:  nil, handler: { (action: UIContextualAction, view: UIView, success:(Bool) -> Void) in
            let item: WishListItem = self.wishListItems[indexPath.row]
            DatabaseManager.shared.write {
                item.fulfilled = true
            }
            // delete row, insert row at indexPath(for item: WishListItem, in section: Section), instead of reloading two sections
            self.buildUI()
            success(true)
        })
        markAction.image = UIImage(named: "MarkRow")
        markAction.backgroundColor = UIColor.nephritis
        return UISwipeActionsConfiguration(actions: [markAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let tableViewSection: Section = self.sectionData[indexPath.section]
        let items = (tableViewSection == .items ? self.wishListItems : self.fulfilledItems)
        let item: WishListItem = items[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title:  nil, handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            success(true)
            // delete row in buildUI instead of reloading both sections
            DatabaseManager.shared.delete(object: item)
            self.buildUI()
//            tableView.beginUpdates()
//            DatabaseManager.shared.delete(object: item)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            tableView.endUpdates()
        })
        deleteAction.image = UIImage(named: "DeleteRow")
        deleteAction.backgroundColor = UIColor.alizarin
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let tableViewSection: Section = self.sectionData[indexPath.section]
        
        // maybe just open the appstore
        if tableViewSection == .items {
            let item: WishListItem = self.wishListItems[indexPath.row]
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
}

extension WishListTableViewController : SKStoreProductViewControllerDelegate {
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
