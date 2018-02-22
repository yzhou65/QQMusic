//
//  ADLrcCell.swift
//  QQMusic_Swift3.0
//
//  Created by Yue Zhou on 2/21/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

private let id = "cell"

class ADLrcCell: UITableViewCell {
    
    class func lrcCell(with tableView: UITableView) -> ADLrcCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: id) as? ADLrcCell
        if cell == nil {
            cell = ADLrcCell(style: UITableViewCellStyle.default, reuseIdentifier: id)
            cell!.backgroundColor = UIColor.clear
            cell!.textLabel?.textColor = UIColor.white
            cell!.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell!.textLabel?.textAlignment = NSTextAlignment.center
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
        }
        return cell!
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
