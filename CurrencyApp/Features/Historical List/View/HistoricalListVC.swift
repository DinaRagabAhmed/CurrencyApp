//
//  HistoricalListVC.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 26/11/2022.
//

import UIKit
import RxDataSources

class HistoricalListVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    // MARK: - Properties
    var viewModel: HistoricalListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupTableView()
    }
    
    func setUI() {
        self.title = "historical_data".localized()
    }
    
    func setupTableView() {
        registerCells()
        setupCellCustomization()
        setupDataSource()
    }
    
    func registerCells() {
        tableView.register(HistoryDataCell.nib,
                           forCellReuseIdentifier: HistoryDataCell.identifier)
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
        let dataSource = RxTableViewSectionedReloadDataSource
            <SectionModel<String, HistoricalExchangeData>>(configureCell: { [weak self] _, tableView, indexPath, item in
            guard let self = self else { return UITableViewCell() }
            return self.configureHistorySearchCell(with: item, from: tableView, index: indexPath)
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        
        self.viewModel.output.dataObservable
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func configureHistorySearchCell(with element: HistoricalExchangeData, from table: UITableView, index: IndexPath) -> DisposableTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryDataCell.identifier, for: index) as? HistoryDataCell
        cell?.setData(data: element)
        return cell ?? DisposableTableViewCell()
    }
}
