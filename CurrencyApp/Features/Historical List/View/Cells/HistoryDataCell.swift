//
//  HistoryDataCell.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 26/11/2022.
//

import UIKit

class HistoryDataCell: DisposableTableViewCell {

    @IBOutlet weak var dataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(data: HistoricalExchangeData) {
        dataLabel.text = "Conversion from \(data.fromCurrency) to \(data.toCurrency) with rate \(data.rate.round(to: 2))"
    }
    
}
