//
//  RxHttpClient.swift
//  qiita-client
//
//  Created by yuta24 on 2016/01/16.
//  Copyright © 2016年 Yu Tawata. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

public protocol RxHttpClient {

    func get(url: NSURL, parameters: [String: String]?, headers: [String: String]?) -> Observable<(NSData, NSHTTPURLResponse)>

    func post(url: NSURL, parameters: [String:String]?, headers: [String:String]?) -> Observable<(NSData, NSHTTPURLResponse)>

    func put(url: NSURL, parameters: [String:String]?, headers: [String:String]?) -> Observable<(NSData, NSHTTPURLResponse)>

    func delete(url: NSURL, parameters: [String:String]?, headers: [String:String]?) -> Observable<(NSData, NSHTTPURLResponse)>

}

public class RxDefaultHttpClient: RxHttpClient {

    private
    let manager: Manager

    init(manager: Manager = Alamofire.Manager()) {
        self.manager = manager
    }

    public
    func get(url: NSURL, parameters: [String: String]?, headers: [String: String]?) -> Observable<(NSData, NSHTTPURLResponse)> {
        return action(Alamofire.Method.GET, url: url, parameters: parameters, headers: headers)
    }

    public
    func post(url: NSURL, parameters: [String:String]?, headers: [String:String]?) -> Observable<(NSData, NSHTTPURLResponse)> {
        return action(.POST, url: url, parameters: parameters, headers: headers)
    }

    public
    func put(url: NSURL, parameters: [String:String]?, headers: [String:String]?) -> Observable<(NSData, NSHTTPURLResponse)> {
        return action(.PUT, url: url, parameters: parameters, headers: headers)
    }

    public
    func delete(url: NSURL, parameters: [String:String]?, headers: [String:String]?) -> Observable<(NSData, NSHTTPURLResponse)> {
        return action(.DELETE, url: url, parameters: parameters, headers: headers)
    }

    private
    func action(method: Alamofire.Method, url: NSURL, parameters: [String:String]?, headers: [String:String]?) -> Observable<(NSData, NSHTTPURLResponse)> {
        let request = manager.request(method, url, parameters: parameters, encoding: ParameterEncoding.URL).request
        let mutableRequest = setHeader(headers, mutableRequest: request!.mutableCopy() as! NSMutableURLRequest)
        return manager.session.rx_response(mutableRequest)
    }

    private
    func setHeader(headers: [String:String]?, mutableRequest: NSMutableURLRequest) -> NSMutableURLRequest {
        if let headers = headers {
            for (key, value) in headers {
                mutableRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        return mutableRequest
    }
    
}
