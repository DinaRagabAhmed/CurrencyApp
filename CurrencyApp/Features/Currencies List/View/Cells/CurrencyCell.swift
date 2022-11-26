//
//  CurrencyCell.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 26/11/2022.
//

import UIKit

class CurrencyCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(currency: Currency) {
        self.currencyLabel.text = currency.currencyFullName
    }
}
