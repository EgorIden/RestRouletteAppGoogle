//
//  BottomMenuCell.swift
//  RestRouletteAppGoogle
//
//  Created by Egor on 02/05/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

class BottomMenuCell: UICollectionViewCell{
    
    var menuCategory: MenuCategory? {
        didSet{
            imageIcon.image = self.menuCategory?.image
            iconText.text = self.menuCategory?.name
        }
    }
    
    let imageIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "beer")
        img.contentMode = .scaleAspectFill
        img.sizeToFit()
        return img
    }()
    
    let iconText: UILabel = {
        let font = UIFont.boldSystemFont(ofSize: 14)
        let lbl = UILabel()
        lbl.font = font
        lbl.text = "Категории"
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blue.withAlphaComponent(0.05)
        self.layer.cornerRadius = 6

        self.addSubview(imageIcon)
        self.addSubview(iconText)
        
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContraints() {
        
        imageIcon.translatesAutoresizingMaskIntoConstraints = false
        iconText.translatesAutoresizingMaskIntoConstraints = false
        
        imageIcon.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageIcon.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        let imageTopConstraint = NSLayoutConstraint(item: imageIcon, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 12)
        let imageCenterConstraint = NSLayoutConstraint(item: imageIcon, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let textTopConstraint = NSLayoutConstraint(item: iconText, attribute: .top, relatedBy: .equal, toItem: imageIcon, attribute: .bottom, multiplier: 1.0, constant: 8)
        let textCenterConstraint = NSLayoutConstraint(item: iconText, attribute: .centerX, relatedBy: .equal, toItem: imageIcon, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        self.addConstraints([imageTopConstraint, imageCenterConstraint, textTopConstraint, textCenterConstraint])
    }
}
