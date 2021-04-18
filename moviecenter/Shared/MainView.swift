//
//  MainView.swift
//  moviecenter
//
//  Created by ruiqi on 2021/4/11.
//

import SwiftUI

struct MainView: View {
    @StateObject var notice = Notice()
    @State private var selection = 1

    var body: some View {
        TabView(selection:$selection) {
            SearchView()
                .tabItem {
                    Label("Search", systemImage:"magnifyingglass")
                }
                .tag(0)
            
            ContentView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(1)
                .environmentObject(notice)
            
            WatchListView()
                .tabItem {
                    Label("WatchList", systemImage: "heart")
                }
                .tag(2)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
