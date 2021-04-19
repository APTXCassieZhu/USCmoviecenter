//
//  WatchListView.swift
//  movie
//
//  Created by ruiqi on 2021/4/11.
//

import SwiftUI

class WatchList: ObservableObject{
    @Published var list = [listItem]()
    
    init(){
        self.list = [listItem]()
        if let objects = UserDefaults.standard.value(forKey: "user_objects") as? Data {
             let decoder = JSONDecoder()
             if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [listItem] {
                self.list = objectsDecoded
             }
        }
    }
    
    func save(data: WatchList){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data.list){
            UserDefaults.standard.set(encoded, forKey: "user_objects")
        }
    }
}


struct WatchListView: View {
    @EnvironmentObject var listData: WatchList
    
    var body: some View {
        if(listData.list.count == 0){
            Text("Watchlist is empty")
                .font(.system(size: 25))
                .foregroundColor(.gray)
        }else{
            NavigationView {
                GridView(listData: listData)
                    .navigationTitle("Watchlist")
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct WatchListView_Previews: PreviewProvider {
    static var previews: some View {
        WatchListView()
    }
}
