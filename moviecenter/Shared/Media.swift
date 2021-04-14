//
//  Media.swift
//  movie
//
//  Created by ruiqi on 2021/4/13.
//

import Foundation

class Media {
    var id: Int
    var title: String
    var type: String
    var path: String
    
    
    init(id: Int, title: String, type: String, path: String){
        self.id = id
        self.title = title
        self.type = type
        self.path = path
    }
}
