import UIKit


// TODO: Connect Core Data API to check if user has already inserted Twitter username once, then should ignore UserAnalysisVC and go directly into UserResultsVC
// TODO: Connect Core Data API to update user account object when user first inserts Twitter username
// TODO: Make Magic Happen:
//      - Notification Center: Move all window/view logic into AppDelegate
//      - Dark Mode
//      - Make modal look even prettier/more dynamic

class UserAnalysisVC: UIViewController {

    
    var coreDataModel: InsertData = InsertData()
    var model: TwitterSentimentAnalysisModel = TwitterSentimentAnalysisModel()
    
    
    var overlayView: UIView?
    var loadingIndicator = UIActivityIndicatorView(style: .large)
    
    var userToSearch: String = ""
    
    var accountUsername: String? = nil
    
    @IBOutlet weak var usernameInput: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func getUserAnalysis(_ sender: UIButton) {
        
        guard let searchValue = usernameInput.text, searchValue.count > 0 else {
            print("Must input a username.")
            errorLabel.text = "Please input your Twitter username."
            return
        }
        
        guard let accountUsername = accountUsername else {
            print("Account Username was not set")
            return
        }

        
        getUserTweetsSentiment(for: searchValue, accountUser: accountUsername, true);
    }
    
    func getUserTweetsSentiment(for twitterUsername:String, accountUser username: String, _ shouldUpdateAccount: Bool) {
        
        userToSearch = twitterUsername
        showLoadingIndicator()
        Task {
            
            do {
            let result = try await model.getTwitterSentimentAnalysis(forUser: twitterUsername)
            
                // Should only update account
                if shouldUpdateAccount {
                    let updated = coreDataModel.updateTwitterUser(username: username, twitterUsername: twitterUsername)
                    
                    
                    if !updated {
                        errorLabel.text = "Something went wrong. Please try again."
                        hideLoadingIndicator()
                        return
                    }
                }
            
                
                
            performSegue(withIdentifier: "ShowUserAnalysis", sender: result)
            } catch {
                print(error)
                errorLabel.text = "Something went wrong. Please try again."
                hideLoadingIndicator()
            }
        }
        
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Make sure sender is not nil
        guard let strongSender = sender else {
            print("No results given")
            errorLabel.text = "No results found. Please try again or with a different username."
            hideLoadingIndicator()
            return false
        }

        // Make sure sender is an array of TweetSentiments
        guard let tweetSentiments = strongSender as? [TweetSentiment] else {
            print("Results are not tweet sentiments")
            errorLabel.text = "Something went wrong."
            hideLoadingIndicator()
            return false
        }
        
        if tweetSentiments.count <= 0 {
            print("No tweets found")
            errorLabel.text = "Could not find any of @\(userToSearch)'s tweets. Please try a different user."
            hideLoadingIndicator()
            return false
        }
        
        
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        hideLoadingIndicator()
        
        // Make sure sender is not nil
        guard let strongSender = sender else {
            print("No results given")
            errorLabel.text = "No results found. Please try again or with a different username."
            return
        }

        // Make sure sender is an array of TweetSentiments
        guard let tweetSentiments = strongSender as? [TweetSentiment] else {
            print("Results are not tweet sentiments")
            errorLabel.text = "Something went wrong."
            return
        }
        
        guard let resultVC = segue.destination as? UserResultsVC else {
            print("Segue Destination is not the correct page.")
            return
        }
        
        resultVC.results = tweetSentiments
        resultVC.userName = userToSearch
    }
    
    
    func showLoadingIndicator() {
        // Make sure overlay covers entire screen
        overlayView = UIView(frame: view.bounds)
        
        guard let strongOverlayView = overlayView else {
            print("Could not show loading indicator overlay")
            return
        }
        
        // Give overlay a standard grey tint over the background
        overlayView?.backgroundColor = .black
        overlayView?.alpha = 0.6
        
        
        // Setup the loading indicator
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        loadingIndicator.center = overlayView?.center ?? view.center
        
        
        // Add the loading indicator to the overlay
        // So that the loading indicator is on top of the overlay
        overlayView?.addSubview(loadingIndicator)
        
        // Make sure the loading indicator starts the animation
        loadingIndicator.startAnimating()
        
        
        // Add the entire overlay with the loading indicator to the view
        view.addSubview(strongOverlayView)
    }
    
    func hideLoadingIndicator() {
        
        loadingIndicator.stopAnimating()
        overlayView?.removeFromSuperview()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = .clear
        
        errorLabel.text = ""
        
        // Check if user defaults username exists
        let defaults = UserDefaults.standard
        
        let username = defaults.string(forKey: "username")
        
        guard let strongUsername = username else {
            print("Username wasn't set in UserDefaults")
            return;
        }
        
        
        
        accountUsername = username
        
        let data = coreDataModel.getAccount(username: strongUsername)
        
        let account = data?[0]
        
        guard let strongAccount = account else {
            print("Account Data wasn't saved in CoreData")
            return
        }
        
        let twitterUsername = strongAccount.twitterUsername
        
        
        if let strongTwitterUsername = twitterUsername {
            
            // User has already entered the twitter username once
            // Segue to UserResultsVC
            usernameInput.text = strongTwitterUsername
            
            getUserTweetsSentiment(for: strongTwitterUsername, accountUser: strongUsername, false)
            
        
        
        } else {
        
            // User hasn't entered their twitter username before
        
            navigationController?.navigationBar.isTranslucent = false
            let logo = UIImage(named: "logo3")
            let imageView = UIImageView(image: logo)
            self.navigationItem.titleView = imageView
            
        }
    }
    
}
