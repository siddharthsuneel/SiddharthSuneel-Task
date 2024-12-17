//
//  ReachabilityManager.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 17/12/24.
//

import Foundation

class ReachabilityManager: NSObject {

    class func isNetworkReachable() -> Bool {
        return (Reachability()?.currentReachabilityStatus != .notReachable);
    }
}
