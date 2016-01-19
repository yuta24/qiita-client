//
//  HttpClient.swift
//  qiita-client
//
//  Created by 多和田侑 on 2016/01/12.
//  Copyright © 2016年 Yu Tawata. All rights reserved.
//

import Foundation
import Alamofire

public protocol HttpClient {

    func get(url: NSURL, parameters: Parameters?, headers: Headers?) -> Request

    func post(url: NSURL, parameters: Parameters?, headers: Headers?) -> Request

    func put(url: NSURL, parameters: Parameters?, headers: Headers?) -> Request

    func delete(url: NSURL, parameters: Parameters?, headers: Headers?) -> Request

    func patch(url: NSURL, parameters: Parameters?, headers: Headers?) -> Request
}

public class DefaultHttpClient: HttpClient {

    private
    let manager: Manager

    init(manager: Manager = Alamofire.Manager()) {
        self.manager = manager
    }

    public
    func get(url: NSURL, parameters: Parameters?, headers: Headers?) -> Request {
        return action(Alamofire.Method.GET, url: url, parameters: parameters, headers: headers)
    }

    public
    func post(url: NSURL, parameters: Parameters?, headers: Headers?) -> Request {
        return action(.POST, url: url, parameters: parameters, headers: headers)
    }

    public
    func put(url: NSURL, parameters: Parameters?, headers: Headers?) -> Request {
        return action(.PUT, url: url, parameters: parameters, headers: headers)
    }

    public
    func delete(url: NSURL, parameters: Parameters?, headers: Headers?) -> Request {
        return action(.DELETE, url: url, parameters: parameters, headers: headers)
    }

    public
    func patch(url: NSURL, parameters: Parameters?, headers: Headers?) -> Request {
        return action(.PATCH, url: url, parameters: parameters, headers: headers)
    }

    private
    func action(method: Alamofire.Method, url: NSURL, parameters: Parameters?, headers: Headers?) -> Request {
        return manager.request(method, url, parameters: parameters, encoding: .URL, headers: headers)
    }

}
