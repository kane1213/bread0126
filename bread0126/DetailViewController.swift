//
//  DetailViewController.swift
//  bread0126
//
//  Created by Mini on 2019/2/15.
//  Copyright © 2019 Mini. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var titleLabel: UILabel!
    var detailImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        titleLabel.text = "HERE"
        
        detailImg = UIImageView()
        view.addSubview(detailImg)
        detailImg.translatesAutoresizingMaskIntoConstraints = false
        detailImg.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        detailImg.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        detailImg.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        detailImg.heightAnchor.constraint(equalToConstant: 300).isActive = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
