//
//  ShoppingItemListTableViewController.swift
//  ShoppingList
//
//  Created by Bethany Wride on 9/27/19.
//  Copyright © 2019 Bethany Wride. All rights reserved.
//

import UIKit
import CoreData

class ShoppingItemListTableViewController: UITableViewController {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ShoppingItemController.sharedInstance.fetchedResultsController.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func newShoppingItemTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add a Shopping Item", message: "Please Add a Shopping Item to Your List", preferredStyle: .alert)
        let addItemButton = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let newItem = alert.textFields?[0].text else { return }
            ShoppingItemController.sharedInstance.addShoppingItem(with: newItem)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addTextField { (_) in
        }
        alert.addAction(addItemButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ShoppingItemController.sharedInstance.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingItemController.sharedInstance.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingItemCell", for: indexPath) as? ShoppingItemTableViewCell else { return UITableViewCell()}
        let shoppingItem = ShoppingItemController.sharedInstance.fetchedResultsController.object(at: indexPath)
        cell.delegate = self
        cell.update(shoppingItem: shoppingItem)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let shoppingItem = ShoppingItemController.sharedInstance.fetchedResultsController.object(at: indexPath)
            ShoppingItemController.sharedInstance.delete(shoppingItem: shoppingItem)
        }    
    }
}

    // MARK: - Class Extensions
// ShoppingItemTableViewCellDelegate
extension ShoppingItemListTableViewController: ShoppingItemTableViewCellDelegate {
    func buttonTapped(_ sender: ShoppingItemTableViewCell) {
        guard let index = tableView.indexPath(for: sender) else { return }
        let shoppingItem = ShoppingItemController.sharedInstance.fetchedResultsController.object(at: index)
        ShoppingItemController.sharedInstance.toggleIsCompleteFor(shoppingItem: shoppingItem)
        sender.update(shoppingItem: shoppingItem)
    }
}

// NSFetchedResultsControllerDelegate
extension ShoppingItemListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        default: return
        }
    }
}



