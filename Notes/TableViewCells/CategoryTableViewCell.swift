//
//  CategoryTableViewCell.swift
//  Notes
//
//  Created by Abdul Basit on 22/06/20.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var categoryLabel: UILabel!
    
    //MARK: - Static properties
    static var reuseIdentifier = "CategoryTableViewCell"
}
