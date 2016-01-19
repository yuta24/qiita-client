//
//  User.swift
//  qiita-client
//
//  Created by yuta24 on 2016/01/18.
//  Copyright © 2016年 Yu Tawata. All rights reserved.
//

import Foundation
import ObjectMapper

struct User: Mappable {
    var description: String?
    var facebook_id: String?
    var followees_count: Int!
    var followers_count: Int!
    var github_login_name: String?
    var id: String!
    var items_count: Int!
    var linkedin_id: String?
    var location: String?
    var name: String?
    var organization: String?
    var permanent_id: Int!
    var profile_image_url: String!
    var twitter_screen_name: String?
    var website_url: String?

    init?(_ map: Map) {
        // nothing.
    }

    mutating
    func mapping(map: Map) {
        description         <- map["description"]
        facebook_id         <- map["facebook_id"]
        followees_count     <- map["followees_count"]
        followers_count     <- map["followers_count"]
        github_login_name   <- map["github_login_name"]
        id                  <- map["id"]
        items_count         <- map["items_count"]
        linkedin_id         <- map["linkedin_id"]
        location            <- map["location"]
        name                <- map["name"]
        organization        <- map["organization"]
        permanent_id        <- map["permanent_id"]
        profile_image_url   <- map["profile_image_url"]
        twitter_screen_name <- map["twitter_screen_name"]
        website_url         <- map["website_url"]
    }

}
