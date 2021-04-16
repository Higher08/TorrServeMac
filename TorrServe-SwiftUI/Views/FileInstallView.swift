//
//  FileInstallView.swift
//  TorrServe-SwiftUI
//
//  Created by Dmytro on 16.04.2021.
//

import SwiftUI

struct FileInstallView: View {
    
    @State private var showTumb: Double = 0
    @State private var drawRing = 1/99
    @State private var showCircle = 0
    @State private var rotateCheckMark = 30
    @State private var showCheckMark = -65
    @State var error: String = ""
    @State var succesDownload: Bool = false
    @State var select: Bool = false
    @EnvironmentObject private var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if error.isEmpty && !select {
            Button(action: {open()}) {
                Text("Выберите файл")
            }
            .fileImporter(isPresented: $select, allowedContentTypes: [.macho]) { (result) in
                do {
                    let file = try result.get()
                    print(file)
                } catch {
                    self.error.append(error.localizedDescription)
                }
            }
        } else {
            VStack() {
                Text("Установка")
                    .font(.title2)
                    .bold()
                Text(error)
                ZStack {
                    Circle().stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                        .frame(width: 126, height: 126, alignment: .center)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(drawRing))
                        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                        .frame(width: 126, height: 126, alignment: .center)
                        .rotationEffect(.degrees(-90))
                        .foregroundColor(Color(.systemTeal))
                        .animation(!succesDownload ? Animation.easeIn(duration: 1) : nil)
                    
                    
                    Image(systemName: "icloud.and.arrow.down")
                        .font(.system(size: 80))
                        .foregroundColor(Color(.systemGreen))
                    //                    .animation(Animation.easeInOut(duration: 4))
                    Image(systemName: "icloud.and.arrow.down")
                        .font(.system(size: 80))
                        .clipShape(Rectangle().offset(y: CGFloat(showTumb)))
                        .foregroundColor(Color(.systemGray))
                    
                    Circle()
                        .frame(width: 110, height: 110)
                        .foregroundColor(Color(!error.isEmpty ? .systemRed : .systemTeal))
                        .scaleEffect(CGFloat(showCircle))
                        .animation(!succesDownload ? Animation.interpolatingSpring(stiffness: 170, damping: 15) : nil)
                    
                    Image(systemName: "\(!error.isEmpty ? "x" : "check")mark")
                        .font(.system(size: 60))
                        .rotationEffect(.degrees(Double(rotateCheckMark)))
                        .clipShape(Rectangle().offset(x: CGFloat(showCheckMark)))
                        .animation(!succesDownload ? Animation.interpolatingSpring(stiffness: 170, damping: 15) : nil)
                }
            }
            .frame(width: 300, height: 300)
        }
        if succesDownload == true || !error.isEmpty {
            Button("Закрыть") {
                withAnimation {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }.keyboardShortcut(.defaultAction)
        }
    }
    func open() {
        let panel = NSOpenPanel()
        panel.nameFieldLabel = "Выберите файл"
        panel.canCreateDirectories = true
        DispatchQueue.main.async {
            panel.begin() { response in
                if response == NSApplication.ModalResponse.OK, let fileUrl = panel.url {
                    print(fileUrl)
                    select = true
                    install(fileURL: fileUrl)
                }
            }
        }
    }
    func install(fileURL: URL) {
        let appIdentifier = "group.com.torrServe.Mac"
        let fileManager = FileManager.default
        let container = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appIdentifier)
        let newURI = container?.appendingPathComponent("tserverjobUser")
        if FileManager.default.fileExists(atPath: newURI?.path ?? "") {
            do {
                try FileManager.default.removeItem(at: newURI!)
            } catch {
                print(error)
                self.error.append(error.localizedDescription)
                return
            }
        }
        do {
            try FileManager.default.copyItem(at: fileURL, to: newURI!)
        } catch {
            print(error)
            self.error.append(error.localizedDescription)
            return
        }
        let chmod = Process()
        chmod.launchPath = "/bin/zsh"
        chmod.arguments = ["-c", "chmod +x \(newURI?.path.replacingOccurrences(of: " ", with: "\\ ") ?? "")"]
        print(chmod.arguments)
        let chModpipe = Pipe()
        chmod.standardOutput = chModpipe
        chmod.standardError = chModpipe
        chmod.launch()
        self.showTumb = 35
        let chmodData = chModpipe.fileHandleForReading.readDataToEndOfFile()
        let chModoutput: String = NSString(data: chmodData, encoding: String.Encoding.utf8.rawValue)! as String
        if !chModoutput.isEmpty {
            error.append(chModoutput)
            print(chModoutput)
            return
        }
        
        let quarantine = Process()
        quarantine.launchPath = "/bin/sh"
        quarantine.arguments = ["script.sh", newURI!.path]
        quarantine.currentDirectoryPath = Bundle.main.resourcePath!
        print(quarantine.arguments)
        let quarantinePipe = Pipe()
        quarantine.standardOutput = quarantinePipe
        quarantine.standardError = quarantinePipe
        quarantine.launch()
        let quarantineData = quarantinePipe.fileHandleForReading.readDataToEndOfFile()
        let quarantineOutput: String = NSString(data: quarantineData, encoding: String.Encoding.utf8.rawValue)! as String
        if !quarantineOutput.isEmpty {
            error.append(quarantineOutput)
            print(quarantineOutput)
            return
        }
        self.showTumb = 70
        let server = Process()
        server.currentDirectoryPath = Bundle.main.resourcePath ?? "/User/Downloads"
        server.executableURL = newURI
        do {
            try server.run()
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
                self.showTumb = 100
                drawRing = 1
                Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (_) in
                    showCircle = 1
                }
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
                    rotateCheckMark = 0
                    showCheckMark = 0
                    succesDownload = true
                }
            }
        } catch {
            self.error.append(error.localizedDescription)
            return
        }
    }
}

struct FileInstallView_Previews: PreviewProvider {
    static var previews: some View {
        FileInstallView()
    }
}
