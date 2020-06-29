//
//  TagsTableViewCell.swift
//  Notes
//
//  Created by Abdul Basit on 24/06/20.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

class TagsTableViewCell: UITableViewCell {

    //MARK: - Static Properties
    static let reuseIdentifier = "TagsTableViewCell"
    
    //MARK: - IBOutlets
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
