//
//  Progressor.swift
//  Zoo
//
//  Created by 劉柏賢 on 2021/8/12.
//

import MVVM
import JGProgressHUD

protocol Progressor: Viewer where ViewModelType: Updateable {
    var hud: JGProgressHUD { get }
    func showProgress(isUpdate: Bool?)
}

extension Progressor where Self: UIViewController {
    func showProgress(isUpdate: Bool? = nil) {
        
        if isUpdate ?? viewModel.isUpdate
        {
            if !hud.isVisible {
                hud.textLabel.text = "Loading"
                hud.show(in: self.view)
            }
        }
        else
        {
            hud.dismiss(animated: true)
        }
        
    }
}
