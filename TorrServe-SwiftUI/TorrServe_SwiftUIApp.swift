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
                }
        }
    }
}
