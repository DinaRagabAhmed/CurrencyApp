//
//  AppDelegate+extensions.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import Foundation
import IQKeyboardManagerSwift

// MARK: - Responsible For any UI Modification and handle application flow
extension AppDelegate {
    
    func setupApplicationCoordinator() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        applicationCoordinator = AppCoordinator(window: window)
    }
    
    // Setup entry screen
    func setupIntialView() {
        applicationCoordinator?.start()
    }
    
    func enableIQkeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    //Check search history if more than 3 days, remove
    func checkSearchHistory() {
        let savedSearchHistory = UserDefault().getHistoricalData()
        var searchHistory = savedSearchHistory
        // Check if search history is before 3 days, remove it
        for searchHistoryItem in savedSearchHistory {
            let threeDaysBeforeToday = Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()
            let searchDate = DateManager().getDate(dateString: searchHistoryItem.key) ?? Date()
            if searchDate < threeDaysBeforeToday {
                searchHistory[searchHistoryItem.key] = nil
            }
        }
        
        UserDefault().setHistoricalData(data: searchHistory)
    }
}
