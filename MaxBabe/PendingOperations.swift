//
//  PendingOperations.swift
//  MaxBabe
//
//  Created by Liber on 6/1/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation
import UIKit

class PendingOperations {
//    lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    lazy var imagesQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Image Download queue"
        queue.maxConcurrentOperationCount = 2
        return queue
        }()
    
//    lazy var metadataInProgress = [NSIndexPath:NSOperation]()
    lazy var metadataQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Meta Data Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
        }()

//    lazy var idleQueue:NSOperationQueue = {
//        var queue = NSOperationQueue()
//        queue.name = "Idle Waiting queue"
//        queue.maxConcurrentOperationCount = 1
//        return queue
//        }()
    
    lazy var forcastQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Forecast Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
        }()
}