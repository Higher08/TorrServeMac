//
//  AllTorrentsView.swift
//  TorrServe-SwiftUI
//
//  Created by Dmytro on 03.04.2021.
//

import SwiftUI

struct AllTorrentsView: View {
    @State var torrents: Torrent = []
    @State var selection: TorrentElement? = nil
    @State var error: String?
    @State var loading: Bool = false
    @State var timesCount: Int = 0
    var body: some View {
        ZStack {
            if loading && timesCount < 2 {
                ProgressView()
            } else if error != nil {
                VStack {
                    Text("Ошибка подключения").font(.title).bold()
                    Text(error!)
                }
            } else if torrents.isEmpty {
                Text("Торрентов не добавлено").font(.title).bold()
            } else {
                List(selection: $selection) {
                    ForEach(torrents, id: \.self) { (item) in
                        Text("\(item.name ?? item.title ?? "Unknown")")
                    }
                }
            }
        }
        .onAppear() {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                loading = true
                timesCount += 1
                ServerNetworkManager().list { (torrentList, error) in
                    if error == nil {
                        self.torrents = torrentList ?? []
                        loading = false
                    } else {
                        self.error = error
                    }
                }
            }
        }
    }
}

struct AllTorrentsView_Previews: PreviewProvider {
    static var previews: some View {
        AllTorrentsView()
    }
}
