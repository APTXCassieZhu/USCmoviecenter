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
    @Published var topMovie = [Slide]()
    @Published var popularMovie = [Slide]()
    @Published var trending = [Media]()
    @Published var topTV = [Slide]()
    @Published var popularTV = [Slide]()
    

    init(){
        AF.request("https://ruiqi571.wl.r.appspot.com/ios/now_playing").responseData{
            (data) in
            let json = try! JSON(data: data.data!)
            for i in json["results"]{
                self.nowPlay.append(Media(ID: i.1["id"].stringValue, title: i.1["title"].stringValue, type: i.1["media_type"].stringValue, path: i.1["backdrop_path"].stringValue))
            }
            AF.request("https://ruiqi571.wl.r.appspot.com/ios/toprated/movie").responseData{
                (data) in
                let json = try! JSON(data: data.data!)
                for i in json["results"]{
                    self.topMovie.append(Slide(ID: i.1["id"].stringValue, title: i.1["title"].stringValue, type: i.1["media_type"].stringValue, path: i.1["poster_path"].stringValue, date: i.1["date"].stringValue
                    ))
                }
                AF.request("https://ruiqi571.wl.r.appspot.com/ios/popular/movie").responseData{
                    (data) in
                    let json = try! JSON(data: data.data!)
                    for i in json["results"]{
                        self.popularMovie.append(Slide(ID: i.1["id"].stringValue, title: i.1["title"].stringValue, type: i.1["media_type"].stringValue, path: i.1["poster_path"].stringValue, date: i.1["date"].stringValue
                        ))
                    }
                    AF.request("https://ruiqi571.wl.r.appspot.com/ios/trending/tv").responseData{
                        (data) in
                        let json = try! JSON(data: data.data!)
                        for i in json["results"]{
                            self.trending.append(Media(ID: i.1["id"].stringValue, title: i.1["title"].stringValue, type: i.1["media_type"].stringValue, path: i.1["poster_path"].stringValue))
                        }
                        AF.request("https://ruiqi571.wl.r.appspot.com/ios/toprated/tv").responseData{
                            (data) in
                            let json = try! JSON(data: data.data!)
                            for i in json["results"]{
                                self.topTV.append(Slide(ID: i.1["id"].stringValue, title: i.1["title"].stringValue, type: i.1["media_type"].stringValue, path: i.1["poster_path"].stringValue, date: i.1["date"].stringValue
                                ))
                            }
                            AF.request("https://ruiqi571.wl.r.appspot.com/ios/popular/tv").responseData{
                                (data) in
                                let json = try! JSON(data: data.data!)
                                for i in json["results"]{
                                    self.popularTV.append(Slide(ID: i.1["id"].stringValue, title: i.1["title"].stringValue, type: i.1["media_type"].stringValue, path: i.1["poster_path"].stringValue, date: i.1["date"].stringValue
                                    ))
                                }
                                
                                self.fetched = true;
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    @StateObject var homeData = HomeData()
    @State private var showMovie = true
    
    @EnvironmentObject var notice: Notice
    
    var body: some View {
        if(homeData.fetched == false){
            ProgressView("Fetching Data...")
        }else{
            if(showMovie == true){
                NavigationView {
                    ScrollView(.vertical){
                        VStack(alignment: .leading){
                            Text("Now Playing")
                                .font(.system(size: 23, design: .rounded))
                                .fontWeight(.bold)
                            CarouselView(numberOfImages: homeData.nowPlay.count) {
                                ForEach(homeData.nowPlay,  id: \.self){ img in
                                    NavigationLink(destination: DetailView(ID: img.ID, type: img.type)){
                                        ZStack{
                                            KFImage(URL(string: img.path)!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 360, height: 290)
                                                .clipped()
                                                .blur(radius: 10)
                                            KFImage(URL(string: img.path)!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 200, height: 280)
                                                .clipped()
                                        }
                                    }
                                }
                            }.frame(width: 360, height: 280)
                            .clipped()
                            
                            SlideView(slideList: homeData.topMovie, title: "Top Rated")
                            SlideView(slideList: homeData.popularMovie, title: "Popular")
                            BottomView()
                        }
                    }
                        .padding(.leading, 20)
                        .padding(.trailing, 10)
                        .navigationBarTitle("USC Films")
                        .navigationBarItems(
                            trailing:
                                Button("TV Shows"){
                                    self.showMovie = false
                                }
                        )
                }
                .toast(isPresented: $notice.showToast){
                    Text(notice.msg)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }else{
                NavigationView {
                    ScrollView(.vertical){
                        VStack(alignment: .leading){
                            Text("Trending")
                                .font(.system(size: 23, design: .rounded))
                                .fontWeight(.bold)
                            CarouselView(numberOfImages: homeData.trending.count) {
                                ForEach(homeData.trending,  id: \.self){ img in
                                    NavigationLink(destination: DetailView(ID: img.ID, type: img.type)){
                                        ZStack{
                                            KFImage(URL(string: img.path)!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 360, height: 290)
                                                .clipped()
                                                .blur(radius: 10)
                                            
                                            KFImage(URL(string: img.path)!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 200, height: 280)
                                                .clipped()
                                        }
                                    }
                                }
                            }.frame(height: 280)
                            .clipped()
                            
                            SlideView(slideList: homeData.topTV, title: "Top Rated")
                            SlideView(slideList: homeData.popularTV, title: "Popular")
                            
                            BottomView()
        
                        }
                    }
                        .padding(.leading, 20)
                        .padding(.trailing, 10)
                        .navigationBarTitle("USC Films")
                        .navigationBarItems(
                            trailing:
                                Button("Movies"){
                                    self.showMovie = true
                                }
                        )
                }.toast(isPresented: $notice.showToast){
                    Text(notice.msg)
                }
                .navigationViewStyle(StackNavigationViewStyle())
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
