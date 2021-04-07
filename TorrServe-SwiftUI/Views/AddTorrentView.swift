//
//  AdddTorrentView.swift
//  TorrServe-SwiftUI
//
//  Created by Dmytro on 03.04.2021.
//

import SwiftUI
import Alamofire

struct AddTorrentView: View {
    
    @State var magnet: String = ""
    @State var title: String = ""
    @State var poster: String = ""
    @State var error: String?
    @State var succes: Bool = false
    
    var body: some View {
        Button(action: {upload()}) {
            Text("Выберите файл")
        }
        Text("Или введите")
        HStack {
            TextField("Магнет ссылка или хэш", text: $magnet)
                .padding(.vertical, 8)
                .frame(width: 400, height: 25)
                .background(Color("SearchField"))
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
        .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.clear, lineWidth: 0)
                        .background(Color("SearchField").cornerRadius(8)))
        HStack {
            TextField("Названия", text: $title)
                .padding(.vertical, 8)
                .frame(width: 400, height: 25)
                .background(Color("SearchField"))
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
        .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.clear, lineWidth: 0)
                        .background(Color("SearchField").cornerRadius(8)))
        HStack {
            TextField("Постер", text: $poster)
                .padding(.vertical, 8)
                .frame(width: 400, height: 25)
                .background(Color("SearchField"))
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
        .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.clear, lineWidth: 0)
                        .background(Color("SearchField").cornerRadius(8)))
        Button(action: {add()}) {
            Text("Добавить")
        }
        if error != nil {
            Text("Ошибка")
            Text(error ?? "")
        }
        if succes {
            Text("Успешно добавлено")
        }
    }
    
    func add() {
        ServerNetworkManager().addTorrent(magnet: self.magnet, title: self.title, poster: self.poster) { (res, error) in
            if error == nil && res == true {
                succes = true
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                    succes = false
                }
            } else {
                self.error = error
                Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (_) in
                    self.error = nil
                }
            }
        }
    }
    
    func upload() {
        let panel = NSOpenPanel()
        panel.nameFieldLabel = "Выберите файл"
        panel.canCreateDirectories = true
        panel.allowedFileTypes = ["torrent"]
        DispatchQueue.main.async {
            
            panel.beginSheetModal(for: NSApp.mainWindow ?? NSWindow()) { response in
                if response == NSApplication.ModalResponse.OK, let fileUrl = panel.url {
                    print(fileUrl)
                    let data = try! Data(contentsOf: fileUrl)
                    let mime = returnMime(fileExtension: "torrent")
                    let ip = UserDefaults.standard.string(forKey: "serverIP")
                    let port = UserDefaults.standard.string(forKey: "serverPort")
                    AF.upload(multipartFormData: { (form) in
                        form.append(Data("true".utf8), withName: "save")
                        form.append(data, withName: "file0", fileName: "raya)", mimeType: mime)
                    }, to: "http://\(ip ?? "127.0.0.1"):\(port ?? "8090")/torrent/upload")
                    .uploadProgress(closure: { (progress) in
                        print(progress.fractionCompleted*100)
                    })
                    .response { response in
                        switch response.result {
                        case .success:
                            self.succes = true
                            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
                                self.succes = false
                            }
                        case let .failure(error):
                            self.error = error.errorDescription
                            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (_) in
                                self.error = nil
                            }
                        }
                        self.error = response.error?.localizedDescription
                        print(response.result)
                        print(response.response?.description as Any)
                    }
                }
            }
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
}

struct AdddTorrentView_Previews: PreviewProvider {
    static var previews: some View {
        AddTorrentView()
    }
}
