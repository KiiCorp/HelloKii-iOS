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
    // Close the keyboard when the view is tapped.
    [self.view endEditing:YES];
}

- (IBAction)signupButtonPressed:(id)sender {
    // Show an activity indicator.
    [self.activityIndicator startAnimating];
    
    // Get the username and password from the UI.
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    // Create a KiiUser object.
    KiiUser *user = [KiiUser userWithUsername:username
                                  andPassword:password];
    // Register the user asynchronously.
    [user performRegistrationWithBlock:^(KiiUser *user, NSError *error) {
        // Hide the activity indicator by setting "Hides When Stopped" in the storyboard.
        [self.activityIndicator stopAnimating];
        
        // Check for an error. The request was successfully processed if error==nil.
        if (error != nil) {
            [self showMessage:@"Sign up failed" error:error];
            return;
        }
        
        // Go to the main screen.
        [self performSegueWithIdentifier:@"OpenMainPage" sender:nil];
    }];
}

- (IBAction)loginButtonPressed:(id)sender {
    // Show an activity indicator.
    [self.activityIndicator startAnimating];

    // Get the username and password from the UI.
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;

    // Authenticate the user asynchronously.
    [KiiUser authenticate:username
             withPassword:password
                 andBlock:^(KiiUser *user, NSError *error) {
        // Hide the activity indicator by setting "Hides When Stopped" in the storyboard.
        [self.activityIndicator stopAnimating];

        // Check for an error. The request was successfully processed if error==nil.
        if (error != nil) {
            [self showMessage:@"Login failed" error:error];
            return;
        }

        // Go to the main screen.
        [self performSegueWithIdentifier:@"OpenMainPage" sender:nil];
    }];
}

@end
