
import Foundation


public enum ServerApi {
    case echo
    case list
    case addTorrent(magnet: String, title: String, poster: String)
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
            return "stream"
        }
    }
    var httpMethod: HTTPMethod {
        switch self {
        case .list:
            return .post
        case .addTorrent:
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
                             "save_to_db": "true",
                             "link": magnet,
                             "title": title,
                             "poster": poster],
            bodyEncoding: .jsonEncoding,
            urlParameters: nil)
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
