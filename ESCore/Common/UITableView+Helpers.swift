//
//  UITableView+Helpers.swift
//  EslamCore
//
//  Created by Eslam on 3/19/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

// MARK: - Properties
public extension UITableView {
    var isEmpty: Bool {
        return numberOfRows() == 0
    }

    var firstCell: UITableViewCell? {
        guard !isEmpty else { return nil }
        return cellForRow(at: IndexPath(row: 0, section: 0))
    }
}

// MARK: - Methods
public extension UITableView {
    func reload(sections: [Int] = [0], animated: Bool = true) {
        if animated {
            self.beginUpdates()
            self.reloadSections(IndexSet(sections), with: .automatic)
            self.endUpdates()
        }else {
            self.reloadData()
        }
    }
    
    func insert(rowsAt indices: [Int], atSection section: Int = 0, withAnimation animation: UITableView.RowAnimation = .left) {
        self.beginUpdates()
        self.insertRows(at: indices.map({ IndexPath(row: $0, section: section) }), with: animation)
        self.endUpdates()
    }
    
    func delete(rowsAt indices: [Int], atSection section: Int = 0, withAnimation animation: UITableView.RowAnimation = .right) {
        self.beginUpdates()
        self.deleteRows(at: indices.map({ IndexPath(row: $0, section: section) }), with: animation)
        self.endUpdates()
    }
    
    func reload(rowsAt indices: [Int], atSection section: Int = 0, withAnimation animation: UITableView.RowAnimation = .automatic) {
        self.beginUpdates()
        self.reloadRows(at: indices.map({ IndexPath(row: $0, section: section) }), with: animation)
        self.endUpdates()
    }
    
    func select(rows: [Int], atSection section: Int = 0) {
        for index in rows {
            self.selectRow(at: IndexPath(row: index, section: section), animated: true, scrollPosition: .none)
        }
    }
    
    func updateCellHeights() {
        mainQueue { [weak self] in
            guard let self = self else { return }
            self.beginUpdates()
            self.endUpdates()
        }
    }
}
