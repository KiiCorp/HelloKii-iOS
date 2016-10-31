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

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // define the loaded KiiObject
    fileprivate var objectList: [KiiObject] = []

    // define the object count
    // used to easily see object names incrementing
    fileprivate var objectCount = 0

    fileprivate let bucketName = "myBucket"
    fileprivate let objectKey = "myObjectValue"

    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize the view
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // add "+" button to the navigation bar
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MainViewController.addItem))
        navigationItem.rightBarButtonItem = addButton

        // initialize the activity indicator to display on the top of the screen
        self.activityIndicator.layer.zPosition = 1
    }

    override func viewDidAppear(_ animated: Bool) {
        // show the activity indicator
        activityIndicator.startAnimating()

        // clear all items
        self.objectList.removeAll()

        // create an empty KiiQuery (will retrieve all results, sorted by creation date)
        let allQuery = KiiQuery(clause: nil)
        allQuery.sort(byDesc: "_created")

        // define the bucket to query
        let bucket = KiiUser.current()!.bucket(withName: bucketName)

        // perform the query
        bucket.execute(allQuery) { (query, bucket, result, nextQuery, error) -> Void in
            // hide the activity indicator(configured "Hides When Stopped" in storyboard)
            self.activityIndicator.stopAnimating()

            // check for an error(successful request if error==nil)
            if error != nil {
                self.showMessage("Query failed", error: error as NSError?)
                return
            }

            // add the objects to the objectList and display them
            self.objectList.append(contentsOf: result as! [KiiObject])
            self.tableView.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections.
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows in the section.
        return objectList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // initialize a cell
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        if cell == nil {
            cell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"Cell")
        }

        // fill the field from object array
        let obj = objectList[indexPath.row]
        cell!.textLabel!.text! = obj.getForKey(objectKey) as! String
        cell!.detailTextLabel!.text! = obj.objectURI!
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        // show the alert dialog
        let alert = UIAlertController(title: nil, message: "Would you like to remove this item?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:  { (action) -> Void in
            // perform the delete action on the tapped object
            self.performDelete(indexPath.row)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    func addItem() {
        // show the activity indicator
        activityIndicator.startAnimating()

        // create an incremented title for the object
        objectCount += 1
        let value = String(format: "MyObject %d", objectCount)

        // get a reference to a KiiBucket
        let bucket = KiiUser.current()!.bucket(withName: bucketName)

        // create a new KiiObject and set a key/value
        let object = bucket.createObject()
        object.setObject(value, forKey: objectKey)

        // save the object asynchronoously
        object.save { (object, error) -> Void in
            // hide the activity indicator(configured "Hides When Stopped" in storyboard)
            self.activityIndicator.stopAnimating()

            // check for an error(successful request if error==nil)
            if error != nil {
                self.showMessage("Save failed", error: error as NSError?)
                return
            }

            // insert the object into the beginning of the objectList and display them
            self.objectList.insert(object, at: 0)
            self.tableView.reloadData()
        }
    }

    func performDelete(_ position: Int) {
        // show the activity indicator
        activityIndicator.startAnimating()

        // get the object to delete based on the index of the row that was tapped
        let obj = objectList[position]

        // delete the object synchronously
        obj.delete { (object, error) -> Void in
            // hide the activity indicator(configured "Hides When Stopped" in storyboard)
            self.activityIndicator.stopAnimating()

            // check for an error(successful request if error==nil)
            if error != nil {
                self.showMessage("Delete failed", error: error as NSError?)
                return
            }

            // remove the object from the list
            self.objectList.remove(at: position)
            self.tableView.reloadData()
        }
    }
}
