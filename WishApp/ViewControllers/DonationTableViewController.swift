//
//  DonationTableViewController.swift
//  WishApp
//
//  Created by Janosch Hübner on 06.11.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import UIKit
import StoreKit

class DonationTableViewController: UITableViewController {

    private enum Section {
        case smallCoffee
        case largeCoffee
        case allCoffees
        case information
    }
    
    private enum Row {
        case coffee
    }
    
    private var tableViewData: [(section: Section, rows: [Row])] = []
    
    private func buildRows() {
        self.tableViewData.removeAll()
        self.tableViewData.append((section: .smallCoffee, rows: [.coffee]))
        self.tableViewData.append((section: .largeCoffee, rows: [.coffee]))
        self.tableViewData.append((section: .allCoffees, rows: [.coffee]))
        self.tableViewData.append((section: .information, rows: []))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InAppPurchaseManager.shared.delegate = self
        
        if InAppPurchaseManager.shared.products.count <= 0 {
            InAppPurchaseManager.shared.load(products: ["buy_me_a_coffee_1", "buy_me_a_coffee_2", "buy_me_a_coffee_3"])
        }
        
        self.buildRows()
        
        self.title = "DONATIONS".localized
        
        self.tableView.backgroundColor = UIColor.darkJungleGreen
        self.view.backgroundColor = UIColor.darkJungleGreen
        self.tableView.separatorColor = UIColor.dark
        
        self.tableView.register(SimpleValueCell.self, forCellReuseIdentifier: "DonationCell")
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableViewData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SimpleValueCell = tableView.dequeueReusableCell(withIdentifier: "DonationCell", for: indexPath) as! SimpleValueCell
        let section: Section = self.tableViewData[indexPath.section].section
        switch section {
        case .smallCoffee:
            cell.textLabel?.text = "BUY_ME_A_SMALL_COFFEE".localized
        case .largeCoffee:
            cell.textLabel?.text = "BUY_ME_A_LARGE_COFFEE".localized
        case .allCoffees:
            cell.textLabel?.text = "BUY_ME_ALL_THE_COFFEES".localized
        default:
            break
        }
        
        let products: [SKProduct] = InAppPurchaseManager.shared.products
        if indexPath.section < products.count {
            let product = products[indexPath.section]
            let formatter: NumberFormatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = product.priceLocale
            cell.detailTextLabel?.text = formatter.string(from: product.price)
        } else {
            cell.detailTextLabel?.text = "LOADING".localized
        }
        
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.dark
        cell.tintColor = UIColor.white
        cell.accessoryType = .disclosureIndicator
        
        let selectedView = UIView(frame: .zero)
        selectedView.backgroundColor = UIColor.darkGray
        cell.selectedBackgroundView = selectedView
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let products: [SKProduct] = InAppPurchaseManager.shared.products
        if indexPath.section < products.count {
            let product = products[indexPath.section]
            if InAppPurchaseManager.shared.checkout(withProduct: product) {
                // checkout complete
            } else {
                let infoAlert: UIAlertController = UIAlertController(title: "PURCHASE_ERROR".localized, message: "PURCHASE_ERROR_DESCR".localized, preferredStyle: .alert)
                infoAlert.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: nil))
                self.present(infoAlert, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tableViewSection: Section = self.tableViewData[section].section
        
        switch tableViewSection {
        case .smallCoffee:
            return "☕️"
        case .largeCoffee:
            return "☕️☕️"
        case .allCoffees:
            return "☕️☕️☕️"
        case .information:
            return "DONATION_INFO".localized
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let tableViewSection: Section = self.tableViewData[section].section
        if tableViewSection == .information {
            return "DONATION_INFO_TEXT".localized
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let tableViewSection: Section = self.tableViewData[section].section
        if tableViewSection == .information {
            
        }
        return nil
    }
}

extension DonationTableViewController : InAppPurchaseDelegate {
    
    func manager(manager: InAppPurchaseManager, didLoad products: [SKProduct]) {
        self.tableView.reloadData()
    }
    
    func managerDidRegisterPurchase(manager: InAppPurchaseManager) {
        let infoAlert: UIAlertController = UIAlertController(title: "THANK_YOU".localized, message: "THANK_YOU_PURCHASE".localized, preferredStyle: .alert)
        infoAlert.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: nil))
        self.present(infoAlert, animated: true, completion: nil)
    }
}
