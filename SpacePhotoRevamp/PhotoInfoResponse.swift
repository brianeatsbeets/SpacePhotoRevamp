//
//  PhotoInfoResponse.swift
//  SpacePhotoRevamp
//
//  Created by Aguirre, Brian P. on 10/23/22.
//

// MARK: - Imported libraries

import Foundation

// MARK: - Main struct

struct PhotoInfoResponse: Codable {
    
    // MARK: - Properties
    
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    var mediaType: String
    
    // Specify coding keys for custom API property keys
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
        case mediaType = "media_type"
    }
    
    // MARK: - Initializer
    
    // Initialize from encoded data
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: CodingKeys.title)
        description = try values.decode(String.self, forKey: CodingKeys.description)
        url = try values.decode(URL.self, forKey: CodingKeys.url)
        copyright = try values.decode(String.self, forKey: CodingKeys.copyright)
        mediaType = try values.decode(String.self, forKey: CodingKeys.mediaType)
    }
}
