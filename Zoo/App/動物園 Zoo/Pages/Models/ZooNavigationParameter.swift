//
//  ZooNavigationParameter.swift
//  Zoo
//
//  Created by 劉柏賢 on 2021/8/11.
//

struct ZooNavigationParameter {

    let dataSource: ZooDataSourceProtocol
    
    init(dataSource: ZooDataSourceProtocol = ZooDataSource()) {
        self.dataSource = dataSource
    }
}
