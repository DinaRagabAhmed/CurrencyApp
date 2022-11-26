//
//  DisposableTableViewCell.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 26/11/2022.
//

import RxSwift
import UIKit

class DisposableTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
