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

import Foundation
import UIKit

extension UIViewController {
    func showMessage(message: String, error: NSError?) {
        // format the message
        let alertMessage : String
        if let description = error?.userInfo["description"] as? String {
            alertMessage = message + ": " + description
        } else {
            alertMessage = message
        }

        // show an alert dialog
        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}