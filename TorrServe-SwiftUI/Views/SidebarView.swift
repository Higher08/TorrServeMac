//
//  SidebarView.swift
//  TorrServe-SwiftUI
//
//  Created by Dmytro on 03.04.2021.
//

import SwiftUI

public enum NavigationItem {
    case serverInfo
    case viewTorrents
    case add
    case settings
}

struct SidebarView: View {
    
    @AppStorage("serverIP") private var savedServerIp = "127.0.0.1"
    @AppStorage("serverPort") private var savedServerPort = "8090"
    
    @EnvironmentObject private var appState: AppState
    @State private var selection: NavigationItem? = .serverInfo {
        didSet {
            print(selection as Any)
        }
    }
    var body: some View {
        NavigationView {
            List(selection: $selection) {
                Section(header: Text("Медиа")) {
                    NavigationLink(destination: ServerInfoView(), tag: NavigationItem.serverInfo, selection: $selection) {
                        HStack(alignment: .center) {
                            if appState.version.isEmpty {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .foregroundColor(Color.red)
                                    .frame(width: 75, height: 75, alignment: .center)
                                Text("Не удалось подключиться к серверу")
                                    .lineLimit(nil)
                            } else if savedServerIp == "127.0.0.1" {
                                Image(systemName: "desktopcomputer")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color.green)
                                    .frame(width: 75, height: 75, alignment: .center)
                                VStack {
                                    Text("Локальный сервер запущен").lineLimit(nil)
                                        .multilineTextAlignment(.center)
                                    Text(appState.version).bold()
                                }
                            } else {
                                Image(systemName: "server.rack")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color.green)
                                    .frame(width: 75, height: 75, alignment: .center)
                                VStack{
                                    Text("Удаленный сервер подключен").lineLimit(nil)
                                        .multilineTextAlignment(.center)
                                    Text(appState.version).bold()
                                }
                            }
                        }
                    }
                    .tag(NavigationItem.serverInfo)
                    NavigationLink(destination: AllTorrentsView(), tag: NavigationItem.viewTorrents, selection: $selection) {
                        Label("Все торренты", systemImage: "list.bullet.rectangle")
                    }
                    .tag(NavigationItem.viewTorrents)
                    NavigationLink(destination: AddTorrentView(), tag: NavigationItem.add, selection: $selection) {
                        Label("Добавить", systemImage: "plus.app")
                    }
                    .tag(NavigationItem.add)
                    NavigationLink(destination: SettingsView(), tag: NavigationItem.settings, selection: $selection) {
                        Label("Настройки", systemImage: "gear")
                    }
                    .tag(NavigationItem.settings)
                }
            }.animation(nil)
            .listStyle(SidebarListStyle())
            .frame(minWidth: 210)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { toggleSidebar() }) {
                        Image(systemName: "sidebar.left")
                            .foregroundColor(Color("Toolbar"))
                    }
                }
            }
            .onAppear() {
                Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (_) in
                    ServerNetworkManager().echo { (version, error) in
                        if error == nil {
                            print(version)
                            DispatchQueue.main.async {
                                appState.version = version ?? ""
                            }
                        } else {
                            DispatchQueue.main.async {
                                appState.version = ""
                            }
                        }
                    }
                }
            }
        }
    }
    func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
