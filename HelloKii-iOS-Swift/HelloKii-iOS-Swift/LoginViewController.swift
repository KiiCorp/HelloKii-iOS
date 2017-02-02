//
//
// Copyright 2017 Kii Corporation
// http://kii.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//

import UIKit
import KiiSDK

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        // Close the keyboard when the view is tapped.
        view.endEditing(true)
    }

    @IBAction func signupButtonPressed(_ sender: UIButton) {
        // Show an activity indicator.
        activityIndicator.startAnimating()

        // Get the username and password from the UI.
        let username = usernameField.text!
        let password = passwordField.text!

        // Create a KiiUser object.
        let user = KiiUser(username: username, andPassword: password)

        // Register the user asynchronously.
        user.performRegistration { (user, error) -> Void in
            // Hide the activity indicator by setting "Hides When Stopped" in the storyboard.
            self.activityIndicator.stopAnimating()

            // Check for an error. The request was successfully processed if error==nil.
            if error != nil {
                self.showMessage("Sign up failed", error: error as NSError?)
                return
            }

            // Go to the main screen.
            self.performSegue(withIdentifier: "OpenMainPage", sender: nil)
        }
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        // Show an activity indicator.
        activityIndicator.startAnimating()

        // Get the username and password from the UI.
        let username = usernameField.text!
        let password = passwordField.text!

        // Authenticate the user asynchronously.
        KiiUser.authenticate(username, withPassword: password) { (user, error) -> Void in
            // Hide the activity indicator by setting "Hides When Stopped" in the storyboard.
            self.activityIndicator.stopAnimating()

            // Check for an error. The request was successfully processed if error==nil.
            if error != nil {
                self.showMessage("Login failed", error: error as NSError?)
                return
            }

            // Go to the main screen.
            self.performSegue(withIdentifier: "OpenMainPage", sender: nil)
        }
    }

}

