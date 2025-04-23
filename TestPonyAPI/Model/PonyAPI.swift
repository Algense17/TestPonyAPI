//
//  PonyAPI.swift
//  TestPonyAPI
//
//  Created by Vasiliy on 08.04.2025.
//

import Foundation

struct Pony: Codable {
    let status: Int
    let data: [Character]
}

struct Character: Codable {
    let id: Int
    let name: String
    let alias: String?
    let url: String
    let sex: String?
    let residence: String?
    let occupation: String?
    let kind: [String]?
    let image: [String]
}


