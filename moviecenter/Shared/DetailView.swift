//
//  DetailView.swift
//  movie
//
//  Created by ruiqi on 2021/4/17.
//

import SwiftUI

struct DetailView: View {
    private var ID: Int
    private var type: String
    
    init(ID: Int, type: String) {
        self.ID = ID
        self.type = type
    }
    
    var body: some View {
        Text("\(self.ID)")
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}
