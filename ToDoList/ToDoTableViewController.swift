//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Ulugbek Kahramonov on 7/11/24.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate, UISearchBarDelegate {


    
    var toDos = [ToDo]()
    var filteredToDos = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedToDos = ToDo.loadToDos() {
            toDos = savedToDos
            filteredToDos = toDos
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            tapGesture.cancelsTouchesInView = false // Allow UITableView to receive touch events as well
            tableView.addGestureRecognizer(tapGesture)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredToDos.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        
        cell.delegate = self

        let toDo = filteredToDos[indexPath.row]
        cell.titleLabel?.text = toDo.title
        cell.dueDateLabel?.text = toDo.dueDate.formatted()
        cell.isCompleteButton.isSelected = toDo.isComplete

        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDos.remove(at: indexPath.row)
            filteredToDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(toDos: toDos)
        }
    }


    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! ToDoDetailTableViewController
        
        if let toDo = sourceViewController.toDo {
            if let indexOfExistingToDo = toDos.firstIndex(of: toDo) {
                toDos[indexOfExistingToDo] = toDo
                filteredToDos[indexOfExistingToDo] = toDo
                tableView.reloadRows(at: [IndexPath(row: indexOfExistingToDo, section: 0)], with: .automatic)
            } else {
                let newIndexPath = IndexPath(row: toDos.count, section: 0)
                toDos.append(toDo)
                filteredToDos.append(toDo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        ToDo.saveToDos(toDos: toDos)
    }
    
    @IBSegueAction func editToDo(_ coder: NSCoder, sender: Any?) -> ToDoDetailTableViewController? {
            let detailController = ToDoDetailTableViewController(coder: coder)
            
            guard let cell = sender as? UITableViewCell,
                  let indexPath = tableView.indexPath(for: cell) else {
                return detailController
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            detailController?.toDo = toDos[indexPath.row]
            
            return detailController
            
    }
    
 
    @IBSegueAction func showToDo(_ coder: NSCoder, sender: Any?) -> ToDoReadTableViewController? {
        let detailController = ToDoReadTableViewController(coder: coder)
        
        guard let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return detailController
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        detailController?.toDo = toDos[indexPath.row]
        
        return detailController
    }
    
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var toDo = filteredToDos[indexPath.row]
            toDo.isComplete.toggle()
            filteredToDos[indexPath.row] = toDo
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        ToDo.saveToDos(toDos: toDos)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredToDos = []
        if searchText == "" {
            filteredToDos = toDos
        }
        
        for toDo in toDos {
            if toDo.title.uppercased().contains(searchText.uppercased()) {
                filteredToDos.append(toDo)
            }
        }
        tableView.reloadData()
    }
    
    @objc func handleTap() {
        view.endEditing(true) // This will dismiss the keyboard for all text fields in the view
    }
}
