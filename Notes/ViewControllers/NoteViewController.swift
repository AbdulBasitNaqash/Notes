//
//  NoteViewController.swift
//  Notes
//
//  Created by Abdul Basit on 21/06/20.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    //MARK: - Properties
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Note"
        setupViews()
        setupNotificationHandling()
    }
    
    // MARK: - Helper Methods
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: note?.managedObjectContext)
    }
    
    // MARK: - Notification Handling
    @objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> else { return }
        if (updates.filter { return $0 == note }).count > 0 {
            updateCategoryLabel()
            updateTagsLabel()
        }
    }
    
    private func updateCategoryLabel() {
        // Configure Category Label
        categoryLabel.text = note?.category?.name ?? "No Category"
    }
    
    private func updateTagsLabel() {
        tagLabel.text = note?.alphabetizedTagsAsString ?? "No Tags"
    }
    
    //MARK: - Setup title and description views
    private func setupViews() {
        titleTextField.text = note?.title
        descriptionTextView.text = note?.contents
        updateCategoryLabel()
        updateTagsLabel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Update Note
        if let title = titleTextField.text, !title.isEmpty, let contents = descriptionTextView.text, !contents.isEmpty {
            note?.title = title
            note?.contents = contents
            note?.updatedAt = Date()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "Categories":
            guard let destination = segue.destination as? CategoriesViewController else {
                return
            }
            // Configure Destination
            destination.note = note
        case "Tags":
            guard let destination = segue.destination as? TagsViewController else {
                return
            }
            // Configure Destination
            destination.note = note
        default:
            break
        }
    }
}
