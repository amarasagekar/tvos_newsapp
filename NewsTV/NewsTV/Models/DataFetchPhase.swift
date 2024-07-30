//
//  DataFetchPhase.swift
//  NewsTV
//
//  Created by AMAR on 30/07/24.
//

import Foundation

enum DataFetchPhase<T> {
    
    case empty
    case success(T)
    case failure(Error)
    
    var value: T? {
        if case .success(let value) = self {
            return value
        }
        return nil
    }
}
