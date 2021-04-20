//
//  SearchResultView.swift
//  movie
//
//  Created by ruiqi on 2021/4/20.
//

import SwiftUI

struct SearchResultView: View {
    private var searchVM: SearchVM
    
    init(searchVM: SearchVM){
        self.searchVM = searchVM
    }
    
    var body: some View {
        ForEach(self.searchVM.searchResult, id: \.self){ result in
            Text(result.title)
        }
    }
}
//
//struct SearchResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchResultView()
//    }
//}
