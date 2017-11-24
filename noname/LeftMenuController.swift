//
//  LeftMenuController.swift
//  noname
//
//  Created by sergey.tereshkin on 21/11/2017.
//  Copyright © 2017 sergey.tereshkin. All rights reserved.
//

import UIKit

enum ViewType {
    case ETView
    case ETLabel
    case ETButton
    case ETSegmented
    case ETTextField
    case ETSlider
    case ETSwitch
    case ETTable
    case ETTableCell
    case ETImage
    case ETCollection
    case ETCollectionCell
    case ETTextView
    case ETScrollView
}

struct TView {
    var type: ViewType?
}

protocol LeftMenuDelegate {
    func addSubview(_ class: AnyClass?)
}

class LeftMenuController: UITableViewController {
    
    var delegate: LeftMenuDelegate?
    
    let cellId: String = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = .white
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = "UIView = \(indexPath.row)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        closeLeft()
        if let d = delegate {
            d.addSubview(UIView.self)
        }
    }
    
}
