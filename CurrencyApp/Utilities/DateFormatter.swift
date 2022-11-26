//
//  DateFormatter.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 26/11/2022.
//

import Foundation

class DateManager {
    
    func convertDateToStringWithFormat(format: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
