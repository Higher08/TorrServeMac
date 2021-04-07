//
//  DeleteServer.swift
//  TorrServe-SwiftUI
//
//  Created by Dmytro on 05.04.2021.
//

import SwiftUI

struct DeleteServerView: View {
    @State var value: Double = 0
    @Environment(\.presentationMode) var presentationMode

    
    
    var body: some View {
        ProgressView("Удаление...", value: value, total: 100)
            .progressViewStyle(LinearProgressViewStyle())
            .frame(width: 100, height: 100)
            .padding()
            .onAppear() {
                delete()
            }
    }
    func delete() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            if value >= 98 {
                timer.invalidate()
                presentationMode.wrappedValue.dismiss()
            }
            value += 2
        }
        let appIdentifier = "group.com.torrServe.Mac"
        let fileManager = FileManager.default
        let container = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appIdentifier)
        if let serverPath = container?.path {
            do {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(serverPath)")
                print("all files: \(fileNames)")
                for fileName in fileNames {
                    if fileName.hasPrefix("server") {
                        let filePathName = "\(serverPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}

struct DeleteServer_Previews: PreviewProvider {
    static var previews: some View {
        DeleteServerView()
    }
}
