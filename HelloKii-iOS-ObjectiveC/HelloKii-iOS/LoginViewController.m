//
//
// Copyright 2015 Kii Corporation
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

#import <KiiSDK/Kii.h>
#import "LoginViewController.h"
#import "UIViewController+Alert.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)signupButtonPressed:(id)sender;
- (IBAction)onTap:(id)sender;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onTap:(id)sender {
    // close the keyboard when the view is tapped
    [self.view endEditing:YES];
}

- (IBAction)signupButtonPressed:(id)sender {
    // show the activity indicator
    [self.activityIndicator startAnimating];
    
    // get the username/password combination from the UI
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    // create a KiiUser object
    KiiUser *user = [KiiUser userWithUsername:username
                                  andPassword:password];
    // register the user asynchronously
    [user performRegistrationWithBlock:^(KiiUser *user, NSError *error) {
        // hide the activity indicator(configured "Hides When Stopped" in storyboard)
        [self.activityIndicator stopAnimating];
        
        // check for an error(successful request if error==nil)
        if (error != nil) {
            [self showMessage:@"Sign up failed" error:error];
            return;
        }
        
        // go to the main screen
        [self performSegueWithIdentifier:@"OpenMainPage" sender:nil];
    }];
}

- (IBAction)loginButtonPressed:(id)sender {
    // show the activity indicator
    [self.activityIndicator startAnimating];

    // get the username/password combination from the UI
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;

    // authenticate the user asynchronously
    [KiiUser authenticate:username
             withPassword:password
                 andBlock:^(KiiUser *user, NSError *error) {
        // hide the activity indicator(configured "Hides When Stopped" in storyboard)
        [self.activityIndicator stopAnimating];

        // check for an error(successful request if error==nil)
        if (error != nil) {
            [self showMessage:@"Login failed" error:error];
            return;
        }

        // go to the main screen
        [self performSegueWithIdentifier:@"OpenMainPage" sender:nil];
    }];
}

@end
