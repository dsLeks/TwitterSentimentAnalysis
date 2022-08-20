//
//  Validations.swift
//  TwitterSentimentAnalysisApp
//
//  Created by Alekhya Gandu on 5/11/22.
//

import Foundation

struct Validations {
         
     func checkPassword(_ password: String?) -> Bool {
            
        let passwordTest = NSPredicate(format: "SELF MATCHES %@","^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
            
        return passwordTest.evaluate(with: password)
            
     }
}
