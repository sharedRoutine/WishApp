//
//  InfoHeaderView.swift
//  WishApp
//
//  Created by Janosch Hübner on 17.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import UIKit

class InfoHeaderView: UIView {

    private var iconImageView: UIImageView!
    
    private let iconSize: CGSize = CGSize(width: 60.0, height: 60.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.iconImageView = UIImageView(frame: .zero)
        self.iconImageView.image = UIImage(named: "AppIcon")
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.layer.cornerRadius = self.iconSize.width / 2.0
        self.iconImageView.layer.borderColor = UIColor.white.cgColor
        self.iconImageView.layer.borderWidth = 1.0
        self.iconImageView.layer.masksToBounds = true
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.iconImageView)
        
        self.iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.iconImageView.widthAnchor.constraint(equalToConstant: self.iconSize.width).isActive = true
        self.iconImageView.heightAnchor.constraint(equalToConstant: self.iconSize.height).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
