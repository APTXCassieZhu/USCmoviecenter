//
//  BottomView.swift
//  movie
//
//  Created by ruiqi on 2021/4/16.
//

import SwiftUI

struct BottomView: View {
    var body: some View {
        Link("Powered by TMDB.", destination: URL(string: "https://www.themoviedb.org/")!)
            .frame(width: 370, alignment: .center)
            .foregroundColor(.gray)
            .font(.system(size: 14))
        Text("Developed by Ruiqi Zhu")
            .frame(width: 370, alignment: .center)
            .foregroundColor(.gray)
            .font(.system(size: 14))
        Spacer()
        Spacer()
    }
}

struct BottomView_Previews: PreviewProvider {
    static var previews: some View {
        BottomView()
    }
}
