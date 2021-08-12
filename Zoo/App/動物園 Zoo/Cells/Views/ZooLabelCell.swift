//
//  ZooLabelCell.swift
//  Zoo
//
//  Created by 劉柏賢 on 2021/8/11.
//  
//

import UIKit
import MVVM

final class ZooLabelCell: BaseTableViewCell, Viewer {
    
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var location: UILabel!
    @IBOutlet private weak var feature: UILabel!

    typealias ViewModelType = ZooLabelCellViewModel
    var viewModel: ViewModelType! {
        didSet {
            icon.setImage(with: viewModel.model.fPic01URL)
            name.text = viewModel.model.fNameCh
            location.text = viewModel.model.fLocation
            feature.text = viewModel.model.fFeature
        }
    }
}
