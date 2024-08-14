//
//  ArticleBookmarkViewModel.swift
//  SwiftUI_NewsApp
//
//  Created by AMAR on 23/07/24.
//

import SwiftUI

@MainActor
class ArticleBookmarkViewModel: ObservableObject {
    
    @Published private(set) var bookmarks: [Article] = []
    private let bookmarkStore = PlistDataStore<[Article]>(fileName: "bookmarks")
    
    static let shared = ArticleBookmarkViewModel()
    private init() {
        async {
            await load()
        }
    }
    
    private func load() async {
        bookmarks = await bookmarkStore.load() ?? []
    }
    
    func isBookmarked(for article: Article) -> Bool {
        bookmarks.first { article.id == $0.id } != nil
    }
    
    func addBookmark(for article: Article){
        guard !isBookmarked(for: article) else {
            return
        }
        
        bookmarks.insert(article, at: 0)
        bookmarkUpdated()
    }
    
    func removeBookmark(for article: Article){
        guard let index = bookmarks.firstIndex(where: { $0.id == article.id }) else {
            return
        }
        bookmarks.remove(at: index)
        bookmarkUpdated()
    }
    
    func toggleBookmark(for article: Article) {
            if isBookmarked(for: article) {
                removeBookmark(for: article)
            } else {
                addBookmark(for: article)
            }
        }
    private func bookmarkUpdated() {
        let bookmarks = self.bookmarks
        async {
            await bookmarkStore.save(bookmarks)
        }
    }
}
