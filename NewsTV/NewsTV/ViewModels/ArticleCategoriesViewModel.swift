//
//  ArticleCategoriesViewModel.swift
//  NewsTV
//
//  Created by AMAR on 04/08/24.
//

import SwiftUI

@MainActor
class ArticleCategoriesViewModel: ObservableObject {
    
    @Published var phase = DataFetchPhase<[CategoryArticles]>.empty
    
    private let newsAPI = NewsAPI.shared
    
    var categoryArticles: [CategoryArticles] {
        phase.value ?? []
    }
    
    func loadCategoryArticles() async {
        if Task.isCancelled { return}
    }
}
