//
//  SelectListViewController.swift
//  WishApp
//
//  Created by Janosch Hübner on 28.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import UIKit

class SelectListViewController<T: Equatable>: UITableViewController {
    
    private var selectionHandler: ((_ value: T)->())? = nil
    private var titles: [String] = []
    private var values: [T] = []
    private var selectedValue: T!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public convenience init(withTitles titles: [String], values: [T], selectedValue: T, selectionHandler: @escaping (_ value: T)->()) {
        self.init(style: .grouped)
        
        self.tableView.rowHeight = 44.0
        
        self.titles = titles
        self.values = values
        self.selectedValue = selectedValue
        
        assert(self.titles.count == self.values.count, "Titles and values can not differ in count")
        
        self.selectionHandler = selectionHandler
        
        self.tableView.register(SelectListTableViewCell.self, forCellReuseIdentifier: "ListCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        self.view.backgroundColor = UIColor.darkJungleGreen
        self.title = ""
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! SelectListTableViewCell
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.tintColor = UIColor.white
        cell.backgroundColor = UIColor.dark
        let value = self.values[indexPath.row]
        if (value == self.selectedValue) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.shouldShowSeparator = (indexPath.row != self.titles.count-1)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectionHandler?(self.values[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}
