//
//  CurrenciesListVC.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import UIKit
import RxSwift

class CurrenciesListVC: BaseVC {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var viewModel: CurrenciesListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    func setUI() {
        self.sheetViewController?.handleScrollView(tableView)
        setupTableView()
    }
    
    func setupTableView() {
        registerCells()
        setupCellCustomization()
        setupDataSource()
        subscribeToCurrencySelection()
    }
    
    func registerCells() {
        tableView.register(CurrencyCell.nib,
                           forCellReuseIdentifier: CurrencyCell.identifier)
    }
    
    func setupCellCustomization() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.contentInsetAdjustmentBehavior = .never
    }

    func setupDataSource() {
        viewModel
            .output.currenciesObservable
            .subscribe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: CurrencyCell.identifier, cellType: CurrencyCell.self)) {(_, currency, cell) in
                    cell.selectionStyle = .none
                cell.setData(currency: currency)
            }.disposed(by: disposeBag)
    }
    
    func subscribeToCurrencySelection() {
         tableView.rx.modelSelected(Currency.self)
            .bind(to: self.viewModel.input.selectedCurrency).disposed(by: disposeBag)
    }
}
