//
//  FeatureFeed.swift
//  O3
//
//  Created by Andrei Terentiev on 3/19/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation

/*
 category": "featured",
 "title": "SPOTCOIN PUBLIC SALE",
 "subtitle": "SpotCoin delivers high volume fiat to cryptocurrency transaction services.",
 "imageURL": "https://cdn.o3.network/featured/this_image_is_16x9.jpg",
 "createdAt": "1521100225",
 "index": 0,
 "actionTitle": "Whitepaper",
 "actionURL": "https://www.spotcoin.com/?ref=o3.network"
 
 
 
 */

public struct FeatureFeed: Codable {
    var features: [Item]

    enum CodingKeys: String, CodingKey {
        case features
    }

    public init(features: [Item]) {
        self.features = features
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let features: [Item] = try container.decode([Item].self, forKey: .features)
        self.init(features: features)
    }

    public struct Item: Codable {
        var category: String
        var title: String
        var subtitle: String
        var imageURL: String
        var createdAt: Int
        var index: Int
        var actionTitle: String
        var actionURL: String

        enum CodingKeys: String, CodingKey {
            case category
            case title
            case subtitle
            case imageURL
            case createdAt
            case index
            case actionTitle
            case actionURL
        }

        public init(category: String, title: String, subtitle: String, imageURL: String, createdAt: Int,
                    index: Int, actionTitle: String, actionURL: String) {
            self.category = category
            self.title = title
            self.subtitle = subtitle
            self.imageURL = imageURL
            self.createdAt = createdAt
            self.index = index
            self.actionTitle = actionTitle
            self.actionURL = actionURL
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let category: String = try container.decode(String.self, forKey: .category)
            let title: String = try container.decode(String.self, forKey: .title)
            let subtitle: String = try container.decode(String.self, forKey: .subtitle)
            let imageURL: String = try container.decode(String.self, forKey: .imageURL)
            let createdAt: Int = try container.decode(Int.self, forKey: .createdAt)
            let index: Int = try container.decode(Int.self, forKey: .index)
            let actionTitle: String = try container.decode(String.self, forKey: .actionTitle)
            let actionURL: String = try container.decode(String.self, forKey: .actionURL)
            self.init(category: category, title: title, subtitle: title, imageURL: imageURL, createdAt: createdAt, index: index, actionTitle: actionTitle, actionURL: actionURL)
        }
    }
}
