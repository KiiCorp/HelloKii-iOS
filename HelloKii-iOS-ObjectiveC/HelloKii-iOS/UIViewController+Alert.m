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

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)

- (void)showMessage:(NSString*)message error:(NSError*)error {
    // format the message
    NSString *alertMessage;
    if (error != nil && error.userInfo[@"description"] != nil) {
        alertMessage = [[message stringByAppendingString:@": "] stringByAppendingString:error.userInfo[@"description"]];
    } else {
        alertMessage = message;
    }
    
    // show an alert dialog
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

@end
