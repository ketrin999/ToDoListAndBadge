//
//  TableViewController.swift
//  ToDoList
//
//  Created by Ekaterina Yashunina on 19.11.2023.
//

import UIKit

class TableViewController: UITableViewController {

    @IBAction func pushEdit(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.reloadData()
        }
    }
    

    @IBAction func pushNew(_ sender: Any) {
        let alertController = UIAlertController(title: "Добавить новую запись", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Новая заметка"
        }

        let actionCreate = UIAlertAction(title: "Create", style: .cancel) { alert in
            let newItem = alertController.textFields![0].text
            if newItem != "" {
                addItem(nameItem: newItem!)
                self.tableView.reloadData()
            }
        }

        let actionCancel = UIAlertAction(title: "Cancel", style: .default)

        alertController.addAction(actionCreate)
        alertController.addAction(actionCancel)

        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.systemGroupedBackground

    }


    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return ToDoItems.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let currentItem = ToDoItems[indexPath.row]
        cell.textLabel?.text = currentItem["Name"] as? String

        if (currentItem["isCompleted"] as? Bool) == true {
            cell.imageView?.image = UIImage(systemName: "checkmark.seal")
        } else {
            cell.imageView?.image = UIImage(systemName: "seal")
        }

        if tableView.isEditing {
            cell.textLabel?.alpha = 0.4
            cell.imageView?.alpha = 0.4
        } else {
            cell.textLabel?.alpha = 1
            cell.imageView?.alpha = 1
        }

        return cell
    }


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        return true
    }



    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {

        }    
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if changeState(at: indexPath.row) {
            tableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(systemName: "checkmark.seal")
        } else {
            tableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(systemName: "seal")
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        moveItem(fromIndex: fromIndexPath.row, toIndex: to.row)
        tableView.reloadData()
    }

}
