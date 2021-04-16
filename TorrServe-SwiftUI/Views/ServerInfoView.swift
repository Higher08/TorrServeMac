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
            
            Button(action: {
                               Shell.shared.kill()
                               appState.showDownloadLatest = true}) {
                           Text("Установить последний локальный сервер")
                       }
                       .sheet(isPresented: $appState.showDownloadLatest) {
                           DownloadLatestView()
                       }
            
            Button(action: {
                    Shell.shared.kill()
                    appState.needDownloadView = true}, label: {
                Text("Установить нужную версию")
            })
            .sheet(isPresented: $appState.needDownloadView) {
                NeedDownloadView()
            }
            Button(action: {
                Shell.shared.kill()
                appState.deleteView = true
            }) {
                Text("Установить с файла")
            }
            .sheet(isPresented: $appState.deleteView) {
                FileInstallView()
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
