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

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // Define the object array of KiiObjects.
    fileprivate var objectList: [KiiObject] = []

    // Define the object count to easily see
    // object names incrementing.
    fileprivate var objectCount = 0

    fileprivate let bucketName = "myBucket"
    fileprivate let objectKey = "myObjectValue"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the view.
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Add the "+" button to the navigation bar.
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MainViewController.addItem))
        navigationItem.rightBarButtonItem = addButton

        // Initialize the activity indicator to appear on the top of the screen.
        self.activityIndicator.layer.zPosition = 1
    }

    override func viewDidAppear(_ animated: Bool) {
        // Show an activity indicator.
        activityIndicator.startAnimating()

        // Clear all items.
        self.objectList.removeAll()

        // Create an empty KiiQuery. This query will retrieve all results sorted by the creation date.
        let allQuery = KiiQuery(clause: nil)
        allQuery.sort(byDesc: "_created")

        // Define the bucket to query.
        let bucket = KiiUser.current()!.bucket(withName: bucketName)

        // Perform the query.
        bucket.execute(allQuery) { (query, bucket, result, nextQuery, error) -> Void in
            // Hide the activity indicator by setting "Hides When Stopped" in the storyboard.
            self.activityIndicator.stopAnimating()

            // Check for an error. The request was successfully processed if error==nil.
            if error != nil {
                self.showMessage("Query failed", error: error as NSError?)
                return
            }

            // Add the objects to the object array and refresh the list.
            self.objectList.append(contentsOf: result as! [KiiObject])
            self.tableView.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return objectList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Initialize a cell.
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        if cell == nil {
            cell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"Cell")
        }

        // Fill the cell with data from the object array.
        let obj = objectList[indexPath.row]
        cell!.textLabel!.text! = obj.getForKey(objectKey) as! String
        cell!.detailTextLabel!.text! = obj.objectURI!
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        // Show an alert dialog.
        let alert = UIAlertController(title: nil, message: "Would you like to remove this item?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:  { (action) -> Void in
            // Perform the delete action to the tapped object.
            self.performDelete(indexPath.row)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    func addItem() {
        // Show an activity indicator.
        activityIndicator.startAnimating()

        // Create an incremented title for the object.
        objectCount += 1
        let value = String(format: "MyObject %d", objectCount)

        // Get a reference to the KiiBucket.
        let bucket = KiiUser.current()!.bucket(withName: bucketName)

        // Create a new KiiObject instance and set the key-value pair.
        let object = bucket.createObject()
        object.setObject(value, forKey: objectKey)

        // Save the object asynchronously.
        object.save { (object, error) -> Void in
            // Hide the activity indicator by setting "Hides When Stopped" in the storyboard.
            self.activityIndicator.stopAnimating()

            // Check for an error. The request was successfully processed if error==nil.
            if error != nil {
                self.showMessage("Save failed", error: error as NSError?)
                return
            }

            // Insert the object at the beginning of the object array and refresh the list.
            self.objectList.insert(object, at: 0)
            self.tableView.reloadData()
        }
    }

    func performDelete(_ position: Int) {
        // Show an activity indicator.
        activityIndicator.startAnimating()

        // Get the object to delete with the index number of the tapped row.
        let obj = objectList[position]

        // Delete the object asynchronously.
        obj.delete { (object, error) -> Void in
            // Hide the activity indicator by setting "Hides When Stopped" in the storyboard.
            self.activityIndicator.stopAnimating()

            // Check for an error. The request was successfully processed if error==nil.
            if error != nil {
                self.showMessage("Delete failed", error: error as NSError?)
                return
            }

            // Remove the object from the object array and refresh the list.
            self.objectList.remove(at: position)
            self.tableView.reloadData()
        }
    }
}
