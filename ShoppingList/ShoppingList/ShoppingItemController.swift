//
//  ShoppingItemController.swift
//  ShoppingList
//
//  Created by Bethany Wride on 9/27/19.
//  Copyright © 2019 Bethany Wride. All rights reserved.
//

import Foundation
import CoreData

class ShoppingItemController {
    // MARK: - Global Variables
    static let sharedInstance = ShoppingItemController()
    
    // FetchedResultsController
    var fetchedResultsController: NSFetchedResultsController<ShoppingItem>
    init() {
        let fetchRequest: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
        let dateCreatedSort = NSSortDescriptor(key: "dateCreated", ascending: true)
        fetchRequest.sortDescriptors = [dateCreatedSort]
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController = resultsController
        do {
            try fetchedResultsController.performFetch()
        } catch {
             print("Error performing fetch: \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    // MARK: - CRUD
    // Create
    func addShoppingItem(with name: String) {
        ShoppingItem(name: name)
        saveToPersistentStore()
    }
    
    // Update
    func update(shoppingItem: ShoppingItem, with name: String) {
        shoppingItem.name = name
        saveToPersistentStore()
    }
    
    // Delete
    func delete(shoppingItem: ShoppingItem) {
        CoreDataStack.context.delete(shoppingItem)
        saveToPersistentStore()
    }
    
    // Toggle
    func toggleIsCompleteFor(shoppingItem: ShoppingItem) {
        shoppingItem.isComplete = !shoppingItem.isComplete
        saveToPersistentStore()
    }
    
    // MARK: - Persistence
    func saveToPersistentStore() {
        if CoreDataStack.context.hasChanges {
            try? CoreDataStack.context.save()
        }
    }
}
