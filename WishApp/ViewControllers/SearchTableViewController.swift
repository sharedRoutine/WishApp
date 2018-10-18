//
//  SearchTableViewController.swift
//  WishApp
//
//  Created by Janosch Hübner on 18.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import UIKit
import SDWebImage

class SearchTableViewController: UITableViewController {
    
    private var searchController: UISearchController!
    private var searchResult: AppSearchResult? = nil
    
    private var priceFormatter: NumberFormatter = NumberFormatter()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    convenience init() {
        self.init(style: .grouped)
        
        self.priceFormatter.allowsFloats = true
        self.priceFormatter.locale = Locale.current
        self.priceFormatter.numberStyle = .currency
        
        self.title = "SEARCH_APPS".localized
        
        self.edgesForExtendedLayout = .top
        
        self.tableView.register(WishListItemTableViewCell.self, forCellReuseIdentifier: "AppCell")
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.darkJungleGreen
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.scopeButtonTitles = []
        self.searchController.searchBar.barTintColor = UIColor.dark
        self.searchController.searchBar.tintColor = UIColor.white
        self.searchController.searchBar.sizeToFit()
        
        if let subview = self.searchController.searchBar.subviews.first {
            if let textField = subview.subviews.filter( { view in
                return view is UITextField
            }).first as? UITextField {
                textField.tintColor = UIColor.white
                textField.backgroundColor = UIColor.dark
                textField.textColor = UIColor.white
            } else {
                print("No textfield found :(")
            }
        }
        
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.definesPresentationContext = true
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResult?.apps.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WishListItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath) as! WishListItemTableViewCell
        
        let app: App = self.searchResult!.apps[indexPath.row]
        cell.itemNameLabel.text = app.name
        cell.itemDevelopedByLabel.text = app.developer
        cell.priceString = (app.isFree ? "FREE".localized : self.priceFormatter.string(from: NSNumber(value: app.price)))
        cell.iconImageView.sd_setImage(with: URL(string: app.iconFile), placeholderImage: nil, options: .highPriority, completed: nil)
        cell.iconImageView.layer.cornerRadius = 8.0
        cell.iconImageView.layer.masksToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WishListItemTableViewCell.preferredCellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell: WishListItemTableViewCell = tableView.cellForRow(at: indexPath) as! WishListItemTableViewCell
        
        let app: App = self.searchResult!.apps[indexPath.row]
        let item: WishListItem = WishListItem(with: app)
        if let cellImage = cell.iconImageView.image, let fileName = ImageManager.shared.save(image: cellImage, for: item.bundleIdentifier) {
            item.imageName = fileName
        }
        DatabaseManager.shared.write(object: item)
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString: String = searchController.searchBar.text, searchString.count > 0 else {
            return
        }
        iTunesSearchAPI.shared.loadApps(for: searchString, limit: 10) { (_ result: AppSearchResult?) in
            self.searchResult = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchTableViewController : UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.searchBar.text = ""
        self.searchResult = nil
        self.tableView.reloadData()
    }
}
