//
//  QiitaClient.swift
//  qiita-client
//
//  Created by 多和田侑 on 2016/01/12.
//  Copyright © 2016年 Yu Tawata. All rights reserved.
//

import Foundation

/**
 QiitaClient
 
 TODO: Qiita Team向けAPI
 */
class QiitaClient {

    enum Scope: String {
        case ReadQiita      = "read_qiita"
        case ReadQiitaTeam  = "read_qiita_team"
        case WriteQiita     = "write_qiita"
        case WriteQiitaTeam = "write_qiita_team"
    }

    var token: String?

    private
    let endPoint = "https://qiita.com"

    private
    let client: HttpClient

    private
    var headers: Headers {
        get {
            guard let token = self.token else {
                return [:]
            }

            return [
                "Authorization": token
            ]
        }
    }

    init(client: HttpClient = DefaultHttpClient()) {
        self.client = client
    }

    // =========================================================================
    // MARK: OAuth

    func authorize(clientId: String, scope: [Scope], state: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/oauth/authorize") else {
            return nil
        }

        return client.get(url, parameters: [
            "client_id" : clientId,
            "scope"     : makeScope(scope),
            "state"     : state,
            ], headers: headers)
    }

    // =========================================================================
    // MARK: Likes

    func getItemLikes(itemId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/items/\(itemId)/likes") else {
            return nil
        }

        return client.get(url, parameters: nil, headers: headers)
    }

    // =========================================================================
    // MARK: Access token

    func getAccessToken(clientId: String, clientSecret: String, code: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/access_tokens") else {
            return nil
        }

        var customHeaders = headers
        customHeaders["Content-Type"] = "application/json"

        return client.post(url, parameters: [
            "client_id"     : clientId,
            "client_secret" : clientSecret,
            "code"          : code,
            ], headers: customHeaders)
    }

    func deleteAccessToken() -> Request? {
        guard let token = self.token, let url = NSURL(string: endPoint + "/api/v2/access_tokens/\(token)") else {
            return nil
        }

        return client.delete(url, parameters: nil, headers: headers)
    }

    // =========================================================================
    // MARK: Comment

    func deleteComment(commentId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/comments/\(commentId)") else {
            return nil
        }

        return client.delete(url, parameters: nil, headers: headers)
    }

    func getComment(commentId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/comments/\(commentId)") else {
            return nil
        }

        return client.get(url, parameters: nil, headers: headers)
    }

    func updateComment(commentId: String, body: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/comments/\(commentId)") else {
            return nil
        }

        var customHeaders = headers
        customHeaders["Content-Type"] = "application/json"

        return client.patch(url, parameters: [
            "body"  : body,
            ], headers: customHeaders)
    }

    func deleteThankFromComment(commentId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/comments/\(commentId)/thank") else {
            return nil
        }

        return client.get(url, parameters: nil, headers: headers)
    }

    func putThankToComment(commentId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/comments/\(commentId)/thank") else {
            return nil
        }

        return client.put(url, parameters: nil, headers: headers)
    }

    func getCommentsFromItem(itemId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/items/\(itemId)/comments") else {
            return nil
        }

        return client.get(url, parameters: nil, headers: headers)
    }

    func postCommentToItem(itemId: String, body: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/items/\(itemId)/comments") else {
            return nil
        }

        return client.post(url, parameters: [
            "body"  : body,
            ], headers: headers)
    }

    // =========================================================================
    // MARK: Taggings

    func addTagToItem(itemId: String, name: String, versions: [String]) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/items/\(itemId)/taggings") else {
            return nil
        }

        var customHeaders = headers
        customHeaders["Content-Type"] = "application/json"

        return client.post(url, parameters: [
            "name"      : name,
            "versions"  : versions,
            ], headers: customHeaders)
    }

    func removeTagFromItem(tagId: String, itemId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/items/\(itemId)/taggings/\(tagId)") else {
            return nil
        }

        return client.delete(url, parameters: nil, headers: headers)
    }

    // =========================================================================
    // MARK: Tags

    func getTags(page: String, perPage: String) -> Request? {
        // TODO: sort対応
        guard let url = NSURL(string: endPoint + "/api/v2/tags") else {
            return nil
        }

        return client.get(url, parameters: [
            "page"      : page,
            "per_page"  : perPage,
            ], headers: headers)
    }

    func getTag(tagId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/tags/\(tagId)") else {
            return nil
        }

        return client.get(url, parameters: nil, headers: headers)
    }

    func getFollowingTagsWithUser(page: String, perPage: String, userId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/users/\(userId)/following_tags") else {
            return nil
        }

        return client.get(url, parameters: [
            "per"       : page,
            "per_page"  : perPage,
            ], headers: headers)
    }

    func removeFollowingTag(tagId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/tags/\(tagId)/following") else {
            return nil
        }

        return client.delete(url, parameters: nil, headers: headers)
    }

    func isFollowTag(tagId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/tags/\(tagId)/following") else {
            return nil
        }

        return client.get(url, parameters: nil, headers: headers)
    }

    func followTag(tagId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/tags/\(tagId)/following") else {
            return nil
        }

        return client.put(url, parameters: nil, headers: headers)
    }

    // =========================================================================
    // MARK: Teams


    // =========================================================================
    // MARK: Templates


    // =========================================================================
    // MARK: Projects


    // =========================================================================
    // MARK: Users

    func getStocksWithItem(page: String, perPage: String, itemId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/items/\(itemId)/stockers") else {
            return nil
        }

        return client.get(url, parameters: [
            "page"      : page,
            "per_page"  : perPage,
            ], headers: headers)
    }

    func getUsers(page: String, perPage: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/users") else {
            return nil
        }

        return client.get(url, parameters: [
            "page"      : page,
            "per_page"  : perPage,
            ], headers: headers)
    }

    func getUser(userId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/users/\(userId)") else {
            return nil
        }

        return client.get(url, parameters: nil, headers: headers)
    }

    func getFolloweesWithUser(page: String, perPage: String, userId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/users/\(userId)/followees") else {
            return nil
        }

        return client.get(url, parameters: [
            "page"      : page,
            "per_page"  : perPage,
            ], headers: headers)
    }

    func getFollowersWithUser(page: String, perPage: String, userId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/users/\(userId)/followers") else {
            return nil
        }

        return client.get(url, parameters: [
            "page"      : page,
            "per_page"  : perPage,
            ], headers: headers)
    }

    func removeFollowUser(userId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/users/\(userId)/following") else {
            return nil
        }

        return client.delete(url, parameters: nil, headers: headers)
    }

    func isFollowUser(userId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/users/\(userId)/following") else {
            return nil
        }

        return client.get(url, parameters: nil, headers: headers)
    }

    func putFollowUser(userId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/users/\(userId)/following") else {
            return nil
        }

        return client.put(url, parameters: nil, headers: headers)
    }

    // =========================================================================
    // MARK: Expanded templates

    // =========================================================================
    // MARK: Items

    func getItemsWithAuthUser(page: String, perPage: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/authenticated_user/items") else {
            return nil
        }

        return client.get(url, parameters: [
            "page"      : page,
            "per_page"  : perPage,
            ], headers: headers)
    }

    func getItems(page: String, perPage: String) -> Request? {
        // TODO: query対応
        guard let url = NSURL(string: endPoint + "/api/v2/items") else {
            return nil
        }

        return client.get(url, parameters: [
            "page"      : page,
            "per_page"  : perPage,
            ], headers: headers)
    }

    func postItem() {
        // TODO: 実装
    }

    func deleteItem(itemId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/items/\(itemId)") else {
            return nil
        }

        return client.delete(url, parameters: nil, headers: headers)
    }

    func getItem(itemId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/items/\(itemId)") else {
            return nil
        }

        return client.get(url, parameters: nil, headers: headers)
    }

    func updateItem() {
        // TODO: 実装
    }

    func removeItemFromStock(itemId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/items/\(itemId)/stock") else {
            return nil
        }

        return client.delete(url, parameters: nil, headers: headers)
    }

    func isStockItem(itemId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/items/\(itemId)/stock") else {
            return nil
        }

        return client.get(url, parameters: nil, headers: headers)
    }

    func isLikeItem(itemId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/items/\(itemId)/like") else {
            return nil
        }

        return client.get(url, parameters: nil, headers: headers)
    }

    func stockItem(itemId: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/items/\(itemId)/stock") else {
            return nil
        }

        return client.put(url, parameters: nil, headers: headers)
    }

    func getItemsByTag(tagId: String, page: String, perPage: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/tags/\(tagId)/items") else {
            return nil
        }

        return client.get(url, parameters: [
            "page"      : page,
            "per_page"  : perPage,
            ], headers: headers)
    }

    func getItemsByUser(userId: String, page: String, perPage: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/users/\(userId)/items") else {
            return nil
        }

        return client.get(url, parameters: [
            "page"      : page,
            "per_page"  : perPage,
            ], headers: headers)
    }

    func getStockItemByUser(userId: String, page: String, perPage: String) -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/users/\(userId)/stocks") else {
            return nil
        }

        return client.get(url, parameters: [
            "page"      : page,
            "per_page"  : perPage,
            ], headers: headers)
    }

    // =========================================================================
    // MARK: Authenticated user

    func getAuthUser() -> Request? {
        guard let url = NSURL(string: endPoint + "/api/v2/authenticated_user") else {
            return nil
        }

        return client.get(url, parameters: nil, headers: headers)
    }

    private
    func makeScope(scope: [Scope]) -> String {
        return scope.map({ $0.rawValue }).joinWithSeparator(" ")
    }

}
