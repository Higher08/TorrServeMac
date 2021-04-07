////
////  ContentView.swift
////  TorrServe-SwiftUI
////
////
//
//import SwiftUI
//import Alamofire
//
//
//struct ContentView: View {
//    
//    @State var TorrServerIP = "http://127.0.0.1:8090"
//    @State var version: String = "Не отвечает"
//    @State var torrTimer: Timer?
//    @State var torrents: Torrent = []
//    @State var selection: TorrentElement? = nil
//    
//    
//    var body: some View {
//        
//        HStack(spacing: 30) {
//            Button(action: {}, label: {
//                Image(systemName: "arrow.triangle.2.circlepath")
//                    .resizable().aspectRatio(contentMode: .fit)
//            })
//            .padding(.vertical, 100).padding(.leading, 50)
//            .buttonStyle(PlainButtonStyle())
//            VStack {
//                Image("17271464")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                Text(version)
//            }
//            Button(action: {}, label: {
//                Image(systemName: "power")
//                    .resizable().aspectRatio(contentMode: .fit)
//                
//            })
//            .padding(.vertical, 100).padding(.trailing, 50)
//            .buttonStyle(PlainButtonStyle())
//        }
//        list
//    }
//    
//    private var list: some View {
//        List(selection: $selection) {
//            ForEach(torrents, id: \.self) { (item) in
//                Text("\(item.name ?? item.title ?? "No")")
//            }
//        }
//        //        .background(Color.clear)
//        //        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .onAppear() {
//            print(ProcessInfo().machineHardwareName)
//        }
//    }
//    
//    func delete(at offsets: IndexSet) {
//        torrents.remove(atOffsets: offsets)
//    }
//    
//    func download() {
//        let url = URL(string: "https://github.com/YouROK/TorrServer/releases/download/MatriX.85/TorrServer-darwin-amd64")!
//        let destination = DownloadRequest.suggestedDownloadDestination(for: .downloadsDirectory, in: .userDomainMask)
//        AF.download(
//            url,
//            method: .get,
//            parameters: nil,
//            encoding: JSONEncoding.default,
//            headers: nil,
//            to: destination).downloadProgress(closure: { (progress) in
//                //progress closure
//            }).response(completionHandler: { (DefaultDownloadResponse) in
//                if let path = DefaultDownloadResponse.fileURL?.path {
//                    let chmod = Process()
//                    chmod.launchPath = "/bin/zsh"
//                    chmod.arguments = ["-c", "chmod +x \(path)"]
//                    print(chmod.arguments)
//                    let chModpipe = Pipe()
//                    chmod.standardOutput = chModpipe
//                    chmod.launch()
//                    
//                    let chmodData = chModpipe.fileHandleForReading.readDataToEndOfFile()
//                    let chModoutput: String = NSString(data: chmodData, encoding: String.Encoding.utf8.rawValue)! as String
//                    print(chModoutput)
//                    
//                    let quarantine = Process()
//                    quarantine.launchPath = "/bin/sh"
//                    quarantine.arguments = ["script.sh", path]
//                    quarantine.currentDirectoryPath = Bundle.main.resourcePath!
//                    print(quarantine.arguments)
//                    let quarantinePipe = Pipe()
//                    quarantine.standardOutput = quarantinePipe
//                    quarantine.launch()
//                    let quarantineData = quarantinePipe.fileHandleForReading.readDataToEndOfFile()
//                    let quarantineOutput: String = NSString(data: quarantineData, encoding: String.Encoding.utf8.rawValue)! as String
//                    print(quarantineOutput)
//                    
//                    let server = Process()
//                    server.currentDirectoryPath = Bundle.main.bundlePath
//                    server.executableURL = DefaultDownloadResponse.fileURL
//                    do {
//                        try server.run()
//                        AppState.shared.serverProcess = server
//                    } catch {
//                        print(error)
//                    }
//                }
//            })
//    }
//    
//    func upload() {
//        let path = Bundle.main.url(forResource: "raya", withExtension: "torrent")
//        print(path)
//        let data = try! Data(contentsOf: path!)
//        let mime = returnMime(fileExtension: "torrent")
//        AF.upload(multipartFormData: { (form) in
//            form.append(Data("true".utf8), withName: "save")
//            form.append(data, withName: "file0", fileName: "raya)", mimeType: mime)
//        }, to: "\(TorrServerIP)/torrent/upload")
//        .uploadProgress(closure: { (progress) in
//            print(progress.fractionCompleted*100)
//        })
//        .response { response in
//            print(response.data)
//            print(response.error)
//            print(response.response?.description as Any)
//        }
//    }
//    
//    func returnMime(fileExtension: String) -> String {
//        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension as NSString, nil)?.takeRetainedValue() {
//            if let mimeType = UTTypeCreatePreferredIdentifierForTag(uti, kUTTagClassMIMEType, nil)?.takeRetainedValue() {
//                return mimeType as String
//            }
//        }
//        return ""
//    }
//    func getTorrents(completion: @escaping (_ result: Torrent)->()) {
//        let parameters = "{\"action\": \"list\"}"
//        let postData = parameters.data(using: .utf8)
//        
//        var request = URLRequest(url: URL(string: "\(TorrServerIP)/torrents")!,timeoutInterval: Double.infinity)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        request.httpMethod = "POST"
//        request.httpBody = postData
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print("error=\(String(describing: error))")
//                return
//            }
//            
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(String(describing: response))")
//                return
//            }
//            
//            do {
//                let json = try JSONDecoder().decode(Torrent.self, from: data)
//                completion(json)
//            } catch {
//                print(error)
//                return
//            }
//        }
//        task.resume()
//    }
//    
//    func getVersion() {
//        
//        var request = URLRequest(url: URL(string: "\(TorrServerIP)/echo")!,timeoutInterval: Double.infinity)
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print("error=\(String(describing: error))")
//                return
//            }
//            
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(String(describing: response))")
//                return
//            }
//            
//            let responseString = String(data: data, encoding: .utf8)
//            version = responseString ?? "Сервер не отвечает"
//            print("responseString = \(String(describing: responseString))")
//        }
//        task.resume()
//    }
//    func getStream(magnet: String) {
//        
//        var request = URLRequest(url: URL(string: "\(TorrServerIP)/stream/fname?link=\(magnet)&index=1&play&save")!,timeoutInterval: Double.infinity)
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print("error=\(String(describing: error))")
//                return
//            }
//            
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(String(describing: response))")
//                return
//            }
//            
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(String(describing: responseString))")
//        }
//        task.resume()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
