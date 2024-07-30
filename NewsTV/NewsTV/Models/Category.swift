//
//  Category.swift
//  SwiftUI_NewsApp
//
//  Created by AMAR on 19/07/24.
//

import Foundation

enum Category: String, CaseIterable {
    case general
    case business
    case technology
    case entetainment
    case sport
    case science
    case health
    
    var text: String{
        if self == .general {
            return "Top Headlines"
        }
        return rawValue.capitalized
    }
}

extension Category: Identifiable {
    var id: Self { self }
    
}
