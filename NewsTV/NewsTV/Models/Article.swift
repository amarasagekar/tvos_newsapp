//
//  Article.swift
//  SwiftUI_NewsApp
//
//  Created by AMAR on 17/07/24.
//

import Foundation

fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()

struct Article {
    let source: Source
    
    let title: String
    let url: String
    let publishedAt: Date
    
    let author: String?
    let description: String?
    let urlToOmage: String?
    
    var authortext: String {
        author ?? ""
    }
    
    var descriptionText: String {
        description ?? ""
    }
    
    var captionText: String {
        "\(source.name) ․ \(relativeDateFormatter.localizedString(for: publishedAt, relativeTo: Date())) "
    }
    
    var articleUrl: URL {
        URL(string: url)!
    }
    
    var imageURL: URL? {
        guard let urlToImage = urlToOmage else {
            return nil
        }
        return URL(string: urlToImage)
    }
}

extension Article: Codable {}
extension Article: Equatable {}
extension Article: Identifiable {
    var id: String { url }
}

extension Article {
    static var previewData: [Article] {
        let previewDataURL = Bundle.main.url(forResource: "news", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        let apiResponse = try! jsonDecoder.decode(NewsAPIResponse.self, from: data)
        return apiResponse.articles ?? []
    }
    
    static var previewCategoryArticles:[CategoryArticles] {
        let articles = previewData
        return Category.allCases.map {
            .init(category: $0, articles: articles.shuffled())
        }
    }
}

struct Source {
    let name: String
}

extension Source: Codable {}
extension Source: Equatable {}
