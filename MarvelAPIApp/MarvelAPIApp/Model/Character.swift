//
//  Character.swift
//  MarvelAPIApp
//
//  Created by Md Shah Alam on 7/19/22.
//

import SwiftUI

// Model...

struct APIResult: Codable {
    var data: APICharacterData
}

struct APICharacterData: Codable {
    var count: Int
    var results: [Character]
}

struct Character: Identifiable, Codable {
    
    var id : Int
    var name : String
    var description: String
    var urls: [[String: String]]
    var thumbnail: [String: String]
}
