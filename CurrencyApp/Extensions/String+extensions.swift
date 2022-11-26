//
//  String+extensions.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import UIKit

extension String {
    
    func localized() -> String {
        //Read from localization file
        let language : String = "en"
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
