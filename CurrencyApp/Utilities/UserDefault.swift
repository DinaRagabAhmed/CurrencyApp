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
        // Check if this date exist before or not
        if let searchRecords = historialData[data.date] {
            // This date exist before
            if !searchRecords.contains(data) {
                var newSearchHistory = searchRecords
                newSearchHistory.append(data)
                historialData[data.date] = newSearchHistory
            } else {
                return
            }
        } else {
            // This date not exist before
            historialData[data.date] = [data]
        }
        do {
            
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: historialData, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.historialData)
            UserDefaults.standard.synchronize()
        } catch {
            print(error)
        }
    }
    
    func setHistoricalData(data: [String: [HistoricalExchangeData]]) {
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.historialData)
            UserDefaults.standard.synchronize()
        } catch {
            print(error)
        }
    }
    
    func getHistoricalData() -> [String: [HistoricalExchangeData]]  {
        
        do {
            if let data = UserDefaults.standard.data(forKey: UserDefaultKeys.historialData),
               let historialData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: [HistoricalExchangeData]] {
                return historialData
            } else {
                return [String: [HistoricalExchangeData]]()
            }
        } catch {
            print(error)
            return [String: [HistoricalExchangeData]]()
        }
    }
}

enum UserDefaultKeys {
    static let historialData = "historical_data"
}
