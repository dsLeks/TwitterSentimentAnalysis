import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    let validate = Validations()
    var sendData = SendDataForCheck()
    let insertData = InsertData()
    
    
    @IBAction func signInPressed(_ sender: Any) {
        
        //validate fields
        let validationError = validateFields( username: usernameTextField, password: passwordTextField)
        
        if(validationError != nil) {
            showError(validationError!)
            return
        }
        
        guard let username = usernameTextField.text else {
            return
        }
        
        guard let password = passwordTextField.text else {
            return
        }
        
        if !sendData.checkData(username: username, password: password) {
            showError("Password or Username is Incorrect!")
            return 
        }
        
        
        var LoggedInStoryboard = UIStoryboard(name: "LoggedIn", bundle: nil)
        
        var LoggedInEntryVC = LoggedInStoryboard.instantiateViewController(withIdentifier: Constants.Storyboard.signedInVC) as? UITabBarController
        
        
        let defaults = UserDefaults.standard
        defaults.set(1, forKey: "loggedIn")
        defaults.set(username, forKey: "username")
        
        view.window?.rootViewController = LoggedInEntryVC
        view.window?.makeKeyAndVisible()
        
        
    }
    
    
    func validateFields(username: UITextField, password: UITextField) -> String? {
        
        if username.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
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
