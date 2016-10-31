//
//
// Copyright 2016 Kii Corporation
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
        view.endEditing(true)
    }

    @IBAction func signupButtonPressed(_ sender: UIButton) {
        // show the activity indicator
        activityIndicator.startAnimating()

        // get the username/password combination from the UI
        let username = usernameField.text!
        let password = passwordField.text!

        // create a KiiUser object
        let user = KiiUser(username: username, andPassword: password)

        // register the user asynchronously
        user.performRegistration { (user, error) -> Void in
            // hide the activity indicator(configured "Hides When Stopped" in storyboard)
            self.activityIndicator.stopAnimating()

            // check for an error(successful request if error==nil)
            if error != nil {
                self.showMessage("Sign up failed", error: error as NSError?)
                return
            }

            // go to the main screen
            self.performSegue(withIdentifier: "OpenMainPage", sender: nil)
        }
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        // show the activity indicator
        activityIndicator.startAnimating()

        // get the username/password combination from the UI
        let username = usernameField.text!
        let password = passwordField.text!

        // authenticate the user asynchronously
        KiiUser.authenticate(username, withPassword: password) { (user, error) -> Void in
            // hide the activity indicator(configured "Hides When Stopped" in storyboard)
            self.activityIndicator.stopAnimating()

            // check for an error(successful request if error==nil)
            if error != nil {
                self.showMessage("login failed", error: error as NSError?)
                return
            }

            // go to the main screen
            self.performSegue(withIdentifier: "OpenMainPage", sender: nil)
        }
    }

}

