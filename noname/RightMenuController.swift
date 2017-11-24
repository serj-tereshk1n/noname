//
//  RightMenuController.swift
//  noname
//
//  Created by sergey.tereshkin on 21/11/2017.
//  Copyright © 2017 sergey.tereshkin. All rights reserved.
//

import UIKit

protocol RightMenuDelegate {
    func getSubviews() -> [UIView]
}

class RightMenuController: UITableViewController {
    
    let cellId: String = "cellID"
    
    var delegate: RightMenuDelegate?
    var dataSource: [UIView]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        self.tableView.allowsMultipleSelectionDuringEditing = false;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        if let d = delegate {
            self.dataSource = d.getSubviews()
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let v = dataSource?[indexPath.row] {
            cell.backgroundColor = v.backgroundColor
        }
        
        cell.textLabel?.text = "UIView = \(indexPath.row)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if let v = dataSource?[indexPath.row] {
                v.removeFromSuperview()
                
                self.dataSource = delegate?.getSubviews()
                self.tableView.reloadData()
            }
        }
    }
}
