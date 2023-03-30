//
//  VideoView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/3/23.
//

import SwiftUI
import AVKit

struct VideoView: View {
    let video: Video
    @State private var isPlaying: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                ZStack(alignment: .center) {
                    AsyncImage(url: video.site.thumbnail(videoId: video.key)) { image in
                        image.resizable()
                    } placeholder: {
                        ZStack {
                            Color.clear
                            ProgressView("Loading...")
                                .foregroundColor(.white)
                                .font(.body)
                                .progressViewStyle(.automatic)
                        }
                    }
                    .overlay {
                        ZStack {
                            Color(white: 0, opacity: 0.3)
                            Button {
                                isPlaying.toggle()
                            } label: {
                                Image(systemName: "play")
                                    .padding(8)
                                    .foregroundColor(.white)
                                    .border(Color.white, width: 1)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width/1.3, minHeight: UIScreen.main.bounds.width/2.2, maxHeight: UIScreen.main.bounds.width/2.2)
            Text(video.name)
                .font(.footnote)
                .frame(maxWidth: UIScreen.main.bounds.width/1.3)
        }
        .popover(isPresented: $isPlaying) {
            switch video.site {
            case .YouTube:
                YTVideoPlayerView(videoID: video.key)
                    .background(Color.clear)
            case .Vimeo:
                VideoPlayer(player: AVPlayer(url: video.site.video(videoId: video.key)!))
                    .frame(height: 400)
            }
            
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(video: .init(name: "Final Trailer",
                               key: "yjRHZEUamCc",
                               site: .YouTube,
                               size: 1080,
                               type: .Trailer,
                               official: true,
                               published_at: "2023-02-16T15:15:17.000Z",
                               id: "63ee4eff1b729400866e5006"))
    }
}
