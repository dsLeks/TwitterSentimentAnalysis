//
//  HomeVC.swift
//  TwitterSentimentAnalysisApp
//
//  Created by Alekhya Gandu on 5/6/22.
//

import UIKit

class HomeVC: UIViewController {
    
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        var MainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        var MainVC = MainStoryboard.instantiateViewController(withIdentifier: Constants.Storyboard.mainVC) as? UIViewController
        
        view.window?.rootViewController = MainVC
        view.window?.makeKeyAndVisible()
        
        let defaults = UserDefaults.standard
        defaults.set(-1, forKey: "loggedIn")
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
