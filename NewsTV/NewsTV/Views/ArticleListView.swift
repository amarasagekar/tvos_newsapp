//
//  ArticleListView.swift
//  SwiftUI_NewsApp
//
//  Created by AMAR on 18/07/24.
//

import SwiftUI

struct ArticleListView: View {
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selectedArticleURL: URL?
    #elseif os(macOS)
    @Environment(\.colorScheme) private var colorScheme
    #endif
    let articles: [Article]
    
    var body: some View {
        rootView
        #if os(iOS)
        .sheet(item: $selectedArticleURL) {
            SafariView(url: $0)
                .edgesIgnoringSafeArea(.bottom)
                .id($0)
        }
        .onReceive(NotificationCenter.default.publisher(for: .articleSent, object: nil)) { notification in
            if let url = notification.userInfo?["url"] as? URL,
               url != selectedArticleURL {
                selectedArticleURL = url
            }
        }
        .onContinueUserActivity(activityTypeViewKey) { userActivity in
            if let urlString = userActivity.userInfo?[activityURLKey] as? String,
               let url = URL(string: urlString),
               url != selectedArticleURL {
                selectedArticleURL = url
            }
        }
        #endif
    }
    
    #if os(iOS) || os(watchOS)
    private var listView: some View {
        List {
            ForEach(articles) { article in
                #if os(iOS)
                ArticleRowView(article: article)
                    .onTapGesture {
                        selectedArticleURL = article.articleURL
                    }
                #elseif os(watchOS)
                NavigationLink(destination: {
                    ArticleDetailView(article: article)
                }, label: {
                    ArticleRowView(article: article)
                })
                #endif
            }
            #if os(iOS)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
            #endif
        }
        .listStyle(.plain)
    }
    #endif
    
    private var gridView: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: gridSpacing) {
                ForEach(articles) { article in
                    #if os(tvOS)
                    NavigationLink {
                        ArticleDetailView(article: article)
                    } label: {
                        ArticleItemViews(article: article)
                            .frame(width: 400, height: 400)
                    }
                    .buttonStyle(.card)
                    #else
                    ArticleRowView(article: article)
                        .onTapGesture { handleOnTapGesture(article: article) }
                        #if os(iOS)
                        .frame(height: 360)
                        .background(Color(uiColor: .systemBackground))
                        #elseif os(macOS)
                        .frame(height: 376)
                        .background(Color(nsColor: colorScheme == .light ? .textBackgroundColor : .windowBackgroundColor))
                        #endif
                        .mask(RoundedRectangle(cornerRadius: 8))
                        .shadow(radius: 4)
                        .padding(.bottom, 4)
                    #endif
                    
                    
                }
            }
            .padding()
        }
        #if os(iOS)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        #endif
    }
    
    private var gridItems: [GridItem] {
        #if os(iOS)
        [GridItem(.adaptive(minimum: 300), spacing: 8)]
        #elseif os(tvOS)
        [GridItem(.adaptive(minimum: 400), spacing: 32)]
        #else
        [GridItem(.adaptive(minimum: 272, maximum: 272), spacing: 8)]
        #endif
    }
    
    private var gridSpacing: CGFloat? {
        #if os(tvOS)
        48
        #else
        nil
        #endif
    }
    
    private func handleOnTapGesture(article: Article) {
        #if os(iOS)
        self.selectedArticleURL = article.articleURL
        #elseif os(macOS)
        NSWorkspace.shared.open(article.articleURL)
        #endif
    }
    
    @ViewBuilder
    private var rootView: some View {
        #if os(iOS)
        switch horizontalSizeClass {
        case .regular:
            gridView
        default:
            listView
        }
        #elseif os(macOS) || os(tvOS)
        gridView
        #elseif os(watchOS)
        listView
        #endif
    }
    
}

extension URL: Identifiable {
    
    public var id: String { absoluteString }
    
}

#Preview {
    
    @StateObject var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    NavigationView {
        ArticleListView(articles: Article.previewData)
            .environmentObject(articleBookmarkVM)
    }
}
