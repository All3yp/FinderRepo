//
//  GithubUser.swift
//  Github
//
//  Created by Idwall Go Dev 014 on 01/04/22.
//

import Foundation

// MARK: - GithubUser
struct GithubUser: Codable {
	let login: String?
	let id: Int?
	let nodeID: String?
	let avatarURL: String?
	let gravatarID: String?
	let url: String?
	let htmlURL: String?
	let followersURL: String?
	let followingURL: String?
	let gistsURL: String?
	let starredURL: String?
	let subscriptionsURL: String?
	let organizationsURL: String?
	let reposURL: String?
	let eventsURL: String?
	let receivedEventsURL: String?
	let type: String?
	let siteAdmin: Bool?
	let name: String?
	let company: String?
	let blog: String?
	let location: String?
	let email: String?
	let hireable: Bool?
	let bio: String?
	let twitterUsername: String?
	let publicRepos: Int?
	let publicGists: Int?
	let followers: Int?
	let following: Int?
	let createdAt: String?
	let updatedAt: String?

	enum CodingKeys: String, CodingKey {
		case login = "login"
		case id = "id"
		case nodeID = "node_id"
		case avatarURL = "avatar_url"
		case gravatarID = "gravatar_id"
		case url = "url"
		case htmlURL = "html_url"
		case followersURL = "followers_url"
		case followingURL = "following_url"
		case gistsURL = "gists_url"
		case starredURL = "starred_url"
		case subscriptionsURL = "subscriptions_url"
		case organizationsURL = "organizations_url"
		case reposURL = "repos_url"
		case eventsURL = "events_url"
		case receivedEventsURL = "received_events_url"
		case type = "type"
		case siteAdmin = "site_admin"
		case name = "name"
		case company = "company"
		case blog = "blog"
		case location = "location"
		case email = "email"
		case hireable = "hireable"
		case bio = "bio"
		case twitterUsername = "twitter_username"
		case publicRepos = "public_repos"
		case publicGists = "public_gists"
		case followers = "followers"
		case following = "following"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
	}
}
