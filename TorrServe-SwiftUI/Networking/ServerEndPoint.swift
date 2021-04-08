
import Foundation


public enum ServerApi {
    case echo
    case list
    case addTorrent(magnet: String, title: String, poster: String)
    case cache(hash: String)
    case drop(hash: String)
    case remove(hash: String)
    case setSettings(sets: String)
    case defSettings
    case getSettings
}

extension ServerApi: EndPointType {
    
    var baseURLConfig : String {
        let ip = UserDefaults.standard.string(forKey: "serverIP")
        let port = UserDefaults.standard.string(forKey: "serverPort")
        return "http://\(ip ?? "127.0.0.1"):\(port ?? "8090")/"
    }
    
    var baseURL: URL {
        print(baseURLConfig)
        guard let url = URL(string: baseURLConfig.replacingOccurrences(of: " ", with: "")) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .echo:
            return "echo"
        case .list:
            return "torrents"
        case .addTorrent:
            return "torrents"
        case .cache:
            return "cache"
        case .remove:
            return "torrents"
        case .drop:
            return "torrents"
        case .setSettings:
            return "settings"
        case .defSettings:
            return "settings"
        case .getSettings:
            return "settings"
        }
    }
    var httpMethod: HTTPMethod {
        switch self {
        case .list:
            return .post
        case .addTorrent:
            return .post
        case .remove:
            return .post
        case .cache:
            return .post
        case .drop:
            return .post
        case .setSettings:
            return .post
        case .defSettings:
            return .post
        case .getSettings:
            return .post
        default:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .echo: return .request
        case .list: return .requestParameters(bodyParameters: ["action": "list"],
                                              bodyEncoding: .jsonEncoding,
                                              urlParameters: nil)
        case .addTorrent(let magnet, let title, let poster): return .requestParameters(
            bodyParameters: ["action": "add",
                             "save_to_db": true,
                             "link": magnet,
                             "title": title,
                             "poster": poster],
            bodyEncoding: .jsonEncoding,
            urlParameters: nil)
        case .cache(let hash): return .requestParameters(bodyParameters: ["action": "get",
                                                                          "hash": hash],
                                                         bodyEncoding: .jsonEncoding,
                                                         urlParameters: nil)
        case .remove(let hash): return .requestParameters(bodyParameters: ["action": "rem",
                                                                           "hash": hash], bodyEncoding: .jsonEncoding, urlParameters: nil)
        case .drop(let hash): return .requestParameters(bodyParameters: ["action": "drop",
                                                                           "hash": hash], bodyEncoding: .jsonEncoding, urlParameters: nil)
        case .setSettings(let sets):
            return .requestParameters(bodyParameters: ["action": "set",
                                                       "sets": sets],
                                      bodyEncoding: .jsonEncoding,
                                      urlParameters: nil)
        case .defSettings:
            return .requestParameters(bodyParameters: ["action": "def"], bodyEncoding: .jsonEncoding, urlParameters: nil)
        case .getSettings:
            return .requestParameters(bodyParameters: ["action": "get"], bodyEncoding: .jsonEncoding, urlParameters: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}

public enum GitApi {
    case releases
}

extension GitApi: EndPointType {
    
    var baseURLConfig : String {
        return "http://api.github.com/"
    }
    
    var baseURL: URL {
        guard let url = URL(string: baseURLConfig) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .releases:
            return "repos/YouROK/TorrServer/releases"
        }
    }
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .releases: return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
