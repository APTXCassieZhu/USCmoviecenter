//
//  ContentView.swift
//  Shared
//
//  Created by ruiqi on 2021/4/11.
//

import SwiftUI
import Alamofire
import SwiftyJSON

class HomeData: ObservableObject{
    @Published var fetched = false;
    @State private var nowPlay = [Media]()
    init(){
        AF.request("https://ruiqi571.wl.r.appspot.com/slide/now_playing").responseData{
            (data) in
            let json = try! JSON(data: data.data!)
            for i in json["results"]{
                self.nowPlay.append(Media(id: i.1["id"].intValue, title: i.1["title"].stringValue, type: i.1["media_type"].stringValue, path: i.1["backdrop_path"].stringValue))
            }
            
            self.fetched = true;
        }
    }
}

struct ContentView: View {
    @StateObject var homeData = HomeData()
    var body: some View {
        if(homeData.fetched == false){
            ProgressView("Fetching Data...")
        }else{
            NavigationView {
                Text("Hello World")
                    .navigationBarTitle(Text("USC Films"))
                    .navigationBarItems(
                        trailing:
                            Button("TV Shows"){

                            }
                    )
            }
        }
//        Text("Now Playing")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
