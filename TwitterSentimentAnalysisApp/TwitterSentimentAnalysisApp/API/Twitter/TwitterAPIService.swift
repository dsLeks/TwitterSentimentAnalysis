//
//  TwitterAPIService.swift
//  TwitterSentimentAnalysisApp
//
//  Created by Benjamin Kao on 4/13/22.
//

import Foundation

enum TwitterAPIServiceError: Error {
    case InvalidURL
    case UserNotFound
    case Unauthorized
}



struct TwitterAPIService {
    
    let baseURL: String = "https://api.twitter.com/2/"
    
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY")
    let apiSecretKey = Bundle.main.object(forInfoDictionaryKey: "API_SECRET_KEY")
    let bearerToken = Bundle.main.object(forInfoDictionaryKey: "BEARER_TOKEN")
    
    
    //To get the Tweets for the particular username
    func fetchUsersTweets(username: String) async throws -> TwitterResponse { 
        
        
        /// Steps to get a user's tweets using the Twitter API
        ///  1. Get the user's ID:
        ///        * Use the "/2/users/by" endpoint to retrieve the user's ID
        ///        * curl "https://api.twitter.com/2/users/by?username=\(username)"
        ///  2. Get the user's tweets:
        ///        * Use the "/2/users/{id}/tweets" endpoint to retrive the user's tweets
        ///        * curl "https://api.twitter.com/2/users/\(id)/tweets"
        
        
        
        let twitterUser: TwitterUser = try await fetchUserId(username: username)
        
        print(twitterUser)
        
        if(twitterUser.data.isEmpty) {
            throw TwitterAPIServiceError.UserNotFound
        }
        
        
        
        guard let url = URL(string: "\(baseURL)users/\(twitterUser.data[0].id)/tweets?tweet.fields=created_at&max_results=20") else {
            throw TwitterAPIServiceError.InvalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        
        guard let bearerToken = bearerToken else {
            print("Bearer Token not configured. Cannot fetch tweets.")
            throw TwitterAPIServiceError.Unauthorized
        }
        
        urlRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)

        let decoder = JSONDecoder()


        return try decoder.decode(TwitterResponse.self, from: data)
    }
    
    
    //To get the UserID for the given username
    private func fetchUserId(username: String) async throws -> TwitterUser {
        guard let url = URL(string: "\(baseURL)users/by?usernames=\(username)") else {
            throw TwitterAPIServiceError.InvalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        
        guard let bearerToken = bearerToken else {
            throw TwitterAPIServiceError.Unauthorized
        }

        
        urlRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(TwitterUser.self, from: data)
    }
    
    
    
    
}
