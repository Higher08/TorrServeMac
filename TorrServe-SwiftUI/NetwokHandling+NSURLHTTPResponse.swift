//
//  NetwokHandling.swift
//  iFilm
//
//  Created by Dmytro on 22.02.2021.
//

import Foundation

extension HTTPURLResponse {
    func handleNetworkResponse() -> Result<String> {
        switch self.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    func fastHandleNetworkResponse() -> Bool {
        switch self.statusCode {
        case 200...299: return true
        default: return false
        }
    }
}
