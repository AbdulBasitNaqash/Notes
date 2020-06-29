//
//  CategoriesViewController.swift
//  Notes
//
//  Created by Abdul Basit on 22/06/20.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var note: Note?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Category.name), ascending: false)]
        
        guard let managedObjectContext = note?.managedObjectContext else { fatalError("No managed object context found") }
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         fetchCategories()

        title = "Categories"
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    //MARK: - Fetch Categories
    private func fetchCategories() {
       do {
           try fetchedResultsController.performFetch()
       }
       catch {
           print("Unable to Perform Fetch Request")
           print("\(error), \(error.localizedDescription)")
       }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "AddCategory":
            guard let destination = segue.destination as? AddCategoryViewController else {
                return }
            // Configure Destination
            destination.managedObjectContext = note?.managedObjectContext
        case "Category":
            guard let destination = segue.destination as? CategoryViewController else {return}
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let category = fetchedResultsController.object(at: indexPath)
            destination.category = category
        default:
            break
        }
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {return 0}
        
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath) as? CategoryTableViewCell else {
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
        let category = fetchedResultsController.object(at: indexPath)
        
        //Delete category
        note?.managedObjectContext?.delete(category)
    }
    
    func configure(_ cell: CategoryTableViewCell, at indexPath: IndexPath) {
        // Fetch Category
        let category = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.categoryLabel.text = category.name
        if note?.category == category {
            cell.categoryLabel.textColor = .green
        } else {
            cell.categoryLabel.textColor = .black
        }
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Fetch Category
        let category = fetchedResultsController.object(at: indexPath)
        
        // Update Note
        note?.category = category
        
        // Pop View Controller From Navigation Stack
        let _ = navigationController?.popViewController(animated: true)
    }
}

extension CategoriesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
          tableView.beginUpdates()
      }
      
      func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
          tableView.endUpdates()
      }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell {
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
