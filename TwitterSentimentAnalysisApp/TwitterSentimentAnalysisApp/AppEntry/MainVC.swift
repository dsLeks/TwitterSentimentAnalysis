//
//  MainVC.swift
//  tapGesture
//
//  Created by Alekhya Gandu on 5/3/22.
//

import UIKit

class MainVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        let logo = UIImage(named: "logo3")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
    }
    
}
