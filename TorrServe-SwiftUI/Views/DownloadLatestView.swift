//
//  DownloadLatestView.swift
//  TorrServe-SwiftUI
//
//  Created by Dmytro on 04.04.2021.
//

import Foundation
import SwiftUI
import Alamofire

struct DownloadLatestView: View {
    @State private var showTumb: Double = 0
    @State private var drawRing = 1/99
    @State private var showCircle = 0
    @State private var rotateCheckMark = 30
    @State private var showCheckMark = -65
    @State var error: String = ""
    @State var downloadVersion: String = ""
    @State var succesDownload: Bool = false
    @EnvironmentObject private var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        VStack() {
            Text("Скачивание \(downloadVersion)")
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
            .onAppear() {
                download()
            }
            if succesDownload == true || !error.isEmpty {
                Button("Закрыть") {
                    withAnimation {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }.keyboardShortcut(.defaultAction)
            }
        }
        .frame(width: 300, height: 300)
    }
    func download() {
        ServerNetworkManager().getLatestVersion { (release, errorRelease) in
            print(error, release)
            if errorRelease == nil, let releaseAsset = release?.assets {
                downloadVersion = release?.tagName ?? "unknown"
                let arch = ProcessInfo().machineHardwareName
                let asset = releaseAsset.first(where: {$0.name == "TorrServer-darwin-\(arch == "arm64" ? "arm64" : "amd64")"})?.browserDownloadURL
                let url = URL(string: asset ?? "https://github.com/YouROK/TorrServer/releases/download/MatriX.85/TorrServer-darwin-amd64")!
                let destination: DownloadRequest.Destination = { _, _ in
                    let appIdentifier = "group.com.torrServe.Mac"
                    let fileManager = FileManager.default
                    let container = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appIdentifier)
                    let fileURL = container?.appendingPathComponent("tserverjob\(downloadVersion)")
                    
                    return (fileURL!, [.removePreviousFile, .createIntermediateDirectories])
                }
                
                AF.download(
                    url,
                    method: .get,
                    parameters: nil,
                    encoding: JSONEncoding.default,
                    headers: nil,
                    to: destination)
                    .downloadProgress { (progress) in
                        print(progress.fractionCompleted)
                        self.showTumb = progress.fractionCompleted * 100 - 2
                    }
                    .response { (DefaultDownloadResponse) in
                        drawRing = 1
                        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (_) in
                            showCircle = 1
                        }
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
                            rotateCheckMark = 0
                            showCheckMark = 0
                        }
                        if DefaultDownloadResponse.error == nil {
                            let chmod = Process()
                            chmod.launchPath = "/bin/zsh"
                            chmod.arguments = ["-c", "chmod +x \(DefaultDownloadResponse.fileURL!.path.replacingOccurrences(of: " ", with: "\\ "))"]
                            print(chmod.arguments)
                            let chModpipe = Pipe()
                            chmod.standardOutput = chModpipe
                            chmod.standardError = chModpipe
                            chmod.launch()
                            
                            let chmodData = chModpipe.fileHandleForReading.readDataToEndOfFile()
                            let chModoutput: String = NSString(data: chmodData, encoding: String.Encoding.utf8.rawValue)! as String
                            if !chModoutput.isEmpty {
                                error.append(chModoutput)
                                print(chModoutput)
                                return
                            }
                            
                            let quarantine = Process()
                            quarantine.launchPath = "/bin/sh"
                            quarantine.arguments = ["script.sh", DefaultDownloadResponse.fileURL!.path]
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
                            let server = Process()
                            server.currentDirectoryPath = Bundle.main.resourcePath ?? "/User/Downloads"
                            server.executableURL = DefaultDownloadResponse.fileURL
                            do {
                                try server.run()
                                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
                                    succesDownload = true
                                }
                            } catch {
                                self.error.append(error.localizedDescription)
                                return
                            }
                        } else {
                            error.append(DefaultDownloadResponse.error?.localizedDescription ?? "")
                            return
                        }
                    }
            }
        }
    }
}
