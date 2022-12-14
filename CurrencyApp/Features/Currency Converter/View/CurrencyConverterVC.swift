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

    @IBOutlet weak var maxAmountErrorLabel: UILabel!
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var swapCurrenciesButton: UIButton!
    @IBOutlet weak var noNetworkView: NoNetworkView!
    @IBOutlet weak var conversionResultLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var toCurrencyLabel: UILabel!
    @IBOutlet weak var fromCurrencyLabel: UILabel!
    @IBOutlet weak var toCurrencyView: UIView!
    @IBOutlet weak var fromCurrencyView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: - Properties
    var viewModel: CurrencyCoverterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
        self.setUI()
        self.viewModel.getSymbols()
    }
    
    func setUI() {
        self.title = "currency_converter".localized()
        self.detailsBtn.setTitle("details".localized(), for: .selected)
        self.detailsBtn.setTitle("details".localized(), for: .normal)
        self.maxAmountErrorLabel.text = "\("max_amount_error".localized()) \(Constants.maxAmount.rawValue)"
    }
    
    //Binding
    func setupBindings() {
        super.setupBindings(baseViewModel: viewModel)
        self.subscribeToCurrenciesTypeViews()
        self.subscribeFromAndToCurrencies()
        self.bindAmountTextField()
        self.bindCurrencyConversionResult()
        self.subscribeToNetworkReconnection()
        self.subscribeToSwapCurrencies()
        self.subscribeToScreenStatus()
        self.subscribeToShowHistoricalData()
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
    
    func bindAmountTextField() {
        amountTextField.rx.text.orEmpty
        .scan("") { [weak self] (previous, new) -> String in
            if (Double(new.replacedArabicDigitsWithEnglish) ?? 0) > Double(Constants.maxAmount.rawValue) {
                self?.maxAmountErrorLabel.isHidden = false
                return previous ?? "0"
            } else {
                self?.maxAmountErrorLabel.isHidden = true
                return new
            }
        }
        .subscribe(amountTextField.rx.text)
        .disposed(by: disposeBag)
        
        amountTextField.rx.text.orEmpty
            .bind(to: self.viewModel.input.amount).disposed(by: disposeBag)
    }
    
    func bindCurrencyConversionResult() {
        self.viewModel.output.conversionResultObservable
          .asObservable()
          .map { String($0 ?? 0)}
          .bind(to:self.conversionResultLabel.rx.text)
          .disposed(by:self.disposeBag)
    }
    
    func subscribeToScreenStatus() {
        viewModel
            .output.screenStatusObservable
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] screenStatus in
                guard let self = self else { return }
                switch screenStatus {
                case .dataLoaded:
                    self.contentView.isHidden = false
                    self.noNetworkView.isHidden = true
                case .noNetwork:
                    self.contentView.isHidden = true
                    self.noNetworkView.isHidden = false
                }
            }).disposed(by: disposeBag)
    }
    
    func subscribeToNetworkReconnection() {
        noNetworkView.retryBtn.rx.tap
        .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if Utils.isConnectedToNetwork() {
                self.viewModel.retryNetworkConnection()
            }
        })
        .disposed(by: disposeBag)
    }
    
    func subscribeToSwapCurrencies() {
        swapCurrenciesButton.rx.tap
        .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
        .bind(to: self.viewModel.input.didSwapCurrencies).disposed(by: disposeBag)
    }
    
    func subscribeToShowHistoricalData() {
        detailsBtn.rx.tap
        .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
        .bind(to: self.viewModel.input.didTapDetails).disposed(by: disposeBag)
    }
}

private enum Constants: Int {
    case maxAmount = 1000_000_0
}
