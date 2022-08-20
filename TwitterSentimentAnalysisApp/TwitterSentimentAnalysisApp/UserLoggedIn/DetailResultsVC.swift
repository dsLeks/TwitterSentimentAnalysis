//
//  DetailResultsVC.swift
//  TwitterSentimentAnalysisApp
//
//  Created by Benjamin Kao on 5/11/22.
//

import UIKit

/// Extension code for UIView to make rounded corners was taken from https://appcoda.com/rounded-corners-uiview/
///
extension UIView {
    func roundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
    }
}



class DetailResultsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var results: [TweetSentiment]? = nil
    var userName: String? = nil
    
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Table View Delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        // Make view and dimView transparent
        dimView.backgroundColor = .clear
        view.backgroundColor = .clear
        
        // Make sure background of tableView is opaque and white
        tableViewBackgroundView.backgroundColor = .white
        tableViewBackgroundView.alpha = 1
        tableView.alpha = 1
        
        tableViewBackgroundView.roundCorners(cornerRadius: 16.0)
    }
    
    // MARK: Table View Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Details"
    }
    

    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tweetSentiment = results?[indexPath.row] else {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TweetSentimentCell") as? TweetSentimentCell else {
            return UITableViewCell()
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

        
        cell.TweetContent = tweetSentiment.tweet.text
        cell.TweetDate = dateFormatter.date(from: tweetSentiment.tweet.createdAt) ?? Date.now
        cell.TweetSentimentScore = tweetSentiment.analysis?.documentSentiment.score
        
        
        
        return cell
    }
    
}
