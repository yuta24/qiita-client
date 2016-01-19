//
//  DataStore.swift
//  qiita-client
//
//  Created by yuta24 on 2016/01/17.
//  Copyright © 2016年 Yu Tawata. All rights reserved.
//

import Foundation
import ObjectMapper

enum DataStoreResult<V> {
    case Success(V)
    case Failure(NSError)
}

class DataStore: NSObject {

    static
    let sharedInstance = DataStore()

    private
    var itemsAtPage = [Int : [Item]]()

    private
    let client = QiitaClient()

    override private
    init() {
        // nothing.
    }

    func reset() {
        itemsAtPage.removeAll()
    }

    func getItems(page: Int = 1, handler: (result: DataStoreResult<[Item]>) -> Void) {
        if let items = itemsAtPage[page] {
            handler(result: DataStoreResult.Success(items))
        } else {
            client.getItems(String(page), perPage: "20")?.responseJSON(completionHandler: ({ [unowned self] response in
                switch response.result {
                case .Success(let val):
                    guard let items = Mapper<Item>().mapArray(val) else {
                        handler(result: DataStoreResult<[Item]>.Success([Item]()))
                        return
                    }

                    self.itemsAtPage[page] = items

                    handler(result: DataStoreResult<[Item]>.Success(items))
                case .Failure(_):
                    break
                }
            }))
        }
    }

}
