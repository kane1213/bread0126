//
//  CollectionViewCell.swift
//  bread0126
//
//  Created by Mini on 2019/1/26.
//  Copyright © 2019年 Mini. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    var demoPhotoImageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        demoPhotoImageView = UIImageView()
        contentView.addSubview(demoPhotoImageView)
        demoPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        demoPhotoImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        demoPhotoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        demoPhotoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        demoPhotoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        backgroundColor = UIColor.darkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
