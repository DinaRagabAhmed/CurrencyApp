//
//  Routing.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import UIKit

typealias NavigationBackClosure = (() -> Void)

protocol Routing: AnyObject {
    func push(_ drawable: Drawable, isAnimated: Bool, onNavigateBack: NavigationBackClosure?)
    func pop(_ isAnimated: Bool)
    func pushToRoot(_ drawable: Drawable, isAnimated: Bool, onNavigateBack closure: NavigationBackClosure?)
    func popToRoot(_ isAnimated: Bool)
    func present(_ drawable: Drawable, isAnimated: Bool, onDismiss: NavigationBackClosure?)
    func dismissModule(animated: Bool)
    func controlPopGesture(enable: Bool)
}
