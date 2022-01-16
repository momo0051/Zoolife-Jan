//
//  CategoryTableViewCell.swift
//  ZOOLIFE
//
//  Created by Zeeshan Tariq on 20/02/2021.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    static func cellForTableView(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> CategoryTableViewCell {
        let identifier = "CategoryTableViewCell"
        tableView.register(UINib(nibName:"CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CategoryTableViewCell
        return cell
    }
    
}
