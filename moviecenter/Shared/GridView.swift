//
//  GridItemView.swift
//  movie
//
//  Created by ruiqi on 2021/4/18.
//
 
import SwiftUI
import Kingfisher
import UniformTypeIdentifiers


struct GridView: View {
    private var listData: WatchList
    @State private var dragging: listItem?
    
    init(listData: WatchList){
        self.listData = listData
    }
    
    @State var selected : Int? = nil
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 3)
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 4, content: {
                ForEach(listData.list, id: \.self){ item in
                    NavigationLink(destination: DetailView(ID: item.ID, type: item.type), tag: item.ID, selection: $selected){
                        KFImage(URL(string: item.path)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .onTapGesture {
                                selected = item.ID
                            }
                            .onDrag {
                                self.dragging = item
                                return NSItemProvider(object: String(item.ID) as NSString)
                            }
                            .onDrop(of: [UTType.text], delegate: DropViewDelegate(item: item, watchlistData: listData, current: $dragging))
                            .contextMenu{
                                Button(action: {
                                    if let index = self.listData.list.firstIndex(of: item){
                                        self.listData.list.remove(at: index)
                                    }
                                    self.listData.save(data: self.listData)
                                }){
                                    HStack(spacing: 10) {
                                        Image(systemName: "bookmark.fill")
                                        Text("Remove from watchList")
                                    }
                                }
                            }
                    }.frame(width: 115, height: 172)
                    
                }
            })
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}

struct DropViewDelegate: DropDelegate{
    let item: listItem
    @State var watchlistData: WatchList
    @Binding var current: listItem?

    func dropEntered(info: DropInfo) {
        if item != current {
            let from = watchlistData.list.firstIndex(of: current!)!
            let to = watchlistData.list.firstIndex(of: item)!
            if watchlistData.list[to].ID != current!.ID {
                watchlistData.list.move(fromOffsets: IndexSet(integer: from),
                    toOffset: to > from ? to + 1 : to)
            }
        }
        watchlistData.save(data: watchlistData)
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        self.current = nil
        return true
    }
}

//struct GridView_Previews: PreviewProvider {
//    static var previews: some View {
//        GridView()
//    }
//}
