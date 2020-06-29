//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Abdul Basit on 21/06/20.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    // MARK: - Static Properties
    static let reuseIdentifier = "NoteTableViewCell"
    
    // MARK: - Properties
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentsLabel: UILabel!
    @IBOutlet var updatedAtLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
