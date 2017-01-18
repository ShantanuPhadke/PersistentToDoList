//
//  ViewController.swift
//  PersistentToDoList
//
//  Created by Shantanu Phadke on 12/29/16.
//  Copyright © 2016 Shantanu. All rights reserved.
//

import UIKit
import CoreData

/*struct taskCellData{
    let name: String!
    let date: String!
}*/

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myTable: UITableView!
    var tasks = [NSManagedObject]()
    var importantTasks = [NSManagedObject]()
    var unimportantTasks = [NSManagedObject]()
    
    @IBOutlet weak var segments: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myTable.dataSource = self
        myTable.delegate = self
        
        //Required to register the cell as a usable class for the identifier
        self.myTable.registerNib(UINib(nibName: "TaskCell", bundle:nil), forCellReuseIdentifier: "TaskCell")
        
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
        
        switch segments.selectedSegmentIndex{
            case 0:
                return tasks.count
            case 1:
                return importantTasks.count
            default:
                return unimportantTasks.count
            
        }
    }
    
    //In this second function we are just setting the content of each row in the UITableView as the
    //name of the task at that index in the tasks array
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: TaskCell = self.myTable.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath) as! TaskCell
        
        //let task = tasks[indexPath.row]
        
        print("Selected Segment Index \(segments.selectedSegmentIndex)")
        
        
        cell.tester?.textColor = UIColor.blackColor()
        
        //cell.tester?.text = "shantanu" //Just for testing

        
        switch segments.selectedSegmentIndex{
            case 0:
                var cellText = tasks[indexPath.row].valueForKey("name") as? String
                cell.taskName?.text = cellText
                if tasks[indexPath.row].valueForKey("isImportant") as! Bool == true{
                    //cellText = cellText! + " (URGENT)"
                    cell.taskName?.textColor = UIColor(red: CGFloat(1.0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(1.0))
                    //Putting in the Due Date for the just the important/urgent tasks
                    let myDate = tasks[indexPath.row].valueForKey("date")!
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "EEEE MMMM dd, yyyy' at 'h:mm a zz."//"yyyy-MM-dd HH:mm:ss Z"
                    let dateString = dateFormatter.stringFromDate(myDate as! NSDate)
                    cellText = "  \(dateString) (URGENT)"
                    
                    //cell.tester?.textColor = UIColor.greenColor()
                    
                    cell.tester?.text = "\(dateString) (URGENT)"
                    
                }else{
                    cell.tester?.text = " (NORMAL)"
                    //cell.tester?.textColor = UIColor.blueColor()
                }
                //cell.dueDate?.text = cellText
            
            case 1:
                //cell.textLabel?.text = importantTasks[indexPath.row].valueForKey("name") as?String
                cell.taskName?.text = importantTasks[indexPath.row].valueForKey("name") as? String
                let myDate = tasks[indexPath.row].valueForKey("date")!
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "EEEE MMMM dd, yyyy' at 'h:mm a zz."//"yyyy-MM-dd HH:mm:ss Z"
                let dateString = dateFormatter.stringFromDate(myDate as! NSDate)
                //cell.textLabel?.text = (cell.textLabel?.text)! + " \(dateString)"
                cell.tester.text = "\(dateString)"
                //cell.tester.textColor = UIColor.greenColor()

            default:
                cell.taskName?.text = unimportantTasks[indexPath.row].valueForKey("name") as? String
            
        }
        //cell.textLabel?.text = task.valueForKey("name") as? String
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
        
        importantTasks = [NSManagedObject]()
        unimportantTasks = [NSManagedObject]()
        
        for task in tasks{
            if task.valueForKey("isImportant") as! Bool == true{
                importantTasks.append(task)
            }else{
                unimportantTasks.append(task)
            }
        }
        
        
        for impTask in importantTasks{
            print(impTask.valueForKey("name"))
        }
        
        print("")
        
        for unimpTask in unimportantTasks{
            print(unimpTask.valueForKey("name"))
        }
        
    }
    
    
    @IBAction func segmentChanged() {
        print("Selected Segment Index \(segments.selectedSegmentIndex)")
        
        myTable.reloadData()
    }
    
    
    
    
}

