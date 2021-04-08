//
//  TorrServe_SwiftUIApp.swift
//  TorrServe-SwiftUI
//
//  Created by Dmytro on 12.03.2021.
//

import SwiftUI

@main
struct TorrServe_SwiftUIApp: App {
    @State var window = NSWindow()
    
    var body: some Scene {
        WindowGroup {
            SidebarView()
                .environmentObject(AppState.shared)
                .onAppear() {
                    NotificationCenter.default.addObserver(forName: NSWindow.willCloseNotification, object: nil, queue: .main) { window in
                        print(NSApp.mainWindow, window.object)
                        if window.object as? NSWindow == NSApp.mainWindow {
                            print("close")
                            Shell.shared.kill()
                        }
                    }
                    let appIdentifier = "group.com.torrServe.Mac"
                    let fileManager = FileManager.default
                    let container = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appIdentifier)
                    do {
                        let fileURLs = try fileManager.contentsOfDirectory(at: container!, includingPropertiesForKeys: nil)
                        let url = fileURLs.first(where: {$0.absoluteString.contains("tserverjob")})
                        let server = Process()
                        server.currentDirectoryPath = Bundle.main.resourcePath ?? "/User/Downloads"
                        server.executableURL = url
                        do {
                            try server.run()
                        } catch {
                            print(error)
                            return
                        }
                    } catch {
                        print("Error while enumerating files \(container!.path): \(error.localizedDescription)")
                    }
                }
        }
    }
}
