//
//  NoNetworkView.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 26/11/2022.
//

import UIKit

class NoNetworkView: UIView {
    
    @IBOutlet weak var noNetworkLabel: UILabel!
    @IBOutlet weak var retryBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadViewFromNib()
        setStrings()
    }
    
    func setStrings() {
        retryBtn.setTitle("retry".localized(), for: .normal)
        retryBtn.setTitle("retry".localized(), for: .selected)

        noNetworkLabel.text = "networkError".localized()
    }
}
