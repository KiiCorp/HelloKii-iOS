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
#import "MainViewController.h"
#import "UIViewController+Alert.h"

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

// Define the object array of KiiObjects.
@property NSMutableArray *objectList;

// Define the object count to easily see
// object names incrementing.
@property int objectCount;
@end

@implementation MainViewController
NSString * const BUCKET_NAME = @"myBucket";
NSString * const OBJECT_KEY = @"myObjectValue";

- (void)viewDidLoad {
    [super viewDidLoad];

    // Initialize the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    // Initialize the object array.
    self.objectList = [NSMutableArray array];
    self.objectCount = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Add the "+" button to the navigation bar.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addItem:)];
    self.navigationItem.rightBarButtonItem = addButton;

    // Initialize the activity indicator to appear on the top of the screen.
    self.activityIndicator.layer.zPosition = 1;
}

- (void)viewDidAppear:(BOOL)animated {
    // Show an activity indicator.
    [self.activityIndicator startAnimating];
    
    // Clear all items.
    [self.objectList removeAllObjects];

    // Create an empty KiiQuery. This query will retrieve all results sorted by the creation date.
    KiiQuery *allQuery = [KiiQuery queryWithClause:nil];
    [allQuery sortByDesc:@"_created"];

    // Define the bucket to query.
    KiiBucket *bucket = [[KiiUser currentUser] bucketWithName:BUCKET_NAME];

    // Perform the query.
    [bucket executeQuery:allQuery withBlock:^(KiiQuery *query, KiiBucket *bucket, NSArray *result, KiiQuery *nextQuery, NSError *error) {
        // Hide the activity indicator by setting "Hides When Stopped" in the storyboard.
        [self.activityIndicator stopAnimating];

        // Check for an error. The request was successfully processed if error==nil.
        if (error != nil) {
            [self showMessage:@"Query failed" error:error];
            return;
        }

        // Add the objects to the object array and refresh the list.
        [self.objectList addObjectsFromArray:result];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _objectList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Initialize a cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }

    // Fill the cell with data from the object array.
    KiiObject *obj = _objectList[indexPath.row];
    cell.textLabel.text = [obj getObjectForKey:OBJECT_KEY];
    cell.detailTextLabel.text = obj.objectURI;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Show an alert dialog.
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"Would you like to remove this item?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"No"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
        // Perform the delete action to the tapped object.
        [self performDelete:indexPath.row];
    }]];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

#pragma mark - Data operation

- (void)addItem:(id)sender
{
    // Show an activity indicator.
    [self.activityIndicator startAnimating];

    // Create an incremented title for the object.
    NSString *value = [NSString stringWithFormat:@"MyObject %d", ++_objectCount];

    // Get a reference to the KiiBucket.
    KiiBucket *bucket = [[KiiUser currentUser] bucketWithName:BUCKET_NAME];
    
    // Create a new KiiObject instance and set the key-value pair.
    KiiObject *object = [bucket createObject];
    [object setObject:value forKey:OBJECT_KEY];

    // Save the object asynchronously.
    [object saveWithBlock:^(KiiObject *object, NSError *error) {
        // Hide the activity indicator by setting "Hides When Stopped" in the storyboard.
        [self.activityIndicator stopAnimating];

        // Check for an error. The request was successfully processed if error==nil.
        if (error != nil) {
            [self showMessage:@"Save failed" error:error];
            return;
        }

        // Insert the object at the beginning of the object array and refresh the list.
        [self.objectList insertObject:object atIndex:0];
        [self.tableView reloadData];
    }];
}

- (void)performDelete:(long) position {
    // Show an activity indicator.
    [self.activityIndicator startAnimating];

    // Get the object to delete with the index number of the tapped row.
    KiiObject *obj = _objectList[position];

    // Delete the object asynchronously.
    [obj deleteWithBlock:^(KiiObject *object, NSError *error) {
        // Hide the activity indicator by setting "Hides When Stopped" in the storyboard.
        [self.activityIndicator stopAnimating];

        // Check for an error. The request was successfully processed if error==nil.
        if (error != nil) {
            [self showMessage:@"Delete failed" error:error];
            return;
        }

        // Remove the object from the object array and refresh the list.
        [self.objectList removeObject:obj];
        [self.tableView reloadData];
    }];
}

@end
