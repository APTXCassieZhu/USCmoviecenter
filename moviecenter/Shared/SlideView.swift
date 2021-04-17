//
//  SlideView.swift
//  movie
//
//  Created by ruiqi on 2021/4/15.
//

import SwiftUI
import Kingfisher

struct SlideView: View {
    private var slideList: [Slide]
    private var title: String
    
    init(slideList: [Slide], title: String) {
        self.slideList = slideList
        self.title = title
    }
    
    @State var selected : Slide? = nil

    var body: some View {
        VStack(alignment: .leading){
            Text(self.title)
                .font(.system(size: 23, design: .rounded))
                .fontWeight(.bold)
            ScrollView(.horizontal){
                HStack(alignment: .top, spacing: 25) {
                    ForEach(self.slideList,  id: \.self){ slide in
                        NavigationLink(destination: DetailView(slide: slide), tag: slide, selection: $selected){
                            VStack{
                                    KFImage(URL(string: slide.path)!)
                                        .resizable()
                                        .scaledToFill()
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
                            }.frame(width: 95)
                            .contentShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                selected = slide
                            }
                            .contextMenu(ContextMenu(menuItems: {
                                                        Text("Menu Item 1")
                                                        Text("Menu Item 2")
                                                        Text("Menu Item 3")}))
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
