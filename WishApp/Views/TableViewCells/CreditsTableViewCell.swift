//
//  CreditsTableViewCell.swift
//  WishApp
//
//  Created by Janosch Hübner on 17.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import UIKit

class CreditsTableViewCell: UITableViewCell {

    public private(set) var profileImageView: UIImageView!
    public private(set) var nameLabel: UILabel!
    public private(set) var jobLabel: UILabel!
    
    private var separatorView: UIView!
    
    private let iconSize: CGSize = CGSize(width: 60.0, height: 60.0)
    
    public static let preferredCellHeight: CGFloat = 80.0
    
    public var shouldShowSeparator: Bool {
        get {
            return !self.separatorView.isHidden
        }
        set {
            self.separatorView.isHidden = !newValue
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.profileImageView = UIImageView(frame: .zero)
        self.profileImageView.contentMode = .scaleAspectFit
        self.profileImageView.layer.cornerRadius = self.iconSize.width / 2.0
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        self.profileImageView.layer.borderWidth = 1.0
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.profileImageView)
        
        self.profileImageView.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor).isActive = true
        self.profileImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: self.iconSize.width).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: self.iconSize.height).isActive = true
        
        self.nameLabel = UILabel(frame: .zero)
        self.nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        self.nameLabel.textColor = UIColor.white
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.nameLabel)
        
        self.nameLabel.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 10.0).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: self.profileImageView.centerYAnchor).isActive = true
        self.nameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10.0).isActive = true
        
        self.jobLabel = UILabel(frame: .zero)
        self.jobLabel.textColor = UIColor.white
        self.jobLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        self.jobLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.jobLabel)
        
        self.jobLabel.topAnchor.constraint(equalTo: self.profileImageView.centerYAnchor).isActive = true
        self.jobLabel.leftAnchor.constraint(equalTo: self.nameLabel.leftAnchor).isActive = true
        self.jobLabel.rightAnchor.constraint(equalTo: self.nameLabel.rightAnchor).isActive = true
        self.jobLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10.0).isActive = true
        
        self.separatorView = UIView(frame: .zero)
        self.separatorView.isHidden = true
        self.separatorView.backgroundColor = UIColor.darkJungleGreen
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.separatorView)
        
        self.separatorView.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor).isActive = true
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
