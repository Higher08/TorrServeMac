//
//  BTsets.swift
//  TorrServe-SwiftUI
//
//  Created by Dmytro on 07.04.2021.
//

import Foundation

public struct BTSets: Codable {
    // Cache
    var CacheSize: Int = 0 // in byte, def 200 mb
    var PreloadBuffer: Bool = false
    var ReaderReadAHead: Int = 0 // in percent, 5%-100%, [...S__X__E...] [S-E] not clean

    // Torrent
    var ForceEncrypt: Bool = false
    var RetrackersMode: Int = 0 // 0 - don`t add, 1 - add retrackers (def), 2 - remove retrackers 3 - replace retrackers
    var TorrentDisconnectTimeout: Int = 0 // in seconds
    var EnableDebug: Bool = false // print logs

    // BT Config
    var EnableIPv6: Bool = false
    var DisableTCP: Bool = false
    var DisableUTP: Bool = false
    var DisableUPNP: Bool = false
    var DisableDHT: Bool = false
    var DisablePEX: Bool = false
    var DisableUpload: Bool = false
    var DownloadRateLimit: Int = 0// in kb, 0 - inf
    var UploadRateLimit: Int = 0// in kb, 0 - inf
    var ConnectionsLimit: Int = 0
    var DhtConnectionLimit: Int = 0// 0 - inf
    var PeersListenPort: Int = 0
    var Strategy: Int = 0 // 0 - RequestStrategyDuplicateRequestTimeout, 1 - RequestStrategyFuzzing, 2 - RequestStrategyFastest
}
