// MARK: - TorrentElement
struct TorrentElement: Codable, Hashable, Equatable {
    let title: String?
    let poster: String?
    let timestamp: Int?
    let name: String?
    let hash: String?
    let stat: Int?
    let statString: String?
    let torrentSize: Int?
    let totalPeers: Int?
    let pendingPeers: Int?
    let fileStats: [FileStat]?

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case poster = "poster"
        case timestamp = "timestamp"
        case name = "name"
        case hash = "hash"
        case stat = "stat"
        case statString = "stat_string"
        case torrentSize = "torrent_size"
        case totalPeers = "total_peers"
        case pendingPeers = "pending_peers"
        case fileStats = "file_stats"
    }
}

// MARK: - FileStat
struct FileStat: Codable, Hashable, Equatable {
    let id: Int?
    let path: String?
    let length: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case path = "path"
        case length = "length"
    }
}

typealias Torrent = [TorrentElement]
