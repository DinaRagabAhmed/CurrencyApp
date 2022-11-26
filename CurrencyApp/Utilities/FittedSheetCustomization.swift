//
//  FittedSheetCustomization.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import Foundation
import FittedSheets

class FittedSheetCustomization {
    
    static func setUPBottomSheet(sheetController: SheetViewController) {
        sheetController.dismissOnOverlayTap = true
        sheetController.dismissOnPull = true
        sheetController.cornerRadius = 30
        sheetController.autoAdjustToKeyboard = true
        sheetController.allowPullingPastMaxHeight = false
    }
    
    static func getSheetOptions() -> SheetOptions {
        let options = SheetOptions(
            shrinkPresentingViewController: false
        )
        return options
    }

}
