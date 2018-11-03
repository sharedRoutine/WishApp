//
//  PodLicensingViewController.swift
//  WishApp
//
//  Created by Janosch Hübner on 03.11.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import UIKit

class PodLicensingViewController: UITableViewController {

    private func loadAcknowledgements(fromFile file: String) -> PodAck? {
        guard let ackData = try? Data(contentsOf: URL(fileURLWithPath: file)) else {
            return nil
        }
        guard let podAck: PodAck = try? PropertyListDecoder().decode(PodAck.self, from: ackData) else {
            return nil
        }
        return podAck
    }
    
    private var licenses: [PodLicense] {
        get {
            if let ackPath = Bundle.main.path(forResource: "Acknowledgements", ofType: "plist"),
                let podAck = self.loadAcknowledgements(fromFile: ackPath) {
                var licenses = podAck.licenses.filter({ (license: PodLicense) -> Bool in
                    return license.title.count > 0 && license.content.count > 0
                })
                if let realmPath = Bundle.main.path(forResource: "Realm", ofType: "plist"), let realmAck = self.loadAcknowledgements(fromFile: realmPath) {
                    licenses.append(contentsOf: realmAck.licenses)
                }
                return licenses.sorted(by: { (license1: PodLicense, license2: PodLicense) -> Bool in
                    return license1.title < license2.title
                })
            }
            return []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.view.backgroundColor = UIColor.darkJungleGreen
        self.tableView.backgroundColor = UIColor.darkJungleGreen
        self.tableView.separatorStyle = .none
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LicensesCell")
        self.title = "ACKNOWLEDGEMENTS".localized
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.licenses.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LicensesCell", for: indexPath)
        let license: PodLicense = self.licenses[indexPath.section]
        cell.textLabel?.text = license.content
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.backgroundColor = UIColor.dark
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let license: PodLicense = self.licenses[section]
        return license.title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
