//
//  GroceryTableViewController.swift
//  Grocery List
//
//  Created by Chidi Emeh on 6/7/17.
//  Copyright © 2017 Chidi Emeh. All rights reserved.
//

import UIKit
import CoreData

class GroceryTableViewController: UITableViewController {

    var groceries = [NSManagedObject]()
    var managedObjectContext : NSManagedObjectContext?
    var entity : NSEntityDescription?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "Grocery", in: managedObjectContext!)
        
        loadData()
        
    }
    
    //When the "+" button is clickes
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Grocery Item", message: "Please add the items you want to buy", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: nil)
        
        let addAction = UIAlertAction(title: "ADD", style: .default, handler: { [weak self] (action : UIAlertAction) in
            
            let textField = alertController.textFields?.first!
            //self?.groceries.append((textFromTextField?.text)!)
            self?.save(item: (textField?.text!)!)
           
        })
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)

    }
    
    //Loads data from the stack
    func loadData() {
        
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Grocery")
        
        do {
            let results = try managedObjectContext?.fetch(request)
            groceries = results!
            tableView.reloadData()
        }catch {
            fatalError("Error in retrieving Grocery item")
        }
    }
    
    //Saves to Core Data
    func save(item: String){
        
        let managedObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        managedObject.setValue(item, forKey: "item")
        
        do {
        
           try managedObjectContext?.save()
        }catch let error {
            print("Could not save. \(error)")
        }
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groceries.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groceryCell", for: indexPath)

        let grocery = self.groceries[indexPath.row]
        
       cell.textLabel?.text = grocery.value(forKey: "item") as? String
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
