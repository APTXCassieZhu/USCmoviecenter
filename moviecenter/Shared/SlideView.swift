//
//  SlideView.swift
//  movie
//
//  Created by ruiqi on 2021/4/15.
//

import SwiftUI
import Kingfisher
import Foundation

struct SlideView: View {
    private var slideList: [Slide]
    private var title: String
    
    @EnvironmentObject var notice: Notice
    @EnvironmentObject var listData: WatchList

    init(slideList: [Slide], title: String) {
        self.slideList = slideList
        self.title = title
    }
    
    @State var selected : Int? = nil
    
    var body: some View {
        VStack(alignment: .leading){
            Text(self.title)
                .font(.system(size: 23, design: .rounded))
                .fontWeight(.bold)
            ScrollView(.horizontal){
                HStack(alignment: .top, spacing: 28.5) {
                    ForEach(self.slideList,  id: \.self){ slide in
                        NavigationLink(destination: DetailView(ID: slide.ID, type: slide.type), tag: slide.ID, selection: $selected){
                            VStack{
                                    KFImage(URL(string: slide.path)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 95, height: 140)
                                        .cornerRadius(10)
                                        
                                    Text(slide.title)
                                        .font(.system(size: 14))
                                        .fontWeight(.heavy)
                                        .foregroundColor(Color.black)
                                        .multilineTextAlignment(.center)
                                    Text("(\(slide.date))")
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.gray)
                                        
                            }
                            .frame(width: 95)
                            .contentShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                selected = slide.ID
                            }
                            .contextMenu(ContextMenu(menuItems: {
                                Button(action: {
                                    let item = listItem(ID: slide.ID, type: slide.type, path: slide.path)
                                    if(self.listData.list.contains(item)){
                                        if let index = self.listData.list.firstIndex(of: item){
                                            self.listData.list.remove(at: index)
                                            notice.msg = "\(slide.title) was removed from Watchlist"
                                        }
                                    }else{
                                        self.listData.list.append(item)
                                        notice.msg = "\(slide.title) was added to Watchlist"
                                    }
                                    self.listData.save(data: self.listData)
                                    notice.showToast = true
                                }){
                                    if(self.listData.list.contains(listItem(ID: slide.ID, type: slide.type, path: slide.path))){
                                        HStack(spacing: 10) {
                                            Image(systemName: "bookmark.fill")
                                            Text("Remove from watchList")
                                        }
                                    }else{
                                        HStack(spacing: 10) {
                                            Image(systemName: "bookmark")
                                            Text("Add to watchList")
                                        }
                                    }
                                }
                                Button(action: {
                                    let formattedString = "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/"+slide.type+"/\(slide.ID)"
                                    guard let url = URL(string: formattedString) else { return }
                                    UIApplication.shared.open(url)
                                }){
                                    HStack(spacing: 10) {
                                        Image("facebook-app-symbol")
                                            .resizable()
                                            .scaledToFit()
                                        Text("Share on Facebook")
                                    }
                                }
                                Button(action: {
                                    let tmdburl = "https://www.themoviedb.org/"+slide.type+"/\(slide.ID)"
                                    let formattedString = "https://twitter.com/intent/tweet?text=Check%20out%20this%20link:%20"+tmdburl+"&hashtags=CSCI571USCFilms"
                                    guard let url = URL(string: formattedString) else { return }
                                    UIApplication.shared.open(url)
                                }){
                                    HStack(spacing: 10) {
                                        Image("twitter")
                                            .resizable()
                                            .scaledToFit()
                                        Text("Share on Twitter")
                                    }
                                }
                            }))
                        }
                    }
                }
            }
        }
    }
}

//struct SlideView_Previews: PreviewProvider {
//    static var previews: some View {
//        SlideView()
//    }
//}
