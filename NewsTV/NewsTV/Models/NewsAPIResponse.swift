//
//  NewsAPIResponse.swift
//  SwiftUI_NewsApp
//
//  Created by AMAR on 17/07/24.
//

import Foundation

struct NewsAPIResponse: Decodable {
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    
    let code: String?
    let message: String?
}
