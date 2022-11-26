//
//  UITableView+extensions.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 26/11/2022.
//

import UIKit

extension UITableViewCell {
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }

}
