import Foundation

// MARK: - ReleaseElement
struct ReleaseElement: Codable {
    let url: String?
    let assetsURL: String?
    let uploadURL: String?
    let htmlURL: String?
    let id: Int?
    let nodeID: String?
    let tagName: String?
    let targetCommitish: String?
    let name: String?
    let draft: Bool?
    let prerelease: Bool?
    let createdAt: String?
    let publishedAt: String?
    let assets: [Asset]?
    let tarballURL: String?
    let zipballURL: String?
    let body: String?

    enum CodingKeys: String, CodingKey {
        case url = "url"
        case assetsURL = "assets_url"
        case uploadURL = "upload_url"
        case htmlURL = "html_url"
        case id = "id"
        case nodeID = "node_id"
        case tagName = "tag_name"
        case targetCommitish = "target_commitish"
        case name = "name"
        case draft = "draft"
        case prerelease = "prerelease"
        case createdAt = "created_at"
        case publishedAt = "published_at"
        case assets = "assets"
        case tarballURL = "tarball_url"
        case zipballURL = "zipball_url"
        case body = "body"
    }
}

// MARK: - Asset
struct Asset: Codable {
    let url: String?
    let id: Int?
    let nodeID: String?
    let name: String?
    let contentType: String?
    let state: String?
    let size: Int?
    let downloadCount: Int?
    let createdAt: String?
    let updatedAt: String?
    let browserDownloadURL: String?

    enum CodingKeys: String, CodingKey {
        case url = "url"
        case id = "id"
        case nodeID = "node_id"
        case name = "name"
        case contentType = "content_type"
        case state = "state"
        case size = "size"
        case downloadCount = "download_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case browserDownloadURL = "browser_download_url"
    }
}
