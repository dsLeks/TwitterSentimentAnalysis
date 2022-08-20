//
//  InsertData.swift
//  TwitterSentimentAnalysisApp
//
//  Created by Alekhya Gandu on 5/11/22.
//

import Foundation
import UIKit
import CoreData

struct InsertData {
    
    //Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items:[Account]?
    
    //getAccountObject
    func getAccount(username: String) -> [Account]? {
        let request = Account.fetchRequest() as NSFetchRequest<Account>
        
        let pred = NSPredicate(format: "userName == %@", username)
        request.predicate = pred
        
        do {
            let result = try context.fetch(request)
            return result;
        }
        catch {
            print("Error in getting Account")
        }
        
        return nil
    }
    
    //Updating the twitterUser
    func updateTwitterUser(username: String, twitterUsername: String) -> Bool{
        guard let result = getAccount(username: username) else {
            return false
        }
        print("Value of Result in InsertData: ")
        if result[0].twitterUsername != twitterUsername {
            result[0].twitterUsername = twitterUsername //insert the twitterUsername
            
            do {
                try self.context.save()
                print("Saved!")
                return true
            }
            catch {
                print("Error in updating data")
                return false
            }
        }
        else {
            print(result[0].twitterUsername)
        }
        
        return false
    }
    
    
    //Checking if the account already exists
    func usernameExists(username: String) -> Bool {
        let request = Account.fetchRequest() as NSFetchRequest<Account>

        //Set up filtering on the request
        let pred = NSPredicate(format: "userName == %@", username)
        request.predicate = pred
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if let resultPassword = data.value(forKey: "userPassword") as? String {
                    if resultPassword != nil {
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
    
    mutating func insertIntoAccount(firstName: String, lastName: String, username: String, password: String) -> Bool{
        
        if usernameExists(username: username) == false {
            //Create the Account object
            let newAccount = Account(context: self.context)
            newAccount.firstName = firstName
            newAccount.lastName = lastName
            newAccount.userPassword = password
            newAccount.userName = username
            
            //Save the Account object
            do {
                try self.context.save()
            }
            catch {
                print("Error in saving the data")
            }
            
//            //re-fetch data to check
//            do {
//                try self.items = context.fetch(Account.fetchRequest())
//                print("The fetched items from account are: ")
//
//                guard let dataItems = self.items else {
//                    return false
//                }
//
//               print(dataItems)
//            }
//            catch {
//                print("Error in fetching Account Data")
//            }
            
            return true
        }
        return false
    }
}
