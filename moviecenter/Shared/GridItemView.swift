//
//  GridItemView.swift
//  movie
//
//  Created by ruiqi on 2021/4/18.
//

import SwiftUI
import Kingfisher

struct GridItemView: View {
    private var item : listItem
    @State var selected : Int? = nil
    
    init(item: listItem){
        self.item = item
    }
    
    var body: some View {
        NavigationLink(destination: DetailView(ID: item.ID, type: item.type), tag: item.ID, selection: $selected){
            KFImage(URL(string: item.path)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 118, height: 180)
                .clipped()
        }.onTapGesture {
            selected = item.ID
        }
        
    }
}
