//
//  InfoTableViewController.swift
//  WishApp
//
//  Created by Janosch Hübner on 12.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import UIKit

class InfoTableViewController: UITableViewController {
    
    private enum Section {
        case appInfo
        case credits
        case buyMeACoffee
        case licenses
        case settings
    }
    
    private enum Row {
        case developer
        case designer
        case devCoffee
        case designerCoffee
        case licenses
        case darkMode
    }
    
    private var tableViewData: [(section: Section, rows: [Row])] = []
    
    private func buildRows() {
        self.tableViewData.removeAll()
        
        self.tableViewData.append((section: .settings, rows: [.darkMode]))
        self.tableViewData.append((section: .credits, rows: [.developer, .designer]))
        self.tableViewData.append((section: .buyMeACoffee, rows: [.devCoffee, .designerCoffee]))
        self.tableViewData.append((section: .licenses, rows: [.licenses]))
        self.tableViewData.append((section: .appInfo, rows: []))
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        
        self.title = "WISH_APP_INFO".localized
        
        self.tableView.backgroundColor = UIColor.darkJungleGreen
        self.view.backgroundColor = UIColor.darkJungleGreen
        self.tableView.separatorColor = UIColor.dark
        
        self.tableView.register(CreditsTableViewCell.self, forCellReuseIdentifier: "CreditsCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "InfoCell")
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "VersionView")
        
        self.buildRows()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneButton(pressed:)))
    }
    
    @objc private func handleDoneButton(pressed: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    // Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableViewData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        func makeUI(for cell: UITableViewCell) {
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor.dark
            cell.tintColor = UIColor.white
            
            let selectedView = UIView(frame: .zero)
            selectedView.backgroundColor = UIColor.darkGray
            cell.selectedBackgroundView = selectedView
        }
        
        let section: Section = self.tableViewData[indexPath.section].section
        let row: Row = self.tableViewData[indexPath.section].rows[indexPath.row]
        
        if section == .credits {
            let creditsCell: CreditsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CreditsCell", for: indexPath) as! CreditsTableViewCell
            switch row {
            case .developer:
                creditsCell.nameLabel.text = "Janosch Hübner"
                creditsCell.jobLabel.text = "Developer"
                creditsCell.profileImageView.image = UIImage(named: "sharedRoutine")
                creditsCell.shouldShowSeparator = true
            case .designer:
                creditsCell.nameLabel.text = "Aviorrok"
                creditsCell.jobLabel.text = "Designer"
                creditsCell.profileImageView.image = UIImage(named: "aviorrok")
                creditsCell.shouldShowSeparator = false
            default:
                break
            }
            makeUI(for: creditsCell)
            return creditsCell
        }
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
        makeUI(for: cell)
        
        switch section {
        case .settings:
            cell.textLabel?.text = "DARK_MODE".localized
            cell.accessoryType = .none
        case .buyMeACoffee:
            switch row {
            case .devCoffee:
                cell.textLabel?.text = "BUY_ME_A_COFFEE".localized
            case .designerCoffee:
                cell.textLabel?.text = "DESIGNER_INFO".localized
            default:
                break
            }
        case .licenses:
            cell.textLabel?.text = "LICENSES".localized
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section: Section = self.tableViewData[indexPath.section].section
        if section == .credits {
            return CreditsTableViewCell.preferredCellHeight
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section: Section = self.tableViewData[section].section
        switch section {
        case .credits:
            return "CREDITS".localized
        case .settings:
            return "SETTINGS".localized
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableViewSection: Section = self.tableViewData[section].section
        if tableViewSection == .appInfo {
            var versionView: UITableViewHeaderFooterView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "VersionView")
            if versionView == nil {
                versionView = UITableViewHeaderFooterView(reuseIdentifier: "VersionView")
            }
            versionView?.textLabel?.text = "WishApp v\(WishApp.appVersion)"
            versionView?.textLabel?.textAlignment = .center
            return versionView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row: Row = self.tableViewData[indexPath.section].rows[indexPath.row]
        
        switch row {
        case .developer:
            break
        case .designer:
            break
        default:
            break
        }
    }
}
