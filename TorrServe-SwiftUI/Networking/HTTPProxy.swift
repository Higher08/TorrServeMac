//
//  HTTPProxy.swift
//  Proxy-Table-SwiftUI
//
//  Created by User on 07.03.2021.
//

import Foundation

struct HTTPProxy: Equatable, Hashable {
    let ip: String?
    let port: String?
    let country: String?
    let id: Int?
}

struct IpAdressModal: Equatable, Hashable {
    let addres: String?
    let status: requestStatus?
    let delay: Double?
    let id: Int?
}

enum requestStatus: Equatable, Hashable, CaseIterable {
    static var allCases: [requestStatus] {
            return [.unreachable, .reachable, .error]
        }
    case unreachable
    case reachable
    case error
}
