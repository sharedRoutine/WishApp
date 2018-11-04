//
//  WishListItemTableViewCell.swift
//  WishApp
//
//  Created by Janosch Hübner on 08.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import UIKit

class WishListItemTableViewCell: UITableViewCell {

    public private(set) var iconImageView: UIImageView!
    public private(set) var itemNameLabel: UILabel!
    public private(set) var itemDevelopedByLabel: UILabel!
    
    private var priceLabel: UILabel!
    
    private var separatorView: UIView!
    
    private let iconSize: CGSize = CGSize(width: 50.0, height: 50.0)
    
    public static var preferredCellHeight: CGFloat {
        get {
            return 60.0
        }
    }
    
    public var priceString: String? {
        didSet {
            if let price = self.priceString {
                self.priceLabel.text = price
                self.accessoryView = self.priceLabel
            } else {
                self.accessoryView = nil
            }
        }
    }
    
    public var shouldShowSeparator: Bool {
        get {
            return !self.separatorView.isHidden
        }
        set {
            self.separatorView.isHidden = !newValue
        }
    }
    
    public var separatorColor: UIColor? {
        get {
            return self.separatorView.backgroundColor
        }
        set {
            self.separatorView.backgroundColor = newValue
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.darkJungleGreen
        
        self.priceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 70.0, height: 30.0))
        self.priceLabel.font = UIFont.systemFont(ofSize: 16.0)
        self.priceLabel.adjustsFontSizeToFitWidth = true
        self.priceLabel.textAlignment = .center
        self.priceLabel.layer.cornerRadius = 10.0
        self.priceLabel.layer.masksToBounds = true
        self.priceLabel.textColor = UIColor.dark
        self.priceLabel.backgroundColor = UIColor.white
        
        let selectedView = UIView(frame: .zero)
        selectedView.backgroundColor = UIColor.darkGray
        self.selectedBackgroundView = selectedView
        
        self.iconImageView = UIImageView(frame: .zero)
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.iconImageView.layer.cornerRadius = 10.0
        self.iconImageView.layer.masksToBounds = true
        self.contentView.addSubview(self.iconImageView)
        
        self.iconImageView.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor).isActive = true
        self.iconImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.iconImageView.widthAnchor.constraint(equalToConstant: self.iconSize.width).isActive = true
        self.iconImageView.heightAnchor.constraint(equalToConstant: self.iconSize.height).isActive = true
        
        self.itemNameLabel = UILabel(frame: .zero)
        self.itemNameLabel.textColor = UIColor.white
        self.itemNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        self.itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.itemNameLabel.lineBreakMode = .byTruncatingTail
        self.contentView.addSubview(self.itemNameLabel)
        
        self.itemNameLabel.bottomAnchor.constraint(equalTo: self.iconImageView.centerYAnchor).isActive = true
        self.itemNameLabel.leftAnchor.constraint(equalTo: self.iconImageView.rightAnchor, constant: 10.0).isActive = true
        self.itemNameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5.0).isActive = true
        self.itemNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10.0).isActive = true
        
        self.itemDevelopedByLabel = UILabel(frame: .zero)
        self.itemDevelopedByLabel.textColor = UIColor.white
        self.itemDevelopedByLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        self.itemDevelopedByLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.itemDevelopedByLabel)
        
        self.itemDevelopedByLabel.topAnchor.constraint(equalTo: self.iconImageView.centerYAnchor).isActive = true
        self.itemDevelopedByLabel.leftAnchor.constraint(equalTo: self.itemNameLabel.leftAnchor).isActive = true
        self.itemDevelopedByLabel.rightAnchor.constraint(equalTo: self.itemNameLabel.rightAnchor).isActive = true
        self.itemDevelopedByLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10.0).isActive = true
        
        self.separatorView = UIView(frame: .zero)
        self.separatorView.isHidden = true
        self.separatorView.backgroundColor = UIColor.darkJungleGreen
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.separatorView)
        
        self.separatorView.leftAnchor.constraint(equalTo: self.iconImageView.leftAnchor).isActive = true
        self.separatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.separatorView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.priceLabel.backgroundColor = UIColor.white
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        self.priceLabel.backgroundColor = UIColor.white
    }
}
