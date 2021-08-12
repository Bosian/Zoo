//
//  ZooViewControllerPreview.swift
//  Zoo
//
//  Created by 劉柏賢 on 2021/8/11.
//

import SwiftUI
import UIKit
import MVVM

struct ZooViewControllerPreview_Previews: PreviewProvider {

    private struct ZooViewControllerPreview: UIViewRepresentable {

        private let viewController: UIViewController

        init() {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)

            let tabBarController: UITabBarController = storyboard.instantiateInitialViewController() as! UITabBarController
            let navigationController: UINavigationController = tabBarController.viewControllers?[0] as! UINavigationController
            let viewController: (ParameterDelegate & UIViewController & Binder) = navigationController.topViewController as! (ParameterDelegate & UIViewController & Binder)

//            let dataSource: ZooDataSourceProtocol = ZooDataSource()
            let dataSource: ZooDataSourceProtocol = ZooPreviewDataSource()

            let parameter: ZooNavigationParameter = ZooNavigationParameter(dataSource: dataSource)
            viewController.set(parameter: parameter)
            
            self.viewController = tabBarController
        }

        func makeUIView(context: Context) -> some UIView {
            return viewController.view
        }

        func updateUIView(_ uiView: UIViewType, context: Context) {
            
        }
    }

    static var previews: some View {

        Group {
            ZooViewControllerPreview()
                .preferredColorScheme(.dark)

            ZooViewControllerPreview()
                .preferredColorScheme(.light)
        }
    }
}
