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
    var currentIndex: Int?

    // 当前播放的时间
    var currentTime: TimeInterval? {
        didSet {
            // 用当前时间和歌词进行匹配
            let count = self.lrcList.count
            for i in 0..<count - 1 {
                let lrcLine = self.lrcList[i]
//                var nextLine: ADLrcline?
//                if i + 1 < count {
//                    nextLine = self.lrcList[i + 1]
//                }
                let nextLine = self.lrcList[i + 1]
                
                // 用当前时间和i位置以及i+1位置的歌词进行比较
                if (self.currentIndex != i && currentTime! >= lrcLine.time! && currentTime! < nextLine.time!) {
                    self.tableView.scrollToRow(at: IndexPath(row: i, section: 0), at: UITableViewScrollPosition.top, animated: true)
                    self.currentIndex = i
                    
                    // 刷新
                    
                    break
                }
                
                
                // 让正在播放的这句歌词字体
                if self.currentIndex == i {
                    
                }
            }
        }
    }
    var lrcLabel: ADLrcLabel?
    var duration: CGFloat?
    
    var lrcname: String? {
        didSet {
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
        return self.lrcList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 创建cell
        let cell = ADLrcCell.lrcCell(with: tableView)
        
        // 给cell设置数据
        cell.textLabel?.text = "\(self.lrcList[indexPath.row].text!)"
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
