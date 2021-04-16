//
//  ContentView.swift
//  Shared
//
//  Created by ruiqi on 2021/4/11.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import Kingfisher

class HomeData: ObservableObject{
    @Published var fetched = false;
    @Published var nowPlay = [Media]()
    init(){
        AF.request("https://ruiqi571.wl.r.appspot.com/ios/now_playing").responseData{
            (data) in
            let json = try! JSON(data: data.data!)
            for i in json["results"]{
                self.nowPlay.append(Media(ID: i.1["ID"].intValue, title: i.1["title"].stringValue, type: i.1["media_type"].stringValue, path: i.1["backdrop_path"].stringValue))
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
                ScrollView(.vertical){
                    VStack(alignment: .leading){
                        Text("Now Playing")
                            .font(.system(size: 23, design: .rounded))
                            .bold()
                            .multilineTextAlignment(.leading)
                        CarouselView(numberOfImages: homeData.nowPlay.count) {
                            ForEach(homeData.nowPlay,  id: \.self){ img in
                                ZStack{
                                    KFImage(URL(string: img.path)!)
                                        .scaledToFill()
                                        .frame(width: 361.8, height: 310)
                                        .clipped()
                                        .blur(radius: 10)
                                    
                                    KFImage(URL(string: img.path)!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200, height: 300)
                                        .clipped()
                                }
                            }
                        }.frame(height: 300)
                        .clipped()
                    }
                }
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .navigationBarTitle(Text("USC Films"))
                    .navigationBarItems(
                        trailing:
                            Button("TV Shows"){

                            }
                    )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
