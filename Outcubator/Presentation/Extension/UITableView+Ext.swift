//
//  UITableView+Ext.swift
//  Outcubator
//
//  Created by doquanghuy on 18/05/2021.
//

import UIKit

extension UITableView {
    func dequeue<T: UITableViewCell>(type: T.Type, indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as! T
        return cell
    }
    
    func register<T: UITableViewCell>(type: T.Type) {
        self.register(UINib(nibName: String(describing: type), bundle: Bundle(for: type)), forCellReuseIdentifier: String(describing: type))
    }
}

extension UITableViewHeaderFooterView {
    class func registerNibFor(tableViews: UITableView...) {
        let cellId = String.init(describing: self)
        tableViews.forEach { (tableView) in
            tableView.register(UINib.init(nibName: cellId,
                                          bundle: Bundle.init(for: self)),
                               forHeaderFooterViewReuseIdentifier: cellId)
        }
    }
}
