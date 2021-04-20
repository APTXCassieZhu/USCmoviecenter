//
//  SearchView.swift
//  moviecenter
//
//  Created by ruiqi on 2021/4/11.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import Kingfisher

class SearchVM: ObservableObject{
    @Published var searchResult = [SearchItem]()
    @Published var label = ""
    
    func search(query: String){
        AF.request("https://ruiqi571.wl.r.appspot.com/ios/search/\(query)").responseData{
            (data) in
            let json = try! JSON(data: data.data!)
            self.searchResult = [SearchItem]()
            self.label = "No Results"
            for i in json["resultList"]{
                self.searchResult.append(SearchItem(ID: i.1["id"].stringValue, type: i.1["media_type"].stringValue, title: i.1["title"].stringValue, date: i.1["date"].stringValue, imgPath: i.1["backdrop_path"].stringValue, starRate: i.1["vote_average"].stringValue))
            }
        }
    }
}

struct SearchView: View {
    @State private var searchText : String = ""
    @ObservedObject var searchVM : SearchVM = SearchVM()
    
    var body: some View {
        NavigationView {
            VStack{
                SearchBar(searchVM: self.searchVM, text: $searchText)
                ScrollView(.vertical){
                    Text(self.searchVM.test)
                    ForEach(self.searchVM.searchResult, id: \.self){ result in
                        Text(result.title)
                    }
                }
            }
            .navigationTitle("Search")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SearchBar: UIViewRepresentable {
    @State var searchVM : SearchVM
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
            UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
            searchBar.showsCancelButton = true
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
           searchBar.setShowsCancelButton(true, animated: true)
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(false, animated: true)
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
        {
            searchBar.endEditing(true)
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            searchBar.endEditing(true)
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search Movies, Tvs..."
        searchBar.autocapitalizationType = .none
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
        if(self.text.count > 2){
            searchVM.search(query: self.text)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
