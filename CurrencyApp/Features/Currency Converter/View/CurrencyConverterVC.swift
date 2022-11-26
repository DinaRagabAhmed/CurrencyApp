//
//  CurrencyConverter.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import UIKit
import RxSwift
import RxGesture

class CurrencyConverterVC: BaseVC {

    @IBOutlet weak var toCurrencyLabel: UILabel!
    @IBOutlet weak var fromCurrencyLabel: UILabel!
    @IBOutlet weak var toCurrencyView: UIView!
    @IBOutlet weak var fromCurrencyView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    var viewModel: CurrencyCoverterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
        self.setUI()
        self.viewModel.getSymbols()
    }
    
    func setUI() {
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    //Binding
    func setupBindings() {
        super.setupBindings(baseViewModel: viewModel)
        self.subscribeToCurrenciesTypeViews()
        self.subscribeFromAndToCurrencies()
       
    }

}

// MARK: - Obervers and Binding
extension CurrencyConverterVC {

    func subscribeToCurrenciesTypeViews() {
        Observable.merge(
            fromCurrencyView.rx.tapGesture().when(.recognized).map { _ in CurrencyType.from },
            toCurrencyView.rx.tapGesture().when(.recognized).map { _ in CurrencyType.to }
        ).bind(to: viewModel.input.didSelectCurrencyType).disposed(by: disposeBag)
    }
    
    func subscribeFromAndToCurrencies() {
        self.viewModel.output.fromCurrencyObservable
          .asObservable()
          .map { $0?.symbol }
          .bind(to:self.fromCurrencyLabel.rx.text)
          .disposed(by:self.disposeBag)
        
        self.viewModel.output.toCurrencyObservable
          .asObservable()
          .map { $0?.symbol }
          .bind(to:self.toCurrencyLabel.rx.text)
          .disposed(by:self.disposeBag)
    }
    
   
}
