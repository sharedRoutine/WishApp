//
//  SelectListTableViewCell.swift
//  WishApp
//
//  Created by Janosch Hübner on 28.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import UIKit

class SelectListTableViewCell: UITableViewCell {
    
    private var separatorView: UIView!
    
    public var shouldShowSeparator: Bool {
        get {
            return !self.separatorView.isHidden
        }
        set {
            self.separatorView.isHidden = !newValue
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        let selectedView = UIView(frame: .zero)
        selectedView.backgroundColor = UIColor.darkGray
        self.selectedBackgroundView = selectedView
        
        self.separatorView = UIView(frame: .zero)
        self.separatorView.isHidden = true
        self.separatorView.backgroundColor = UIColor.darkJungleGreen
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.separatorView)
        
        if let txtLabel = self.textLabel {
            self.separatorView.leftAnchor.constraint(equalTo: txtLabel.leftAnchor).isActive = true
        } else {
            self.separatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        }
        self.separatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.separatorView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
