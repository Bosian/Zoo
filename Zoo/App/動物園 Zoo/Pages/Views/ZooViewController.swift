//
//  ZooViewController.swift
//  Zoo
//
//  Created by 劉柏賢 on 2021/8/11.
//

import UIKit
import MVVM
import JGProgressHUD

final class ZooViewController: BaseViewController, Viewer, Navigatable, Progressor {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    @IBOutlet private var footerView: UIView!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var topViewAfterScroll: UIView!
    @IBOutlet private weak var stackViewTopConstraint: NSLayoutConstraint!

    let hud: JGProgressHUD = JGProgressHUD()
    var scrollView: UIScrollView? { return tableView }
    var refreshControl: UIRefreshControl!

    typealias ViewModelType = ZooViewModel
    var viewModel: ViewModelType! {
        didSet {
            showProgress(isUpdate: !viewModel.isDataLoaded)
            updateLoadMoreProgress()
            tableView.reloadData()
        }
    }

    typealias NavigationParameterType = ZooNavigationParameter
    var navigationParameter: NavigationParameterType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationParameter = navigationParameter ?? ZooNavigationParameter()

        viewModel = ViewModelType(binder: self, navigationParameter: navigationParameter)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80

        setupPullToRefresh(selector: #selector(refresh(sender:)))
        setupNavigationBar()

        scrollViewDidScroll(tableView)
    }

    private func setupNavigationBar() {
        
        // iOS 13+
//        let barAppearance =  UINavigationBarAppearance()
//        barAppearance.configureWithTransparentBackground()
//        navigationController?.navigationBar.standardAppearance = barAppearance

        // iOS 12
        let image: UIImage? = UIImage()
        navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = image
    }

    private func updateLoadMoreProgress() {

        let isHidden: Bool = !viewModel.isUpdate || viewModel.cellViewModels.isEmpty

        footerView.isHidden = isHidden
        indicator.isHidden = isHidden
        
        let isRemoveFooter: Bool = !viewModel.cellViewModels.isEmpty && viewModel.offset >= viewModel.totalCount
        tableView.tableFooterView = isRemoveFooter ? nil : footerView
    }
}

extension ZooViewController: PullToRefreshable {

    /// 下拉更新
    ///
    /// - Parameter sender: sender description
    @objc func refresh(sender: UIRefreshControl) {
        
        viewModel.refresh(callback: {
            sender.endRefreshing()
        })
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        pullToRefreshScrollViewDidEndDragging(scrollView)
    }

    func pullToRefreshScrollViewDidEndDragging(_ scrollView: UIScrollView) {

        if !refreshControl.isRefreshing {
            guard scrollView.contentOffset.y < -115 - topView.frame.size.height else {
                return
            }

            refreshControl.beginRefreshing()
            refreshControl.sendActions(for: .valueChanged)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}

extension ZooViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let id: String = "\(type(of: viewModel.cellViewModels[indexPath.row]))"
        let cell: (UITableViewCell & Binder) = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! (UITableViewCell & Binder)
        cell.dataContext = viewModel.cellViewModels[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= viewModel.cellViewModels.count - 1 {
//            viewModel.loadMoreIfNeeded()
        }
    }

    private var limit: CGFloat { topView.frame.size.height }
    private var initValue: CGFloat { -topViewAfterScroll.frame.size.height }
    private var ratio: CGFloat { 6 }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let y: CGFloat = scrollView.contentOffset.y * ratio

        topView.alpha = 1 - min(1, y / limit)
        topViewAfterScroll.alpha = min(1, y / limit)

        stackViewTopConstraint.constant = min(initValue, max(-limit, -y))
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let threshold: CGFloat = -limit / 2
        
        if stackViewTopConstraint.constant > threshold {
            stackViewTopConstraint.constant = 0
            scrollView.setContentOffset(CGPoint.zero, animated: false)
        } else {
            stackViewTopConstraint.constant = -limit
        }
    }
}
