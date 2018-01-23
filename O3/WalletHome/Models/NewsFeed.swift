//
//  NewsFeed.swift
//  O3
//
//  Created by Andrei Terentiev on 1/8/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation

public struct FeedData: Codable {
    public struct Feature: Codable {
        var url: String
        enum CodingKeys: String, CodingKey {
            case url
        }

        public init(url: String) {
            self.url = url
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let url: String = try container.decode(String.self, forKey: .url)
            self.init(url: url)
        }
    }

    public struct FeedItem: Codable {
        public struct NewsImage: Codable {
            var title: String
            var url: String

            enum CodingKeys: String, CodingKey {
                case title
                case url
            }

            public init(title: String, url: String) {
                self.title = title
                self.url = url
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let title: String = try container.decode(String.self, forKey: .title)
                let url: String = try container.decode(String.self, forKey: .url)
                self.init(title: title, url: url)
            }
        }

        var title: String
        var description: String
        var link: String
        var published: String
        var source: String
        var images: Array<NewsImage>

        enum CodingKeys: String, CodingKey {
            case title
            case description
            case link
            case published
            case source
            case images
        }

        public init(title: String, description: String, link: String, published: String, source: String, images: Array<NewsImage>) {
            self.title = title
            self.description = description
            self.link = link
            self.published = published
            self.source = source
            self.images = images
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let title: String = try container.decode(String.self, forKey: .title)
            let description: String = try container.decode(String.self, forKey: .description)
            let link: String = try container.decode(String.self, forKey: .link)
            let published: String = try container.decode(String.self, forKey: .published)
            let source: String = try container.decode(String.self, forKey: .source)
            let images: Array<NewsImage> = try container.decode(Array<NewsImage>.self, forKey: .images)
            self.init(title: title, description: description, link: link, published: published, source: source, images: images)

        }
    }

    var features: Array<Feature>
    var items: Array<FeedItem>

    enum CodingKeys: String, CodingKey {
        case features
        case items
    }

    public init(features: Array<Feature>, items: Array<FeedItem>) {
        self.features = features
        self.items = items
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let features: Array<Feature> = try container.decode(Array<Feature>.self, forKey: .features)
        let items: Array<FeedItem> = try container.decode(Array<FeedItem>.self, forKey: .items)
        self.init(features: features, items: items)
    }
}
