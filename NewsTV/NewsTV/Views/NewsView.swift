//
//  NewsView.swift
//  NewsTV
//
//  Created by AMAR on 11/08/24.
//

import SwiftUI

struct NewsView: View {
    @StateObject private var articleCategoriesVM = ArticleCategoriesViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 48){
                ForEach(articleCategoriesVM.categoryArticles, id: \.category){
                    ArticleCarouselView(title: $0.category.text, articles: $0.articles)
                }
            }
        }
        .task(refreshTask)
    }
    
    @ViewBuilder
    private var overlayView:some View {
        switch articleCategoriesVM.phase {
        case .empty:
            ProgressView()
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No Articles", image: nil)
            
        case .failure(let error):
            RetryView(text: error.localizedDescription, rettryAction: refreshTask)
            
        default: EmptyView()
            
        }
    }
    
    @Sendable
    private func refreshTask(){
        Task{
            await articleCategoriesVM.loadCategoryArticles()
        }
    }
}

#Preview {
    NewsView()
}
