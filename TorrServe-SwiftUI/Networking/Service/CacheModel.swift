//
//  CacheModel.swift
//  TorrServe-SwiftUI
//
//  Created by Dmytro on 07.04.2021.
//

import Foundation

// MARK: - Release
struct CacheModel: Codable {
    let hash: String?
    let capacity: Int?
    let filled: Int?
    let piecesLength: Int?
    let piecesCount: Int?
    let torrent: TorrentCache?
    let pieces: [String: Piece]?
    let readers: [Reader]?

    enum CodingKeys: String, CodingKey {
        case hash = "Hash"
        case capacity = "Capacity"
        case filled = "Filled"
        case piecesLength = "PiecesLength"
        case piecesCount = "PiecesCount"
        case torrent = "Torrent"
        case pieces = "Pieces"
        case readers = "Readers"
    }
}

// MARK: - Piece
struct Piece: Codable {
    let id: Int?
    let length: Int?
    let size: Int?
    let completed: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case length = "Length"
        case size = "Size"
        case completed = "Completed"
    }
}

// MARK: - Reader
struct Reader: Codable {
    let start: Int?
    let end: Int?
    let reader: Int?

    enum CodingKeys: String, CodingKey {
        case start = "Start"
        case end = "End"
        case reader = "Reader"
    }
}

// MARK: - Torrent
struct TorrentCache: Codable {
    let title: String?
    let poster: String?
    let timestamp: Int?
    let name: String?
    let hash: String?
    let stat: Int?
    let statString: String?
    let loadedSize: Int?
    let torrentSize: Int?
    let preloadedBytes: Int?
    let downloadSpeed: Double?
    let uploadSpeed: Double?
    let totalPeers: Int?
    let pendingPeers: Int?
    let activePeers: Int?
    let connectedSeeders: Int?
    let bytesWritten: Int?
    let bytesWrittenData: Int?
    let bytesRead: Int?
    let bytesReadData: Int?
    let bytesReadUsefulData: Int?
    let chunksWritten: Int?
    let chunksRead: Int?
    let chunksReadUseful: Int?
    let chunksReadWasted: Int?
    let piecesDirtiedGood: Int?
    let fileStats: [FileStatCache]?

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case poster = "poster"
        case timestamp = "timestamp"
        case name = "name"
        case hash = "hash"
        case stat = "stat"
        case statString = "stat_string"
        case loadedSize = "loaded_size"
        case torrentSize = "torrent_size"
        case preloadedBytes = "preloaded_bytes"
        case downloadSpeed = "download_speed"
        case uploadSpeed = "upload_speed"
        case totalPeers = "total_peers"
        case pendingPeers = "pending_peers"
        case activePeers = "active_peers"
        case connectedSeeders = "connected_seeders"
        case bytesWritten = "bytes_written"
        case bytesWrittenData = "bytes_written_data"
        case bytesRead = "bytes_read"
        case bytesReadData = "bytes_read_data"
        case bytesReadUsefulData = "bytes_read_useful_data"
        case chunksWritten = "chunks_written"
        case chunksRead = "chunks_read"
        case chunksReadUseful = "chunks_read_useful"
        case chunksReadWasted = "chunks_read_wasted"
        case piecesDirtiedGood = "pieces_dirtied_good"
        case fileStats = "file_stats"
    }
}

// MARK: - FileStat
struct FileStatCache: Codable {
    let id: Int?
    let path: String?
    let length: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case path = "path"
        case length = "length"
    }
}
