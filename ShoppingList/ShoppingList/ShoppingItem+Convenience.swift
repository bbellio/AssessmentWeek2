//
//  ShoppingItem+Convenience.swift
//  ShoppingList
//
//  Created by Bethany Wride on 9/27/19.
//  Copyright © 2019 Bethany Wride. All rights reserved.
//

import Foundation
import CoreData

extension ShoppingItem {
    @discardableResult
    convenience init(name: String, isComplete: Bool = false, dateCreated: Date = Date(), moc: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: moc)
        self.name = name
        self.isComplete = isComplete
        self.dateCreated = dateCreated
    }
}
