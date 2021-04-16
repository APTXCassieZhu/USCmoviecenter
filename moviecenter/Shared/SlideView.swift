//
//  SlideView.swift
//  movie
//
//  Created by ruiqi on 2021/4/15.
//

import SwiftUI

struct SlideView: View {
    var body: some View {
        VStack {
            Text("Top Rated")
            HStack {
                Text("Content")
                VStack {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
                }
            }
        }
    }
}

struct SlideView_Previews: PreviewProvider {
    static var previews: some View {
        SlideView()
    }
}
