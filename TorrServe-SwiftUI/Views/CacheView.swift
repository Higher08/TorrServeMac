//
//  CacheView.swift
//  TorrServe-SwiftUI
//
//  Created by Dmytro on 07.04.2021.
//

import SwiftUI

struct CacheView: View {
    @Binding var hash: String
    
    @State var model: CacheModel = CacheModel(hash: nil, capacity: nil, filled: nil, piecesLength: nil, piecesCount: nil, torrent: nil, pieces: nil, readers: nil)
    @State var capacity: Int64 = 0
    @State var filled: Int64 = 0
    @State var torrentSize: Int64 = 0
    @State var pieceLenght: Int64 = 0
    @State var piecesCount: Int64 = 0
    @State var connectedSeeders: Int = 0
    @State var pendingPeers: Int = 0
    @State var activePeers: Int = 0
    @State var downloadSpeed: Double = 0
    @State var status: String = ""
    
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        VStack {
            HStack {
                Button(action: {presentationMode.wrappedValue.dismiss()}) {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.red)
                    .padding(.leading)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
            Group {
                HStack {
                    Text("Хэш").bold()
                    Text(hash)
                }
                HStack {
                    Text("Вместимость").bold()
                    Text(String(ByteCountFormatter.string(fromByteCount: Int64(model.capacity ?? 0), countStyle: .file)))
                }
                HStack {
                    Text("Заполнено").bold()
                    Text(ByteCountFormatter.string(fromByteCount:Int64(model.filled ?? 0), countStyle: .file))
                }
                HStack {
                    Text("Размер торрента").bold()
                    Text(ByteCountFormatter.string(fromByteCount: Int64(model.torrent?.torrentSize ?? 0), countStyle: .file))
                }
                HStack {
                    Text("Длина части").bold()
                    Text(ByteCountFormatter.string(fromByteCount: Int64(model.piecesLength ?? 0), countStyle: .file))
                }
                HStack {
                    Text("Количество частей").bold()
                    Text(String(model.piecesCount ?? 0))
                }
                HStack {
                    Text("Подключено").bold()
                    Text(String(model.torrent?.connectedSeeders ?? 0))
                }
                HStack {
                    Text("Всего").bold()
                    Text(String(model.torrent?.pendingPeers ?? 0))
                }
                HStack {
                    Text("Активные").bold()
                    Text(String(model.torrent?.activePeers ?? 0))
                }
                HStack {
                    Text("Скорость").bold()
                    Text(ByteCountFormatter.string(fromByteCount: Int64(model.torrent?.downloadSpeed ?? 0), countStyle: .file))
                }
            }
            HStack {
                Text("Статус").bold()
                Text(model.torrent?.statString ?? "")
            }
        }
        .frame(minWidth: 400, maxWidth: 1000, minHeight: 300, maxHeight: 1000)
        .onAppear() {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (_) in
                ServerNetworkManager().cache(hash: hash) { (model, error) in
                    if error == nil {
                        self.model = model!
                    }
                }
            }
        }
    }
}

