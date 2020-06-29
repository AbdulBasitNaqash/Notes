//
//  ViewController.swift
//  Notes
//
//  Created by Abdul Basit on 31/05/20.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    //MARK: - Properties
    private var coreDataManager: CoreDataManager = CoreDataManager(modelName: "Notes")
    var notesDidChange: Bool = false
    
    private var hasNotes: Bool {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else {return false}
        return fetchedObjects.count > 0
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        fetchNotes()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        updateView()
    }
    
//    @objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
//        guard let userInfo = notification.userInfo else { return }
//        notesDidChange = false
//
//         if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
//            for insert in inserts {
//                if let note = insert as? Note {
//                    notes?.append(note)
//                    notesDidChange = true
//                }
//            }
//        }
//        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
//            for update in updates {
//                if let _ = update as? Note {
//                    notesDidChange = true
//                }
//            }
//        }
//        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
//            for delete in deletes {
//                if let note = delete as? Note {
//                    if let index = notes?.firstIndex(of: note) {
//                        notes?.remove(at: index)
//                        notesDidChange = true
//                    }
//                }
//            }
//        }
//
//        if notesDidChange {
//            // Sort Notes
//            notes?.sort(by: { $0.updatedAt ?? Date() > $1.updatedAt ?? Date() })
//            // Update Table View
//            tableView.reloadData()
//            // Update View
//            updateView()
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "AddNote":
            guard let destination = segue.destination as? AddNoteViewController else {
                return }
            // Configure Destination
            destination.managedObjectContext = coreDataManager.mainManagedObjectContext
        case "Note":
            guard let destination = segue.destination as? NoteViewController else {return}
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let note = fetchedResultsController.object(at: indexPath)
            destination.note = note
        default:
            break
        }
    }
    
    //MARK: - Fetch Notes
    private func fetchNotes() {
//        do {
//            try fetchedResultsController.performFetch()
//        }
//        catch {
//            print("Unable to Perform Fetch Request")
//            print("\(error), \(error.localizedDescription)")
//        }
        coreDataManager.mainManagedObjectContext.perform {
            do {
                let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
                let notes = try fetchRequest.execute()
                if let note = notes.first {
                    print(note.title ?? "***")
                    if let tags = note.tags as? Set<Tag> {
                        print(tags)
                        for tag in tags {
                            print(tag.name ?? "")
                        }
                    }
                }
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
    
    //MARK: - Update View
    private func updateView() {
        tableView.isHidden = !hasNotes
        messageLabel.isHidden = hasNotes
    }
}

extension NotesViewController: UITableViewDelegate {
    
}

extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {return 0}
        
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as? NoteTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        configure(cell, at: indexPath)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else {return 0}
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        let note = fetchedResultsController.object(at: indexPath)
        
        //Delete note
        coreDataManager.mainManagedObjectContext.delete(note)
    }
    
    func configure(_ cell: NoteTableViewCell, at indexPath: IndexPath) {
        // Fetch Note
        let note = fetchedResultsController.object(at: indexPath)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM-dd-YYYY"
        
        // Configure Cell
        cell.titleLabel.text = note.title
        cell.contentsLabel.text = note.contents
        cell.tagLabel.text = note.alphabetizedTagsAsString ?? "No Tags"
        if let updatedAt = note.updatedAt {
            let updatedAtDate = Date(timeIntervalSince1970: updatedAt.timeIntervalSince1970)
            cell.updatedAtLabel.text = formatter.string(from: updatedAtDate)
        }
    }
}

extension NotesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell {
                configure(cell, at: indexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        default:
            break
        }
    }
}
