//
//  AddTaskViewController.swift
//  PersistentToDoList
//
//  Created by Shantanu Phadke on 12/29/16.
//  Copyright © 2016 Shantanu. All rights reserved.
//

import UIKit
import CoreData


class AddTaskViewController: UIViewController {
    

    @IBOutlet weak var newTask: UITextField!
    
    @IBOutlet weak var important: UISwitch!
    
    @IBOutlet weak var taskImportance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clearText() {
        newTask.text = ""
    }

    @IBAction func changeLabel() {
        if important.on{
            taskImportance.text = "URGENT"
        }else{
            taskImportance.text = "NORMAL"
        }
        
    }
    
    @IBAction func addTask() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedContext)
        
        let task = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        task.setValue(newTask.text, forKey: "name")
        if(important.on){
            task.setValue(true, forKey: "isImportant")
        }else{
            task.setValue(false, forKey: "isImportant")
        }
        
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save! + \(error)")
        }
        
        newTask.text = "" //Clear the text after button is clicked!

    }
    

}
