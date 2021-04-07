//
//  Arch+Process.swift
//  TorrServe-SwiftUI
//
//  Created by Dmytro on 07.04.2021.
//

import Foundation

extension ProcessInfo {
    // Возвращает архитектуру
    var machineHardwareName: String? {
        var sysinfo = utsname()
        let result = uname(&sysinfo)
        guard result == EXIT_SUCCESS else { return nil }
        let data = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
        guard let identifier = String(bytes: data, encoding: .ascii) else { return nil }
        return identifier.trimmingCharacters(in: .controlCharacters)
    }
}
