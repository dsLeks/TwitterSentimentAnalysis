import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var insertData = InsertData()
    var validate = Validations()
    
    @IBAction func createAccountPressed(_ sender: Any) {
        
        //validate fields
        let validationError = validateFields(firstname: firstnameTextField, lastname: lastnameTextField, username: usernameTextField, password: passwordTextField)
        
        if(validationError != nil) {
            showError(validationError!)
            return
        }
        
        guard let firstname = firstnameTextField.text else {
            print("firstname invalid")
            return
        }
        
        guard let lastname = lastnameTextField.text else {
            print("lastname invalid")
            return
        }
        
        guard let username = usernameTextField.text else {
            print("username invalid")
            return
        }
        
        guard let password = passwordTextField.text else {
            print("password invalid")
            return
        }
        
        //insertData.updateTwitterUser(username: username)
        
        if insertData.insertIntoAccount(firstName: firstname, lastName: lastname, username: username, password: password) {
            var LoggedInStoryboard = UIStoryboard(name: "LoggedIn", bundle: nil)
            
            var LoggedInEntryVC = LoggedInStoryboard.instantiateViewController(withIdentifier: Constants.Storyboard.signedInVC) as? UITabBarController
            
            
            // Set user defaults
            let defaults = UserDefaults.standard
            defaults.set(1, forKey: "loggedIn")
            defaults.set(username, forKey: "username")
            
            view.window?.rootViewController = LoggedInEntryVC
            view.window?.makeKeyAndVisible()
        } else {
            showError("Account Already Exists!")
        }
        
    }
    
    
    func validateFields(firstname: UITextField, lastname: UITextField, username: UITextField, password: UITextField) -> String? {
        
        if firstname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || username.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        let cleanedPassword = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if validate.checkPassword(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number"
        }
        
        return nil
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        let logo = UIImage(named: "logo3")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        errorLabel.alpha = 0 
    }
    
}
