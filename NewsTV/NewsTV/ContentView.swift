//
//  ContentView.swift
//  NewsTV
//
//  Created by AMAR on 29/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("News")
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
                .tag("news")
            
            Text("Saved")
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
                .tag("saved")
            
            Text("Search")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag("search")
        }
    }
}

#Preview {
    ContentView()
}
