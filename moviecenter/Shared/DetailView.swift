//
//  DetailView.swift
//  movie
//
//  Created by ruiqi on 2021/4/17.
//

import SwiftUI

struct DetailView: View {
    var slide: Slide
    
    init(slide: Slide) {
        self.slide = slide
    }
    
    var body: some View {
        Text(slide.title)
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}
