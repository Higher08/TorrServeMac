//
//  VideoCdnNetworkManager.swift
//  iFilm
//
//  Created by Dmytro on 20.02.2021.
//

import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "Invalid parameters"
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

struct ServerNetworkManager {
    let serverequestmanager = Router<ServerApi>()
    let gitrequestmanager = Router<GitApi>()
    func echo(completion: @escaping (_ vesion: String?,_ error: String?)->()){
        serverequestmanager.request(.echo) { data, response, error in
            
            if error != nil {
                completion(nil, "Check server \(String(describing: error))")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = response.handleNetworkResponse()
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    let str = String(decoding: responseData, as: UTF8.self)
                    completion(str, nil)
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    func list(completion: @escaping (_ torrents: Torrent?,_ error: String?)->()){
        serverequestmanager.request(.list) { data, response, error in
            
            if error != nil {
                completion(nil, "Check server \(String(describing: error))")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = response.handleNetworkResponse()
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResp = try JSONDecoder().decode(Torrent.self, from: responseData)
                        completion(apiResp, nil)
                    } catch {
                        completion(nil, error.localizedDescription)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    func addTorrent(magnet: String, title: String, poster: String, completion: @escaping (_ result: Bool,_ error: String?)->()){
        serverequestmanager.request(.addTorrent(magnet: magnet, title: title, poster: poster)) { data, response, error in
            
            if error != nil {
                completion(false, "Check server \(String(describing: error))")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = response.handleNetworkResponse()
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(false, NetworkResponse.noData.rawValue)
                        return
                    }
                    completion(true, nil)
                case .failure(let networkFailureError):
                    completion(false, networkFailureError)
                }
            }
        }
    }
    
    func getLatestVersion(completion: @escaping (_ vesion: ReleaseElement?,_ error: String?)->()) {
        gitrequestmanager.request(.releases) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = response.handleNetworkResponse()
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let responseDecode = try JSONDecoder().decode([ReleaseElement].self, from: responseData)
                        completion(responseDecode.first, nil)
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
}
