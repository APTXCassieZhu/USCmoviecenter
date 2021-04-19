//
//  DetailView.swift
//  movie
//
//  Created by ruiqi on 2021/4/17.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct DetailView: View {
    @EnvironmentObject var listData: WatchList
    @EnvironmentObject var notice: Notice
    @State var fetched = false;
    @State var detail : Detail?
    @State var video : Video = Video(site: "Youtube", type: "fake", name: "undefined", key: "tzkWB85ULJY")
    @State var item : listItem = listItem(ID: "", type: "", path: "https://cinemaone.net/images/movie_placeholder.png")
    
    private var ID: String
    private var type: String
    
    init(ID: String, type: String) {
        self.ID = ID
        self.type = type
    }
    
    func loadData(){
        self.fetched = false
        AF.request("https://ruiqi571.wl.r.appspot.com/ios/detail/\(self.type)/\(self.ID)").responseData{
            (data) in
            let json = try! JSON(data: data.data!)
            self.detail = Detail(ID: self.ID, type: self.type, title: json["title"].stringValue, date: json["release_date"].stringValue, starRate: json["vote_average"].doubleValue/2, overview: json["overview"].stringValue, genres: json["genres"].stringValue, imgPath: json["poster_path"].stringValue)
            self.item = listItem(ID: self.ID, type: self.type, path: json["poster_path"].stringValue)
            AF.request("https://ruiqi571.wl.r.appspot.com/ios/video/\(self.type)/\(self.ID)").responseData{
                (data) in
                let json = try! JSON(data: data.data!)
                self.video = Video(site: json["site"].stringValue, type: json["type"].stringValue, name: json["name"].stringValue, key: json["key"].stringValue)
                self.fetched = true
            }
        }
    }
    
    var body: some View {
        if(self.fetched == false){
            ProgressView("Fetching Data...")
                .onAppear{self.loadData()}
        }else{
                ScrollView(.vertical){
                    VStack(alignment: .leading, spacing: 10){
                        YouTubeView(key: video.key)
                        Text(self.detail?.title ?? "Unknown")
                            .font(.system(size: 28))
                            .fontWeight(.bold)
                        Text("\(self.detail?.date ?? "N/A") | \(self.detail?.genres ?? "N/A")")

                        Text(self.detail?.overview ?? "")
                        Text("Cast & Crew")
                            .font(.system(size: 23, design: .rounded))
                            .fontWeight(.bold)
                        HStack{
                            
                        }
                        Text("Reviews")
                    }
                }.padding(.leading, 20)
                .padding(.trailing, 20)
                .navigationBarItems(
                trailing:
                    HStack{
                        Button(action: {
                            if(self.listData.list.contains(self.item)){
                                if let index = self.listData.list.firstIndex(of: self.item){
                                    self.listData.list.remove(at: index)
                                    notice.msg = "\(self.detail?.title ?? "Unknown") was removed from Watchlist"
                                }
                            }else{
                                self.listData.list.append(self.item)
                                notice.msg = "\(self.detail?.title ?? "Unknown") was added to Watchlist"
                            }
                            self.listData.save(data: self.listData)
                            notice.showToast = true
                        }){
                            if(self.listData.list.contains(self.item)){
                                Image(systemName: "bookmark.fill")
                                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            }else{
                                Image(systemName: "bookmark")
                                    .foregroundColor(.black)
                            }
                        }

                        Button(action: {
                            let formattedString = "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/"+self.type+"/\(self.ID)"
                            guard let url = URL(string: formattedString) else { return }
                            UIApplication.shared.open(url)
                        }){
                            Image("facebook-app-symbol")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        }
                        Button(action: {
                            let tmdburl = "https://www.themoviedb.org/"+self.type+"/\(self.ID)"
                            let formattedString = "https://twitter.com/intent/tweet?text=Check%20out%20this%20link:%20"+tmdburl+"&hashtags=CSCI571USCFilms"
                            guard let url = URL(string: formattedString) else { return }
                            UIApplication.shared.open(url)
                        }){
                            Image("twitter")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        }
                }
            )
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(ID: "1",type: "movie")
    }
}
