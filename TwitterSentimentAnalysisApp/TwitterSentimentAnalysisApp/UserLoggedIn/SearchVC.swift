import UIKit

class SearchVC: UIViewController {

    var model: TwitterSentimentAnalysisModel = TwitterSentimentAnalysisModel()
    
    
    var overlayView: UIView?
    var loadingIndicator = UIActivityIndicatorView(style: .large)
    
    var userToSearch: String = ""
    
    
    @IBOutlet weak var searchTextInput: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .clear
        let logo = UIImage(named: "logo3")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        
        
        // TODO: Connect the TwitterSentinmentModel to whatever is in the input field of SearchVC
        errorLabel.text = ""
    }
    
    @IBAction func getUserAnalsysis(_ sender: UIButton) {
        guard let searchValue = searchTextInput.text, searchValue.count > 0 else {
            print("Must input a username.")
            errorLabel.text = "Please input a Twitter username."
            return
        }
        
        
        
        getUserTweetsSentiment(for: searchValue);
    }
    
    func getUserTweetsSentiment(for userName:String) {
        
        userToSearch = userName
        showLoadingIndicator()
        Task {
            
            do {
                let result = try await model.getTwitterSentimentAnalysis(forUser: userName)
                
                
                performSegue(withIdentifier: "ShowOtherAnalysis", sender: result)
            } catch {
                print(error)
                errorLabel.text = "Something went wrong. Please try again later."
                hideLoadingIndicator()
            }
        }
        
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Make sure sender is not nil
        guard let strongSender = sender else {
            print("No results given")
            errorLabel.text = "No results found. Please try again or with a different username."
            return false
        }

        // Make sure sender is an array of TweetSentiments
        guard let tweetSentiments = strongSender as? [TweetSentiment] else {
            print("Results are not tweet sentiments")
            errorLabel.text = "Something went wrong."
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
        
        
        guard let resultVC = segue.destination as? OtherResultsVC else {
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
}
