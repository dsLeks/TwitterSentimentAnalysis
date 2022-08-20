//
//  TweetSentimentCell.swift
//  TwitterSentimentAnalysisApp
//
//  Created by Benjamin Kao on 5/10/22.
//

import UIKit


class TweetSentimentCell: UITableViewCell {
    
    private var tweetContent: String = ""
    private var tweetDate: Date = Date.now
    
    private var tweetSentimentScore: Double? = nil
    
    
    var TweetContent: String {
        get { return tweetContent }
        set {
            tweetContent = newValue
            updateCell()
        }
    }
    
    var TweetDate: Date {
        get { return tweetDate }
        set {
            tweetDate = newValue
            updateCell()
        }
    }
    
    var TweetSentimentScore: Double? {
        get {return tweetSentimentScore}
        set {
            tweetSentimentScore = newValue
            updateCell()
        }
    }
    
    
    
    
    
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var tweetDateLabel: UILabel!
    @IBOutlet weak var tweetSentimentScoreLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        tweetContent = ""
        tweetDate = Date.now
        tweetSentimentScore = nil
        
        
    }
    
    
    func updateCell() {
        tweetContentLabel.text = tweetContent
        tweetDateLabel.text = tweetDate.formatted()
        
        if let strongTweetSentimentScore = tweetSentimentScore {
            tweetSentimentScoreLabel.text = String(strongTweetSentimentScore)
            
            if strongTweetSentimentScore < -0.1 {
                tweetSentimentScoreLabel.textColor = .red
            } else if strongTweetSentimentScore > 0.1 {
                tweetSentimentScoreLabel.textColor = .green
            } else {
                tweetSentimentScoreLabel.textColor = .gray
            }
        } else {
            tweetSentimentScoreLabel.text = "N/A"
        }
    }
    
    
    
}
