//
//  RetrieveData.swift
//  TwitterSentimentAnalysisApp
//
//  Created by Alekhya Gandu on 5/11/22.
//

import Foundation
import UIKit
import CoreData

struct SendDataForCheck {
    
    //Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Account]?
    
    mutating func checkData(username: String, password: String) -> Bool {
        
        let request = Account.fetchRequest() as NSFetchRequest<Account>

        //Set up filtering on the request
        let pred = NSPredicate(format: "userName == %@", username)
        request.predicate = pred
        request.returnsObjectsAsFaults = false
        
        
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if let resultPassword = data.value(forKey: "userPassword") as? String {
                    if resultPassword == password {
                        return true
                    }
                    else {
                        return false
                    }
                }
            }
        }
        catch {
            print("Error in fetching Account Data")
        }

        return false
        
    }
    
}

