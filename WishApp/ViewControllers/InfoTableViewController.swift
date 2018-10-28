//
//  InfoTableViewController.swift
//  WishApp
//
//  Created by Janosch Hübner on 12.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import UIKit
import SUBLicenseViewController

class InfoTableViewController: UITableViewController {
    
    private var darkModeSwitch: UISwitch = UISwitch(frame: .zero)
    
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
        case licenses
        case darkMode
        case itemSorting
    }
    
    private var tableViewData: [(section: Section, rows: [Row])] = []
    
    private func buildRows() {
        self.tableViewData.removeAll()
        
        self.tableViewData.append((section: .settings, rows: [.itemSorting]))
        self.tableViewData.append((section: .credits, rows: [.developer, .designer]))
        self.tableViewData.append((section: .buyMeACoffee, rows: [.devCoffee]))
        self.tableViewData.append((section: .licenses, rows: [.licenses]))
        self.tableViewData.append((section: .appInfo, rows: []))
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        
        self.darkModeSwitch.addTarget(self, action: #selector(handleDarkMode(changed:)), for: .valueChanged)
        self.darkModeSwitch.isOn = SettingsManager.shared.darkModeEnabled
        self.darkModeSwitch.onTintColor = UIColor.peterRiver
        
        self.title = "WISH_APP_INFO".localized
        
        self.tableView.backgroundColor = UIColor.darkJungleGreen
        self.view.backgroundColor = UIColor.darkJungleGreen
        self.tableView.separatorColor = UIColor.dark
        
        self.tableView.register(CreditsTableViewCell.self, forCellReuseIdentifier: "CreditsCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "InfoCell")
        self.tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "VersionView")
        
        self.buildRows()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleDarkMode(changed: UISwitch) {
        let darkModeEnabled: Bool = SettingsManager.shared.darkModeEnabled
        SettingsManager.shared.toggle(darkMode: !darkModeEnabled)
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
        } else if section == .settings {
            let cell: SettingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
            makeUI(for: cell)
            cell.accessoryView = nil
            if row == .darkMode {
                cell.textLabel?.text = "DARK_MODE".localized
                cell.accessoryView = self.darkModeSwitch
            } else if row == .itemSorting {
                cell.textLabel?.text = "SORT_ITEMS".localized
                let sortOption = SettingsManager.shared.sortOption
                switch sortOption {
                case .byName:
                    cell.detailTextLabel?.text = "BY_NAME".localized
                case .byDate:
                    cell.detailTextLabel?.text = "BY_DATE".localized
                case .byPrice:
                    cell.detailTextLabel?.text = "BY_PRICE".localized
                }
            }
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
        makeUI(for: cell)
        
        cell.accessoryView = nil
        
        switch section {
        case .buyMeACoffee:
            switch row {
            case .devCoffee:
                cell.textLabel?.text = "BUY_ME_A_COFFEE".localized
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
        case .buyMeACoffee:
            return "LIKE_THE_APP".localized
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
            UIApplication.shared.open(URL(string: "https://twitter.com/sharedRoutine")!, options: [:], completionHandler: nil)
            break
        case .designer:
            UIApplication.shared.open(URL(string: "https://twitter.com/AVIROK1")!, options: [:], completionHandler: nil)
            break
        case .devCoffee:
            UIApplication.shared.open(URL(string: "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=DMXRMVSS35UCQ")!, options: [:], completionHandler: nil)
        case .itemSorting:
            let titles = SortOption.allCases.map({ (opt: SortOption) -> String in
                switch opt {
                case .byName:
                    return "BY_NAME".localized
                case .byDate:
                    return "BY_DATE".localized
                case .byPrice:
                    return "BY_PRICE".localized
                }
            })
            let selectSortOptionViewController = SelectListViewController<SortOption>(withTitles: titles, values: SortOption.allCases, selectedValue: SettingsManager.shared.sortOption) { (opt: SortOption) in
                SettingsManager.shared.sortOption = opt
                
                NotificationCenter.default.post(name: NSNotification.Name.sortOptionDidChange, object: nil)
                
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
            selectSortOptionViewController.title = "SELECT_SORT_OPTION".localized
            self.navigationController?.pushViewController(selectSortOptionViewController, animated: true)
        case .licenses:
            let licensesViewController: SUBLicenseViewController = SUBLicenseViewController()
            self.navigationController?.pushViewController(licensesViewController, animated: true)
        default:
            break
        }
    }
}
