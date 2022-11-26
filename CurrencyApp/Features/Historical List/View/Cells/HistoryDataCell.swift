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
        dataLabel.text = "\("conversion_from".localized()) \(data.fromCurrency) \("to".localized()) \(data.toCurrency) \("with_rate".localized()) \(data.rate.round(to: 2))"
    }
    
}
