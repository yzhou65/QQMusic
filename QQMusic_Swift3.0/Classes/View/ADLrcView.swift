//
//  ADLrcView.swift
//  QQMusic_Swift
//
//  Created by Yue Zhou on 2/20/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADLrcView: UIScrollView, UITableViewDataSource {
    // 当前播放的歌词的index
    var currentIndex: Int = 0

    // 当前播放的时间
    var currentTime: TimeInterval? {
        didSet {
            // 用当前时间和歌词进行匹配
            let count = self.lrcList.count
            for i in 0..<count {
                let curLine = self.lrcList[i]
                let next = i + 1
                if next >= count {
                    return
                }
                let nextLine = self.lrcList[next]
                
                // 用当前时间和i位置以及i+1位置的歌词进行比较
                if (self.currentIndex != i && currentTime! >= curLine.time! && currentTime! < nextLine.time!) {
                    let indexPath = IndexPath(row: i, section: 0)
                    let previousIndexPath = IndexPath(row: self.currentIndex, section: 0)
                    
                    // 要先更新currentIndex,再刷新这一行和前一行, 否则播放过的歌词字体会是20, 未播的变成14
                    self.currentIndex = i
                    
                    // 先刷新两行歌词, 再滚动
                    self.tableView.reloadRows(at: [indexPath, previousIndexPath], with: UITableViewRowAnimation.none)
                    
                    // 滚动到当前句的歌词
                    self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
                    
                    // 设置外面歌词的label的显示歌词
                    self.lrcLabel!.text = curLine.text

                    break
                }
                
                
                // 根据进度, 让正在播放的这句歌词字体逐渐填充自己
                if self.currentIndex == i {
                    let indexPath = IndexPath(row: i, section: 0)
//                    print(self.tableView)
//                    print("\(self.tableView.cellForRow(at: indexPath)), i = \(i)")
                    let cell = self.tableView.cellForRow(at: indexPath) as? ADLrcCell
                    
                    let progress = CGFloat(currentTime! - curLine.time!) / CGFloat(nextLine.time! - curLine.time!)
                    cell?.lrcLabel?.progress = progress
                
                    // 更新外面歌词的label的进度
                    self.lrcLabel?.progress = progress
                }
            }
        }
    }
    
    
    var lrcLabel: ADLrcLabel?
    var duration: CGFloat?
    
    var lrcname: String? {
        didSet {
            // 重置currentIndex. 否则歌曲切换会出问题
            self.currentIndex = 0
            
            // 解析歌词
            self.lrcList = ADLrcTool.lrcTool(with: lrcname!)
            
            // 刷新表格
            self.tableView.reloadData()
        }
    }
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTableView()
    }
    
    
    // 添加歌词的tableView
    private func setupTableView() {
//        let tv = UITableView()
//        tv.dataSource = self
//        //        tv.backgroundColor = UIColor.clear    // 这里设置无用, 因为tv还没有尺寸
//        tv.rowHeight = 35
//        //        tv.separatorStyle = UITableViewCellSeparatorStyle.none  // 这里设置无用, 因为tv还没有尺寸
//        tv.showsVerticalScrollIndicator = false
//        self.tableView = tv
        self.addSubview(self.tableView)
        
        // tableView的约束应该放入layoutSubviews()方法
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        _ = self.tableView.ad_alignInner(orientation: AD_Align.center, referView: self, size: self.bounds.size, offset: CGPoint(x: self.bounds.width, y: 0))
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // 要多设置一部分滚动区域
        self.tableView.contentInset = UIEdgeInsets(top: self.bounds.height * 0.5, left: 0, bottom: self.bounds.height * 0.5, right: 0)
    }
    
    
    // MARK: UITableViewDataSource数据源
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(self.lrcList.count)
        return self.lrcList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 创建cell
        let cell = ADLrcCell.lrcCell(with: tableView)
        
        // 字体
        if indexPath.row == self.currentIndex {
            cell.lrcLabel!.font = UIFont.systemFont(ofSize: 20.0)
        } else {
            cell.lrcLabel!.font = UIFont.systemFont(ofSize: 14.0)
            cell.lrcLabel!.progress = 0
        }
        
        // 给cell设置数据
        cell.lrcLabel!.text = "\(self.lrcList[indexPath.row].text!)"
        
        return cell
    }
    
    // MARK:
    
    
    // MARK: 懒加载
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
//        tv.backgroundColor = UIColor.clear    // 这里设置无用, 因为tv还没有尺寸
        tv.rowHeight = 35
//        tv.separatorStyle = UITableViewCellSeparatorStyle.none  // 这里设置无用, 因为tv还没有尺寸
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    
    lazy var lrcList = [ADLrcline]()
}
