//
//  DetailView.swift
//  movie
//
//  Created by ruiqi on 2021/4/17.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import Kingfisher

struct DetailView: View {
    @EnvironmentObject var listData: WatchList
    @EnvironmentObject var notice: Notice
    @State var fetched = false;
    @State var detail : Detail?
    @State var video : Video = Video(site: "Youtube", type: "fake", name: "undefined", key: "tzkWB85ULJY")
    @State var item : listItem = listItem(ID: "", type: "", path: "https://cinemaone.net/images/movie_placeholder.png")
    @State var castList: [Cast] = []
    @State var reviewList: [Review] = []
    @State var recommendList: [listItem] = []
    
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
            self.detail = Detail(ID: self.ID, type: self.type, title: json["title"].stringValue, date: json["release_date"].stringValue, starRate: json["vote_average"].stringValue, overview: json["overview"].stringValue, genres: json["genres"].stringValue, imgPath: json["poster_path"].stringValue)
            self.item = listItem(ID: self.ID, type: self.type, path: json["poster_path"].stringValue)
            AF.request("https://ruiqi571.wl.r.appspot.com/ios/video/\(self.type)/\(self.ID)").responseData{
                (data) in
                let json = try! JSON(data: data.data!)
                print(self.ID)
                self.video = Video(site: json["site"].stringValue, type: json["type"].stringValue, name: json["name"].stringValue, key: json["key"].stringValue)
                AF.request("https://ruiqi571.wl.r.appspot.com/ios/cast/\(self.type)/\(self.ID)").responseData{
                    (data) in
                    let json = try! JSON(data: data.data!)
                    for i in json["castList"]{
                        self.castList.append(Cast(ID: i.1["id"].stringValue, name: i.1["name"].stringValue, path: i.1["profile_path"].stringValue)
                        )
                    }
                    AF.request("https://ruiqi571.wl.r.appspot.com/ios/review/\(self.type)/\(self.ID)").responseData{
                        (data) in
                        let json = try! JSON(data: data.data!)
                        for i in json{
                            self.reviewList.append(Review(author: i.1["author"].stringValue, date: i.1["created_at"].stringValue, starRate:  i.1["author_details"]["rating"].stringValue, content: i.1["content"].stringValue))
                        }
                        AF.request("https://ruiqi571.wl.r.appspot.com/ios/recommend/\(self.type)/\(self.ID)").responseData{
                            (data) in
                            let json = try! JSON(data: data.data!)
                            for i in json["resultList"]{
                                self.recommendList.append(listItem(ID: i.1["id"].stringValue, type: i.1["media_type"].stringValue, path: i.1["poster_path"].stringValue))
                            }
                            self.fetched = true
                        }
                    }
                }
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
                    if(video.type != "fake"){
                        YouTubeView(key: video.key)
                    }
                    Text(self.detail?.title ?? "Unknown")
                        .font(.system(size: 28))
                        .fontWeight(.bold)
                    Text("\(self.detail?.date ?? "N/A") | \(self.detail?.genres ?? "N/A")")
                    HStack{
                        Image(systemName: "star.fill")
                            .foregroundColor(.red)
                        Text("\(self.detail?.starRate ?? "0.0")/5.0")
                    }
                    ShowMoreLessView(text: self.detail?.overview ?? "")

                    if(self.castList.count != 0){
                        Text("Cast & Crew")
                            .font(.system(size: 23, design: .rounded))
                            .fontWeight(.bold)
                        ScrollView(.horizontal){
                            LazyHStack{
                                ForEach(self.castList,  id: \.self){ cast in
                                    VStack{
                                        KFImage(URL(string: cast.path)!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 95, height: 140)
                                            .clipShape(Circle())
                                        Text(cast.name)
                                            .font(.system(size:14))
                                    }
                                }
                            }
                        }
                    }
                    if(self.reviewList.count != 0){
                        Text("Reviews")
                            .font(.system(size: 23, design: .rounded))
                            .fontWeight(.bold)
                        ForEach(self.reviewList,  id: \.self){ review in
                            NavigationLink(destination: ReviewView(review: review, title: self.detail?.title ?? "Unknown")){
                                VStack(alignment: .leading){
                                    Text("A review by \(review.author)")
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    Text("Written by \(review.author) on \(review.date)")
                                        .foregroundColor(.gray)
                                    HStack{
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.red)
                                        Text("\(review.starRate)/5.0")
                                            .foregroundColor(.black)
                                    }.padding(.top, 5)
                                    .padding(.bottom, 5)
                                    Text(review.content)
                                        .lineLimit(3)
                                        .foregroundColor(.black)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .frame(width: 350, alignment: .topLeading)
                                }.padding(10)
                                .frame(width: 360)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            }
                        }
                    }
                    if(self.recommendList.count != 0){
                        if(self.type == "movie"){
                            Text("Recomended Movies")
                                .font(.system(size: 23, design: .rounded))
                                .fontWeight(.bold)
                        }else{
                            Text("Recomended TV shows")
                                .font(.system(size: 23, design: .rounded))
                                .fontWeight(.bold)
                        }
                        ScrollView(.horizontal){
                            HStack(alignment: .top, spacing: 28.5) {
                                ForEach(self.recommendList,  id: \.self){ slide in
                                    NavigationLink(destination: DetailView(ID: slide.ID, type: slide.type)){
                                        KFImage(URL(string: slide.path)!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 110, height: 160)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                    }
                }
            }.padding(.leading, 17)
            .padding(.trailing, 17)
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
