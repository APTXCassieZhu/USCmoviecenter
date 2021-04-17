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
    
    var body: some View {
        VStack(alignment: .leading){
            Text(self.title)
                .font(.system(size: 23, design: .rounded))
                .fontWeight(.bold)
            ScrollView(.horizontal){
                HStack(spacing: 25) {
                    ForEach(self.slideList,  id: \.self){ slide in
                        VStack{
                            KFImage(URL(string: slide.path)!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 95, height: 140)
                                .cornerRadius(10)
                            Text(slide.title)
                                .font(.system(size: 14))
                                .fontWeight(.heavy)
                                .multilineTextAlignment(.center)
                            Text("(\(slide.date))")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 14))
                                .foregroundColor(Color.gray)
                            Spacer()
                        }.frame(width: 100)
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
