//
//  NewsAPI.swift
//  SwiftUI_NewsApp
//
//  Created by AMAR on 18/07/24.
//

import Foundation

struct NewsAPI {
    static let shared = NewsAPI()
    private init() {}
    
    private let apiKey = "apikey"
    private let session = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
       let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func fetch(from category:Category) async throws -> [Article] {
        try await fetchArticles(from: generatedNewsURL(from: category))
    }
    
    func serach(for query:String) async throws -> [Article] {
        try await fetchArticles(from: generateSearchURL(from: query))
    }
    
    func fetchAllCategoryArticles() async throws -> [CategoryArticles] {
        try await withThrowingTaskGroup(of: Result<CategoryArticles, Error>.self){ group in
            for category in Category.allCases{
                group.addTask {
                    await fetchResult(from: category)
                }
            }
            
            var results = [Result<CategoryArticles, Error>]()
            for try await result in group {
                results.append(result)
            }
            
            if let first = results.first,
               case .failure(let error) = first,
               (error as NSError).code == 401 {
                throw error
            }
            
            var categories = [ CategoryArticles]()
            for result in results {
                if case .success(let value) = result {
                    categories.append(value)
                }
            }
            
            categories.sort { $0.category.sortIndex < $1.category.sortIndex }
            return categories
        }
    }
    
    private func fetchResult(from category: Category) async -> Result<CategoryArticles, Error>{
        do{
            let articles = try await fetchArticles(from: generatedNewsURL(from: category))
            return .success(CategoryArticles(category: category, articles: articles))
        }catch {
            return .failure(error)
        }
    }
    
    private func fetchArticles(from url: URL) async throws -> [Article]{
        let (data, response) = try await session.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw generateError(description: "Bad response")
        }
        
        switch response.statusCode {
        case (200...299), (400...499):
            let apiResponse = try jsonDecoder.decode(NewsAPIResponse.self, from: data)
            if apiResponse.status == "ok" {
                return apiResponse.articles ?? []
            } else {
                let errorCode = response.statusCode == 401 ? 401 : 1
                throw generateError(code: errorCode, description: apiResponse.message ?? "A error occured")
            }
        default:
            throw generateError(description: "An Error occured")
        }
    }
    
    private func generateError(code: Int = 1, description: String) -> Error {
        NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    private func generateSearchURL(from query:String) -> URL {
        let percentEncodedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        var url = "https://newsapi.org/v2/everything?"
        url += "apikey=\(apiKey)"
        url += "&language=en"
        url += "&q=\(percentEncodedString)"
        return URL(string: url)!
    }
    
    private func generatedNewsURL(from category: Category) -> URL {
        var url = "https://newsapi.org/v2/top-headlines?"
        url += "apikey=\(apiKey)"
        url += "&language=en"
        url += "&category=\(category.rawValue)"
        return URL(string: url)!
    }
}
