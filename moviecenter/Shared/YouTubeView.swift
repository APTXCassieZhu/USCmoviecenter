//
//  YouTubeView.swift
//  movie
//
//  Created by ruiqi on 2021/4/18.
//

import SwiftUI
import youtube_ios_player_helper
import UIKit

struct YTWrapper : UIViewRepresentable{
    var videoID : String
    
    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView()
        playerView.load(withVideoId: videoID);
        return playerView
    }
    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        //
    }
}

struct YouTubeView: View {
    private var key: String
    
    init(key: String){
        self.key = key
    }
    
    var body: some View {
        YTWrapper(videoID: key)
            .frame(height: 200)
    }
}

