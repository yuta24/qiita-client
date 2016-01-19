//
//  Tag.swift
//  qiita-client
//
//  Created by yuta24 on 2016/01/18.
//  Copyright © 2016年 Yu Tawata. All rights reserved.
//

import Foundation
import ObjectMapper

struct Tag: Mappable {
    var followers_count: Int!
    var icon_url: String?
    var id: String!
    var items_count: Int!

    init?(_ map: Map) {
        // nothing.
    }

    mutating
    func mapping(map: Map) {
        followers_count <- map["followers_count"]
        icon_url        <- map["icon_url"]
        id              <- map["id"]
        items_count     <- map["items_count"]
    }

}
