//
//  TwitterSentimentAnalysisModel.swift
//  TwitterSentimentAnalysisApp
//
//  Created by Benjamin Kao on 4/30/22.
//

import Foundation


struct TweetSentiment {
    var tweet: TwitterResponse.Datum
    var analysis: UserSentiment?
}


class TwitterSentimentAnalysisModel {
    
    let twitterService: TwitterAPIService = TwitterAPIService()
    
    let googleService: GoogleAPIService = GoogleAPIService()
    
    func getTwitterSentimentAnalysis(forUser username: String) async throws -> [TweetSentiment] {
        
        var userTweets: TwitterResponse?;
        do {
            userTweets = try await twitterService.fetchUsersTweets(username: username)

//            print(userTweets);
        } catch {
            throw error
        }
        
        guard let userTweets = userTweets else {
            return []
        }

        guard let data = userTweets.data else {
            return []
        }
        
        var result: [TweetSentiment] = data.map{TweetSentiment(tweet: $0, analysis: nil)}
        
        
        
        
        
        for (index, _) in result.enumerated() {
            do {
                let analysis = try await googleService.fetchUserSentiment(content: result[index].tweet.text)
                
                
                result[index].analysis = analysis
            } catch {
                throw error
            }
        }
        
        
        return result
    }
    
    
}



