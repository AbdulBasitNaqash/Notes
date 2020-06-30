//
//  NoteViewController.swift
//  Notes
//
//  Created by Abdul Basit on 04/06/20.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var titleTextField
    : UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: - Properties
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - Save
    @IBAction func save(sender: UIBarButtonItem) {
        guard let managedObjectContext = managedObjectContext else { return }
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(with: "Title Missing", and: "Your note doesn't have a title.")
            return
        }
        guard let contents = descriptionTextView.text, !contents.isEmpty else {
            showAlert(with: "contents Missing", and: "Your note doesn't have contents.")
            return
        }
        // Create Note
        let note = Note(context: managedObjectContext)
        // Configure Note
        note.createdAt = Date()
        note.updatedAt = Date()
        note.title = title
        note.contents = contents
        // Pop View Controller
        _ = navigationController?.popViewController(animated: true)

    }
}
