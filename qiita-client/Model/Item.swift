//
//  Item.swift
//  qiita-client
//
//  Created by yuta24 on 2016/01/17.
//  Copyright © 2016年 Yu Tawata. All rights reserved.
//

import Foundation
import ObjectMapper

struct Item: Mappable {

    struct Tag: Mappable {
        var name: String!
        var versions: [String]!

        init?(_ map: Map) {
            // nothing.
        }

        mutating
        func mapping(map: Map) {
            name        <- map["name"]
            versions    <- map["versions"]
        }
    }

    var rendered_body: String!
    var body: String!
// Qiita:Teamのみ
//    var coediting: Bool!
    var created_at: String!
    var id: String!
// Qiita:Teamのみ
//    var private: Bool!
    var tags: [Tag]!
    var title: String!
    var updated_at: String!
    var url: String!
    var user: User!

    init?(_ map: Map) {
        // nothing.
    }

    mutating
    func mapping(map: Map) {
        rendered_body   <- map["rendered_body"]
        body            <- map["body"]
        created_at      <- map["created_at"]
        id              <- map["id"]
        tags            <- map["tags"]
        title           <- map["title"]
        updated_at      <- map["updated_at"]
        url             <- map["url"]
        user            <- map["user"]
    }

}
