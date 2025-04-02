//
//  ConnectionError.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 3/27/25.
//

import Foundation

protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
}

extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError, error.isInternetConnectionError else {
            return false
        }
        return true
    }
}
