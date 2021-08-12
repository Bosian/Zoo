//
//  ZooViewModel.swift
//  Zoo
//
//  Created by 劉柏賢 on 2021/8/11.
//

import WebAPI
import MVVM
import PromiseKit

struct ZooViewModel: Refreshable, MutatingClosure, Updateable {

    weak var binder: Binder?

    var cellViewModels: [ZooLabelCellViewModel] = []
    let dataSource: ZooDataSourceProtocol
    var isUpdate: Bool = false
    
    var isDataLoaded: Bool = false
    
    // Pagination
    var offset: Int = 0
    private let limit: Int = 20
    var totalCount: Int = 0
    
    private var results: [GetZooModel.Results] = []
    
    init(binder: Binder, navigationParameter: ZooNavigationParameter)
    {
        self.binder = binder
        self.dataSource = navigationParameter.dataSource
        
        refresh()
    }

    /// 更新資料
    mutating func refresh(callback: (() -> Void)? = nil)
    {
        isDataLoaded = false

        let copySelf = self

        clear()
        
        loadMOre() {

            copySelf.mutating { (mutatingSelf: inout ZooViewModel) in
                mutatingSelf.isDataLoaded = true
            }

            callback?()
        }
    }
    
    private mutating func clear() {
        offset = 0
        totalCount = 0
        results.removeAll()
        cellViewModels.removeAll()
    }
    
    func loadMoreIfNeeded(callback: (() -> Void)? = nil) {

        guard isDataLoaded, !isUpdate else {
            return
        }

        guard offset < totalCount else {
            return
        }

        mutating { (mutatingSelf: inout ZooViewModel) in
            mutatingSelf.loadMOre(callback: callback)
        }
    }
    
    private mutating func loadMOre(callback: (() -> Void)?) {
        loadMore(offset: offset, callback: callback)
        offset += limit
    }
    
    private mutating func loadMore(offset: Int, callback: (() -> Void)?) {

        isUpdate = true
        
        let copySelf = self
        let parameter: GetZooParameter = GetZooParameter(limit: limit, offset: offset)
        
        _ = callGetZooWebAPI(parameter: parameter).done { (partialModel: GetZooModel) in
            copySelf.mutating { (mutatingSelf: inout ZooViewModel) in
                mutatingSelf.results.append(contentsOf: partialModel.result.results)
                mutatingSelf.totalCount = partialModel.result.count
                mutatingSelf.updateUI(partialResults: partialModel.result.results)
            }
        }.ensure {
            copySelf.mutating { (mutatingSelf: inout ZooViewModel) in
                mutatingSelf.isUpdate = false
                
                DispatchQueue.main.async {
                    callback?()
                }
            }
        }
    }

    private func callGetZooWebAPI(parameter: GetZooParameter) -> Promise<GetZooModel> {
        return dataSource.getZooModel(parameter: parameter)
    }

    private mutating func updateUI(partialResults: [GetZooModel.Results]) {
        let partialCellViewModels: [ZooLabelCellViewModel] = partialResults.map { (result: GetZooModel.Results) -> ZooLabelCellViewModel in
            return ZooLabelCellViewModel(model: result)
        }

        self.cellViewModels.append(contentsOf: partialCellViewModels)
    }
}
