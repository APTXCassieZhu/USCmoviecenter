//
//  GridItemView.swift
//  movie
//
//  Created by ruiqi on 2021/4/18.
//
 
import SwiftUI
import Kingfisher

struct GridView: View {
    @StateObject var listData = WatchList()
    @State private var dragging: listItem?
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 2, content: {
                ForEach(listData.list, id: \.self){ listitem in
                    NavigationLink(destination: DetailView(ID: listitem.ID, type: listitem.type)){
                        KFImage(URL(string: listitem.path)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 118, height: 180)
                            .clipped()
                    }
//                    .onDrag {
//                        return NSItemProvider(object: String(id) as NSString)
//                    }
//                    .onDrop(of: listItem, delegate: DropViewDelegate(item: listitem, watchlistData: $listData.list, current: $dragging))
                }
            }).frame(width: 360)
            .padding(.leading, 20)
            .padding(.trailing, 20)
        }
    }
}

struct DropViewDelegate: DropDelegate{
    let item: listItem
    @Binding var watchlistData: [listItem]
    @Binding var current: listItem?

    func dropEntered(info: DropInfo) {
        if item != current {
            let from = watchlistData.firstIndex(of: current!)!
            let to = watchlistData.firstIndex(of: item)!
            if watchlistData[to].ID != current!.ID {
                watchlistData.move(fromOffsets: IndexSet(integer: from),
                    toOffset: to > from ? to + 1 : to)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        self.current = nil
        return true
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
    }
}
