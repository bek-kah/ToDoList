//
//  ToDoReadTableViewController.swift
//  ToDoList
//
//  Created by Ulugbek Kahramonov on 7/15/24.
//

import UIKit

class ToDoReadTableViewController: UITableViewController {
    
    var toDo: ToDo?

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var notesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let toDo = toDo {
            navigationItem.title = "To-Do"
            titleLabel.text = toDo.title
            dueDateLabel.text = toDo.dueDate.formatted(.dateTime.month(.defaultDigits).day().year(.twoDigits).hour().minute())
            notesTextView.text = toDo.notes
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBSegueAction func fromReadtoEdit(_ coder: NSCoder, sender: Any?) -> ToDoDetailTableViewController? {
        let detailController = ToDoDetailTableViewController(coder: coder)
        
        detailController?.toDo = toDo
        
        return detailController
        
    }
}
