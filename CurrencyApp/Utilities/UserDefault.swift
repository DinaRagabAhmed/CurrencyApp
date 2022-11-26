//
//  UserDefault.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 26/11/2022.
//

import Foundation

class UserDefault {
    
    let mUserDefault = UserDefaults.standard
    
    
    func setHistoricalData(data: HistoricalExchangeData) {
        var historialData = getHistoricalData()
        if !historialData.contains(data) {
            historialData.append(data)
            do {
                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: historialData, requiringSecureCoding: false)
                UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.historialData)
            } catch {
                print(error)
            }
        }
    }
    
    func getHistoricalData() -> [HistoricalExchangeData]  {
        
        do {
            if let data = UserDefaults.standard.data(forKey: UserDefaultKeys.historialData),
               let historialData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [HistoricalExchangeData] {
                return historialData
            } else {
                return []
            }
        } catch {
            print(error)
            return []
        }
    }
}

enum UserDefaultKeys {
    static let historialData = "historical_data"
}
