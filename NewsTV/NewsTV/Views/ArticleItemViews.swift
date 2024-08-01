//
//  ArticleItemViews.swift
//  NewsTV
//
//  Created by AMAR on 01/08/24.
//

import SwiftUI

struct ArticleItemViews: View {
    
    let article: Article
    @EnvironmentObject private var bookmarkVM: ArticleBookmarkViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ArticleItemViews(article: Article.previewData[2])
        .environmentObject(ArticleBookmarkViewModel.shared)
}
