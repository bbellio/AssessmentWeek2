//
//  ShoppingItemTableViewCell.swift
//  ShoppingList
//
//  Created by Bethany Wride on 9/27/19.
//  Copyright © 2019 Bethany Wride. All rights reserved.
//

import UIKit

    // MARK: - Protocol
protocol ShoppingItemTableViewCellDelegate: class {
    func buttonTapped(_ sender: ShoppingItemTableViewCell)
}

    // MARK: - Class
class ShoppingItemTableViewCell: UITableViewCell {
    // Delegate
    weak var delegate: ShoppingItemTableViewCellDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    // MARK: - Actions
    @IBAction func completeButtonTapped(_ sender: Any) {
        delegate?.buttonTapped(self)
    }
    
    func updateButton(_ isComplete: Bool) {
        let imageName = isComplete ? "complete" : "incomplete"
        completeButton.setImage(UIImage(named: imageName), for: .normal)
    }
}

    // MARK: - Extension
extension ShoppingItemTableViewCell {
    func update(shoppingItem: ShoppingItem) {
        updateButton(shoppingItem.isComplete)
        itemNameLabel.text = shoppingItem.name
    }
}
