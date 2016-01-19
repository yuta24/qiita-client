//
//  Scheduler.swift
//  qiita-client
//
//  Created by 多和田侑 on 2016/01/12.
//  Copyright © 2016年 Yu Tawata. All rights reserved.
//

import Foundation
import RxSwift

class Scheduler {

    let backgroundWorkScheduler: ImmediateSchedulerType
    let mainScheduler: SerialDispatchQueueScheduler

    init() {
        let operationQueue = NSOperationQueue()
        operationQueue.maxConcurrentOperationCount = AppContext.MAX_CONCURRENT_OPERATION_COUNT
        operationQueue.qualityOfService = NSQualityOfService.UserInitiated
        backgroundWorkScheduler = OperationQueueScheduler(operationQueue: operationQueue)
        mainScheduler = MainScheduler.instance
    }

}
