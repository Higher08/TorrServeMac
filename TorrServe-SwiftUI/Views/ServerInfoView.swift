//
//  ServerInfoView.swift
//  TorrServe-SwiftUI
//
//  Created by Dmytro on 03.04.2021.
//

import SwiftUI
import ValidatedPropertyKit

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

struct ServerInfoView: View {
    
    @AppStorage("serverIP") private var savedServerIp = "127.0.0.1"
    @AppStorage("serverPort") private var savedServerPort = "8090"
        
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    TextField("Адрес", text: $savedServerIp)
                        .padding(.vertical, 8)
                        .frame(width: 200, height: 25)
                        .background(Color("SearchField"))
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                .background(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.clear, lineWidth: 0)
                                .background(Color("SearchField").cornerRadius(8)))
                Text(":")
                    .font(.largeTitle)
                    .bold()
                HStack {
                    TextField("Порт: 8090", text: $savedServerPort)
                        .padding(.vertical, 8)
                        .frame(width: 70, height: 25)
                        .background(Color("SearchField"))
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                .background(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.clear, lineWidth: 0)
                                .background(Color("SearchField").cornerRadius(8)))
            }
            HStack {
                Text("Статус").font(.title)
                Circle().foregroundColor(appState.version.contains("atri") ? Color.green : Color.red).frame(width: 50, height: 50)
                Text(appState.version.contains("atri") ? "Успешно подключено" : appState.version.isEmpty ? "Сервер не подключен" : "Версия не поддерживается" ).font(.title)
            }
            
            Button(action: {appState.showDownloadLatest = true}) {
                Text("Установить последний локальный сервер")
            }
            .sheet(isPresented: $appState.showDownloadLatest) {
                DownloadLatestView()
            }
            
            Button(action: {
                print(appState.serverProcess)
                kill()
            }) {
                Text("Установить нужную версию")
            }
            Button(action: {
                Shell.shared.kill()
                appState.deleteView = true
            }) {
                Text("Удалить локальный сервер")
            }
            .sheet(isPresented: $appState.deleteView) {
                DeleteServerView()
            }
        }
        .padding()
    }
    func kill() {
        let kill = Process()
        kill.launchPath = "/bin/sh"
        kill.arguments = ["scriptCopy.sh", String(ProcessInfo.processInfo.processIdentifier)]
        kill.currentDirectoryPath = Bundle.main.resourcePath!
        print(kill.arguments)
        let quarantinePipe = Pipe()
        kill.standardOutput = quarantinePipe
        kill.standardError = quarantinePipe
        kill.launch()
        let quarantineData = quarantinePipe.fileHandleForReading.readDataToEndOfFile()
        let quarantineOutput: String = NSString(data: quarantineData, encoding: String.Encoding.utf8.rawValue)! as String
        if !quarantineOutput.isEmpty {
//            error.append(quarantineOutput)
            print(quarantineOutput)
            return
        }
    }
}

struct ServerInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ServerInfoView()
    }
}


extension Validation where Value == String {
    
    static var isProxyIp: Self {
        .init { value in
            let url = URL(string: "https://\(value)")
            let request = URLRequest(url: url ?? URL(string: "127.0.0.1")!)
            if request.url?.absoluteString != "127.0.0.1" {
                return true
            } else {
                return false
            }
        }
    }
    
}
