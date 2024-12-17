//
//  ProgressProxy.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 16/12/24.
//

import Foundation

public protocol ProgressProtocol {
    var fractionCompleted: Double { get }
}

extension Progress: ProgressProtocol { }

public struct ProgressProxy: ProgressProtocol {
    public let fractionCompleted: Double

    public init(fractionCompleted: Double) {
        self.fractionCompleted = fractionCompleted
    }
}
