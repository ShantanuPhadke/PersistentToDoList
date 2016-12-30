//
//  ViewController.swift
//  PersistentToDoList
//
//  Created by Shantanu Phadke on 12/29/16.
//  Copyright © 2016 Shantanu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myTable: UITableView!
    var tasks = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myTable.dataSource = self
        myTable.delegate = self
    }
    
    //Makes sure that the UITableView gets updated immediately when new data is stored in
    //our model
    override func viewWillAppear(animated: Bool) {
        //(1) Get the data from CoreData
        getData()
        //(2) Reload the TableView
        myTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    //function required in order to be able to delete individual tasks that have been completed
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.managedObjectContext
            
            context.deleteObject(tasks[indexPath.row])
            
            do{
                try context.save()
            }catch{
                print("could not save context!")
            }
            getData()
            myTable.reloadData()
            
        }
    }
    
    //Sets the number of rows in the UITableView to the number of task objects in the tasks array
    //that we have defined (this makes sure that we don't take up any extra space that is not needed
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tasks.count
    }
    
    //In this second function we are just setting the content of each row in the UITableView as the
    //name of the task at that index in the tasks array
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        let task = tasks[indexPath.row]
        
        cell.textLabel?.text = task.valueForKey("name") as? String
        return cell
    }
    
    func getData(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest()
        
        let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: context)
        
        fetchRequest.entity = entity
        
        do{
            tasks = try context.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        }catch{
            print("Could not properly fetch!")
        }
    }
}

