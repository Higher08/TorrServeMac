//
//  AppState.swift
//  TorrServe-SwiftUI
//
//  Created by Dmytro on 04.04.2021.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    public static let shared = AppState()
    
    private init() {
        
    }
    
    @Published var version: String = ""
    
    @Published var showDownloadLatest: Bool = false
    @Published var deleteView: Bool = false
    @Published var needDownloadView: Bool = false
    @Published var cacheView: Bool = false
    
    @Published var serverProcess: Process? = nil
}

class Shell: ObservableObject {
    public static let shared = Shell()
    
    func kill() {
        let kill = Process()
        kill.launchPath = "/bin/sh"
        kill.arguments = ["close.sh", String(ProcessInfo.processInfo.processIdentifier)]
        kill.currentDirectoryPath = Bundle.main.resourcePath!
        print(kill.arguments)
        let killPipe = Pipe()
        kill.standardOutput = killPipe
        kill.standardError = killPipe
        kill.launch()
        let killData = killPipe.fileHandleForReading.readDataToEndOfFile()
        let killOutput: String = NSString(data: killData, encoding: String.Encoding.utf8.rawValue)! as String
        if !killOutput.isEmpty {
            print(killOutput)
            return
        }
    }
   
}
