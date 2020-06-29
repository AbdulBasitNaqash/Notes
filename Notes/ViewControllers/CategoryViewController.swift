//
//  CategoryViewController.swift
//  Notes
//
//  Created by Abdul Basit on 22/06/20.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var textField: UITextField!
    
    //MARK: - Properties
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = category?.name
    }
}
