//
//  VideoPlayerView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/3/23.
//

import SwiftUI
import YouTubeiOSPlayerHelper

struct VideoPlayerView : UIViewRepresentable {
    var videoID : String
    
    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView(frame: .init(x: 0,
                                                   y: 0,
                                                   width: UIScreen.main.bounds.width/1.3,
                                                   height: UIScreen.main.bounds.width/2.2))
        playerView.load(withVideoId: videoID)
        return playerView
    }
    
    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        //
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView(videoID: "jQtP1dD6jQ0")
    }
}
