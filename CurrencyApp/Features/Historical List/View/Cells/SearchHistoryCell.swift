//
//  HistoryDataCell.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 26/11/2022.
//

import UIKit

class SearchHistoryCell: DisposableTableViewCell {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(data: HistoricalExchangeData) {
        self.dataLabel.text = "\(data.fromCurrency) -> \(data.toCurrency)"
        self.rateLabel.text = "\("rate".localized()): \(data.rate.round(to: 2))"
    }
    
}
