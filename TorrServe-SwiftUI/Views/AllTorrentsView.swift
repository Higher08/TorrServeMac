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
    @State var selectHash: String = ""
    @State var presentCache: Bool = false
    
    @EnvironmentObject var appState: AppState
    var body: some View {
        ZStack {
            if loading {
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
                        HStack {
                            Text("\(item.name ?? item.title ?? "Unknown")")
                                .font(.title2)
                            Spacer()
                            Button(action: {presentCache = true; selectHash = item.hash ?? ""}) {
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color.green)
                            }
                            Button(action: {ServerNetworkManager().drop(hash: item.hash!) { (error) in
                                print(error)
                            }}) {
                                Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color.blue)
                            }
                            Button(action: {ServerNetworkManager().remove(hash: item.hash!) { (error) in
                                print(error)
                            }}) {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color.red)
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $presentCache) {
            CacheView(hash: $selectHash)
        }
        .onAppear() {
            loading = true
            timesCount += 1
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
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
