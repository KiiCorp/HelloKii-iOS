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

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // define the loaded KiiObject
    private var objectList: [KiiObject] = []

    // define the object count
    // used to easily see object names incrementing
    private var objectCount = 0

    private let bucketName = "myBucket"
    private let objectKey = "myObjectValue"

    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize the view
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // add "+" button to the navigation bar
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addItem")
        navigationItem.rightBarButtonItem = addButton

        // initialize the activity indicator to display on the top of the screen
        self.activityIndicator.layer.zPosition = 1
    }

    override func viewDidAppear(animated: Bool) {
        // show the activity indicator
        activityIndicator.startAnimating()

        // clear all items
        self.objectList.removeAll()

        // create an empty KiiQuery (will retrieve all results, sorted by creation date)
        let allQuery = KiiQuery(clause: nil)
        allQuery.sortByDesc("_created")

        // define the bucket to query
        let bucket = KiiUser.currentUser()!.bucketWithName(bucketName)

        // perform the query
        bucket.executeQuery(allQuery) { (query, bucket, result, nextQuery, error) -> Void in
            // hide the activity indicator(configured "Hides When Stopped" in storyboard)
            self.activityIndicator.stopAnimating()

            // check for an error(successful request if error==nil)
            if error != nil {
                self.showMessage("Query failed", error: error)
                return
            }

            // add the objects to the objectList and display them
            self.objectList.appendContentsOf(result as! [KiiObject])
            self.tableView.reloadData()
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows in the section.
        return objectList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // initialize a cell
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath)
        if cell == nil {
            cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"Cell")
        }

        // fill the field from object array
        let obj = objectList[indexPath.row]
        cell!.textLabel!.text! = obj.getObjectForKey(objectKey) as! String
        cell!.detailTextLabel!.text! = obj.objectURI!
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        // show the alert dialog
        let alert = UIAlertController(title: nil, message: "Would you like to remove this item?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler:  { (action) -> Void in
            // perform the delete action on the tapped object
            self.performDelete(indexPath.row)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))

        presentViewController(alert, animated: true, completion: nil)
    }

    func addItem() {
        // show the activity indicator
        activityIndicator.startAnimating()

        // create an incremented title for the object
        objectCount += 1
        let value = String(format: "MyObject %d", objectCount)

        // get a reference to a KiiBucket
        let bucket = KiiUser.currentUser()!.bucketWithName(bucketName)

        // create a new KiiObject and set a key/value
        let object = bucket.createObject()
        object.setObject(value, forKey: objectKey)

        // save the object asynchronoously
        object.saveWithBlock { (object, error) -> Void in
            // hide the activity indicator(configured "Hides When Stopped" in storyboard)
            self.activityIndicator.stopAnimating()

            // check for an error(successful request if error==nil)
            if error != nil {
                self.showMessage("Save failed", error: error)
                return
            }

            // insert the object into the beginning of the objectList and display them
            self.objectList.insert(object, atIndex: 0)
            self.tableView.reloadData()
        }
    }

    func performDelete(position: Int) {
        // show the activity indicator
        activityIndicator.startAnimating()

        // get the object to delete based on the index of the row that was tapped
        let obj = objectList[position]

        // delete the object synchronously
        obj.deleteWithBlock { (object, error) -> Void in
            // hide the activity indicator(configured "Hides When Stopped" in storyboard)
            self.activityIndicator.stopAnimating()

            // check for an error(successful request if error==nil)
            if error != nil {
                self.showMessage("Delete failed", error: error)
                return
            }

            // remove the object from the list
            self.objectList.removeAtIndex(position)
            self.tableView.reloadData()
        }
    }
}
