//
//  ViewModel.swift
//  MiniWeibo
//
//  Created by Weicheng Wang on 2020/1/2.
//  Copyright © 2020 ThoughtWorks. All rights reserved.
//

import UIKit

class WeiboListViewModel {
    
    var service: HttpRequest
    
    // Outputs
    var isRefreshing: ((Bool) -> Void)?
    var didSelecteWeibo: ((WeiboModel) -> Void)?
    var didUpdateWeibo:(([WeiboModel]) -> Void)?
    
    private(set) var dataSource: [WeiboModel] = [WeiboModel]() {
        didSet {
            didUpdateWeibo?(dataSource)
        }
    }
    
    init(_ service: HttpRequest = HttpRequest()) {
        self.service = service
    }
    
    // Inputs
    func refreshData() {
        isRefreshing?(true)
        service.request(with: "http://localhost:3000/home") { [weak self] data in
            guard let `self` = self else { return }
            self.finishRequest(with: data)
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        if dataSource.isEmpty { return }
        didSelecteWeibo?( dataSource[indexPath.row] )
    }
    
    // request finished
    private func finishRequest(with data: Data) {
        isRefreshing?(false)
        do {
            let decoder = JSONDecoder()
            let res = try decoder.decode(WeiboResponse.self, from: data)
            guard let models = res.data else { return }
            self.dataSource = models
        }catch let e {
            print(e.localizedDescription)
        }
    }

}
