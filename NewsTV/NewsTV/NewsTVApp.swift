//
//  NewsTVApp.swift
//  NewsTV
//
//  Created by AMAR on 29/07/24.
//

import SwiftUI

@main
struct NewsTVApp: App {
    
    @StateObject private var bookmarkVM =  ArticleBookmarkViewModel.shared
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
            }
            .environmentObject(bookmarkVM)
        }
    }
}
