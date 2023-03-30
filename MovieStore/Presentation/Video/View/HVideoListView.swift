//
//  HVideoListView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/3/23.
//

import SwiftUI

struct HVideoListView: View {
    var videoList: [Video]
    var body: some View {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(videoList, id: \.id) { video in
                        VideoView(video: video)
                    }
                }
                .padding(.bottom, 8)
            }
    }
}

struct HVideoListView_Previews: PreviewProvider {
    static var previews: some View {
        let video: Video = .init(name: "Final Trailer",
                          key: "yjRHZEUamCc",
                          site: .YouTube,
                          size: 1080,
                          type: .Trailer,
                          official: true,
                          published_at: "2023-02-16T15:15:17.000Z",
                          id: "63ee4eff1b729400866e5006")
        HVideoListView(videoList: [video, video, video , video])
    }
}
