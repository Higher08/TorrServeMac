//
//  ContentView.swift
//  TorrServe-SwiftUI
//
//  Created by Dmytro on 12.03.2021.
//

import SwiftUI
import Alamofire

struct ContentView1: View {
    @State var items = ["foo", "bar", "baz"]
    @State var selection: String? = nil
    
    var body: some View {
        List(selection: $selection) {
            ForEach(items, id: \.self) { Text($0) }
        }
        .onDeleteCommand {
            if
                let sel = self.selection,
                let idx = self.items.firstIndex(of: sel) {
                print("delete item: \(sel)")
                self.items.remove(at: idx)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.default)
    }
}


struct ContentView: View {
    
    @State var TorrServerIP = "http://192.168.0.196:8090"
    @State var version: String = "Не отвечает"
    @State var torrTimer: Timer?
    @State var torrents: Torrent = [TorrentElement(title: "Raya.and.the.Last.Dragon.2160p.DSNP.WEB-DL.HDR.x265-KinoPub.mkv", poster: "", timestamp: 1615748490, name: "", hash: "aae60843373488cc32c3983b337083ab4a62ea19", stat: 3, statString: "Torrrent working", torrentSize: 15141903592, totalPeers: 57, pendingPeers: 57, fileStats: [FileStat(id: 1, path: "Raya.and.the.Last.Dragon.2160p.DSNP.WEB-DL.HDR.x265-KinoPub.mkv", length: 15141903592)]), TorrentElement(title: "The.Croods.A.New.Age.2020.1080p.WEBDL.MegaPeer.mkv", poster: "", timestamp: 1615748285, name: "The.Croods.A.New.Age.2020.1080p.WEBDL.MegaPeer.mkv", hash: "2c4d04240d9756dcec2870cb55ca1ceb12f9894f", stat: 3, statString: "Torrrent working", torrentSize: 6351255335, totalPeers: 500, pendingPeers: 500, fileStats: [FileStat(id: 1, path: "The.Croods.A.New.Age.2020.1080p.WEBDL.MegaPeer.mkv", length: 6351255335)]), TorrentElement(title: "Crisis.2021.WEB-DL.1080p.W.mkv", poster: "", timestamp: 1615733233, name: "Crisis.2021.WEB-DL.1080p.W.mkv", hash: "10b8cadb29592a22d70cdba1b7a9accf6ac73b22", stat: 3, statString: "Torrrent working", torrentSize: 11454710697, totalPeers: 500, pendingPeers: 500, fileStats: [FileStat(id: 1, path: "Crisis.2021.WEB-DL.1080p.W.mkv", length: 11454710697)])]
    @State var selection: TorrentElement? = nil
    
    
    var body: some View {
        HStack(spacing: 30) {
            Button(action: {}, label: {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .resizable().aspectRatio(contentMode: .fit)
            })
            .padding(.vertical, 100).padding(.leading, 50)
            .buttonStyle(PlainButtonStyle())
            VStack {
                Image("17271464")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(version)
            }
            Button(action: {}, label: {
                Image(systemName: "power")
                    .resizable().aspectRatio(contentMode: .fit)
                
            })
            .padding(.vertical, 100).padding(.trailing, 50)
            .buttonStyle(PlainButtonStyle())
        }
        list
    }
    
    private var list: some View {
        List(selection: $selection) {
            ForEach(torrents, id: \.self) { (item) in
                Text("\(item.name ?? item.title ?? "No")")
                
            }
        }
        .background(Color.clear)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear() {
            print(torrents)
            getHash()
            getVersion()
            torrTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                getTorrents { (list) in
                    print(list)
//                    torrents = list
                }
            }
            torrTimer!.fire()
        }
    }
    
    func delete(at offsets: IndexSet) {
        torrents.remove(atOffsets: offsets)
    }
    
    func getHash() {
        let path = Bundle.main.url(forResource: "raya", withExtension: "torrent")
        print(path)
        let data = try! Data(contentsOf: path!)
        let mime = returnMime(fileExtension: "torrent")
        AF.upload(multipartFormData: { (form) in
            form.append(Data("true".utf8), withName: "save")
            form.append(data, withName: "file0", fileName: "raya)", mimeType: mime)
        }, to: "\(TorrServerIP)/torrent/upload")
        .uploadProgress(closure: { (progress) in
            print(progress.fractionCompleted*100)
        })
        .response { response in
            print(response.data)
            print(response.error)
            print(response.response?.description as Any)
        }
    }
    
    func returnMime(fileExtension: String) -> String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension as NSString, nil)?.takeRetainedValue() {
            if let mimeType = UTTypeCreatePreferredIdentifierForTag(uti, kUTTagClassMIMEType, nil)?.takeRetainedValue() {
                return mimeType as String
            }
        }
        return ""
    }
    func getTorrents(completion: @escaping (_ result: Torrent)->()) {
        let parameters = "{\"action\": \"list\"}"
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "\(TorrServerIP)/torrents")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            do {
                let json = try JSONDecoder().decode(Torrent.self, from: data)
                completion(json)
            } catch {
                print(error)
                return
            }
        }
        task.resume()
    }
    
    func getVersion() {
        
        var request = URLRequest(url: URL(string: "\(TorrServerIP)/echo")!,timeoutInterval: Double.infinity)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            version = responseString ?? "Сервер не отвечает"
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    func getStream(magnet: String) {
        
        var request = URLRequest(url: URL(string: "\(TorrServerIP)/stream/fname?link=\(magnet)&index=1&play&save")!,timeoutInterval: Double.infinity)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
