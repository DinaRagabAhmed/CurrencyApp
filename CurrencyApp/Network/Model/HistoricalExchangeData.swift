//
//  HistoricalExchangeData.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 26/11/2022.
//

import Foundation

class HistoricalExchangeData: NSObject, NSCoding {

    var date = ""
    var fromCurrency = ""
    var toCurrency = ""
    var rate = 0.0
    
    init(date: String, fromCurrency: String, toCurrency: String, rate: Double) {
        self.date = date
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.rate = rate
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObject(forKey: "date") as? String ?? ""
        let fromCurrency = aDecoder.decodeObject(forKey: "fromCurrency") as? String ?? ""
        let toCurrency = aDecoder.decodeObject(forKey: "toCurrency") as? String ?? ""
        let rate = aDecoder.decodeDouble(forKey: "rate")


        self.init(date: date, fromCurrency: fromCurrency, toCurrency: toCurrency, rate: rate)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(fromCurrency, forKey: "fromCurrency")
        aCoder.encode(toCurrency, forKey: "toCurrency")
        aCoder.encode(rate, forKey: "rate")
    }
    
  
    override func isEqual(_ object: Any?) -> Bool {
        let obj = object as! HistoricalExchangeData
        return ((self.date == obj.date) && (self.fromCurrency == obj.fromCurrency)  && (self.toCurrency == obj.toCurrency)  && (self.rate == obj.rate))
    }
   
}
