//
//  TableViewController.swift
//  Todoey
//
//  Created by Alexandre Gibson on 20/08/19.
//  Copyright © 2019 GBSN. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//
//        print(dataFilePath)
        
        loadItems()

        
    }
    
    //MARK - Tableview Datasource Methods
    
    // sets the number of row that there'll be in the tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // creates a cell and populates with the data that will be displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none

        // mesma coisa que a linha de cima
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        // here populates the current cell with the respective data
//        cell.textLabel?.text = itemArray[indexPath.row].title
        
        
        
        return cell
    }
    
    //Mark - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // o mesmo que a linha de cima
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add new Todey Item", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when the user click tha Add Item button on our UIAlert
            
            //grabs the value inputed by the user from the UIAlertAction and appends to the array
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            // updates the tableview
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion:  nil)
        
        
    }
    
    func saveItems() {
        //save the data
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
              itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}

