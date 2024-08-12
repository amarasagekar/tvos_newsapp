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
                
            }
        }
    }
}

#Preview {
    NewsView()
}
