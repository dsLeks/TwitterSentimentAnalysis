//
//  GoogleResponse.swift
//  TwitterSentimentAnalysisApp
//
//  Created by Alekhya Gandu on 4/20/22.
//
import Foundation

struct UserSentiment: Codable {
    let documentSentiment: Sentiment
    let language: String
    let sentences: [Sentence]
}

struct Sentiment: Codable {
    let magnitude, score: Double
}

struct Sentence: Codable {
    let text: Text
    let sentiment: Sentiment
}

struct Text: Codable {
    let content: String
    let beginOffset: Int
}
