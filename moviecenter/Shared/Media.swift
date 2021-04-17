//
//  Media.swift
//  movie
//
//  Created by ruiqi on 2021/4/13.
//

import Foundation

struct Media : Hashable{
    var ID: Int
    var title: String
    var type: String
    var path: String
    
    init(ID: Int, title: String, type: String, path: String){
        self.ID = ID
        self.title = title
        self.type = type
        self.path = path
    }
}

struct Slide : Hashable {
    var ID: Int
    var title: String
    var type: String
    var path: String
    var date: String
    
    init(ID: Int, title: String, type: String, path: String, date: String){
        self.ID = ID
        self.title = title
        self.type = type
        self.path = path
        self.date = date
    }
}
