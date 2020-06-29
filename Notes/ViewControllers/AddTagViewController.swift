//
//  AddTagViewController.swift
//  Notes
//
//  Created by Abdul Basit on 24/06/20.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import CoreData

class AddTagViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var textField: UITextField!

    //MARK: - Properties
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        guard let managedObjectContext = managedObjectContext else { return }
        guard let title = textField.text, !title.isEmpty else {
            showAlert(with: "Title Missing", and: "Your note doesn't have a title.")
            return
        }
        let tag = Tag(context: managedObjectContext)
        tag.name = title
        // Pop View Controller
        _ = navigationController?.popViewController(animated: true)
    }
}
