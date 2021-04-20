//
//  ReviewView.swift
//  movie
//
//  Created by ruiqi on 2021/4/19.
//

import SwiftUI

struct ReviewView: View {
    private var review: Review
    private var title: String
    
    init(review: Review, title: String){
        self.review = review
        self.title = title
    }
    
    var body: some View {
        ScrollView(.vertical){
            VStack(alignment: .leading, spacing: 10){
                Text(self.title)
                    .font(.system(size: 23, design: .rounded))
                    .fontWeight(.bold)
                Text("By \(self.review.author) on \(self.review.date)")
                    .foregroundColor(.gray)
                HStack{
                    Image(systemName: "star.fill")
                        .foregroundColor(.red)
                    Text("\(review.starRate)/5.0")
                }
                Divider().background(Color(UIColor.lightGray))
                Text(review.content)
            }
        }.padding(.leading, 17)
        .padding(.trailing, 17)
    }
}


