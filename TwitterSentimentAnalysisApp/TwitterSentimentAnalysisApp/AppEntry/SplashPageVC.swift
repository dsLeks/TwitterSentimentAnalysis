import UIKit

class SplashPageVC: UIViewController {

    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var twitterAnalysisLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var getStartedButton: UIButton!
    

    @IBAction func getStarted(_ sender: Any) {
        performSegue(withIdentifier: "gsbuttonClickedSegue", sender: nil)
    }
    
    @IBAction func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            UIView.animate(withDuration: 1, animations: {
                
                UIView.animate(withDuration: 1, animations:{
                    self.welcomeLabel.frame
                    = self.welcomeLabel.frame.offsetBy(dx: 500, dy: 0)
                    
                }, completion: {_ in
                    self.welcomeLabel.removeFromSuperview()
                })
                
                
                UIView.animate(withDuration: 1, animations:{
                    self.titleLabel.frame
                    = self.titleLabel.frame.offsetBy(dx: 500, dy: 0)
                }, completion: { _ in
                    self.titleLabel.removeFromSuperview()
                })
                
            
                UIView.animate(withDuration: 1, animations:{
                    self.tapLabel.frame
                    = self.tapLabel.frame.offsetBy(dx: 500, dy: 0)
                }, completion: { _ in
                    self.tapLabel.removeFromSuperview()
                })
            }, completion: { _ in
                sender.isEnabled = false
                self.pullUp()
            })
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        twitterAnalysisLabel.isHidden = true
        getStartedButton.isHidden = true
        logoImage.isHidden = true
        
    }
    
    func pullUp() {
        let seconds = DispatchTimeInterval.seconds(1)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            self.twitterAnalysisLabel.isHidden = false
            self.getStartedButton.isHidden = false
            self.logoImage.isHidden = false
            
            let defaults = UserDefaults.standard
            
            if defaults.integer(forKey: "loggedIn") == 1 {
                var LoggedInStoryboard = UIStoryboard(name: "LoggedIn", bundle: nil)
                
                var LoggedInEntryVC = LoggedInStoryboard.instantiateViewController(withIdentifier: Constants.Storyboard.signedInVC) as? UITabBarController
                
                self.view.window?.rootViewController = LoggedInEntryVC
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}

