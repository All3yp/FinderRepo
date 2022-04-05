//
//  GitHubRepository.swift
//  Github
//
//  Created by Renato F. dos Santos Jr on 29/03/22.
//

import Foundation
// MARK: Add Data Formatting
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let createAtPrimiteString = try container.decode(String.self, forKey: .createdAt)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat
//        dateFormatter.timeZone = TimeZone.current
//        let date = dateFormatter.date(from: createAtPrimiteString)
//    }

// MARK: - GitHubRepositories
struct GithubRepositories: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    var items: [GithubRepository]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

// MARK: - RepositoryInfo
struct GithubRepository: Codable {
    let id: Int
    let nodeID, name, fullName: String
    let owner: Owner
    let itemPrivate: Bool
    let htmlURL: String
    let itemDescription: String?
    let fork: Bool
    let url: String
    let createdAt, updatedAt, pushedAt: String
    let size: Int
    let language: String
    let forks, openIssues, watchers: Int
    let visibility: String
    let license: License?
    var isFavorite: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case owner
        case itemPrivate = "private"
        case htmlURL = "html_url"
        case itemDescription = "description"
        case fork, url, isFavorite
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
        case size, language, forks
        case openIssues = "open_issues"
        case watchers, visibility, license
    }
}
// MARK: - License
struct License: Codable {
    let key, name: String
    let url: String?
    let htmlURL: String?

    enum CodingKeys: String, CodingKey {
        case key, name, url
        case htmlURL = "html_url"
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String
    let url, receivedEventsURL: String
    let type: String
    let htmlURL: String

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case receivedEventsURL = "received_events_url"
        case type
        case htmlURL = "html_url"
    }
}
