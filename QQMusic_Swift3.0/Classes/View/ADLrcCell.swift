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
    
    // 保证lrcLabel是readonly. 这句意思就是让lrcLabel的setter是private
    private(set) var lrcLabel: ADLrcLabel?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLrcLabel()
    }
    
    
    private func setupLrcLabel() {
        let lrcLabel = ADLrcLabel()
        self.contentView.addSubview(lrcLabel)
        lrcLabel.font = UIFont.systemFont(ofSize: 14.0)
        lrcLabel.textColor = UIColor.white
        lrcLabel.textAlignment = NSTextAlignment.center
        lrcLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 注意referView == self.contentView而不是self
        _ = lrcLabel.ad_alignInner(orientation: AD_Align.center, referView: self.contentView, size: nil)
        self.lrcLabel = lrcLabel
        
        self.contentView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func lrcCell(with tableView: UITableView) -> ADLrcCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: id) as? ADLrcCell
        if cell == nil {
            cell = ADLrcCell(style: UITableViewCellStyle.default, reuseIdentifier: id)
            cell!.backgroundColor = UIColor.clear
            
            // 要使用自定义的lrcLabel
//            cell!.textLabel?.textColor = UIColor.white
//            cell!.textLabel?.font = UIFont.systemFont(ofSize: 14)
//            cell!.textLabel?.textAlignment = NSTextAlignment.center
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            
        }
        return cell!
    }
    
    

}
