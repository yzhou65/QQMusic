//
//  ADPlayingViewController.swift
//  QQMusic_Swift
//
//  Created by Yue Zhou on 2/20/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import Masonry

class ADPlayingViewController: UIViewController {
    
    @IBOutlet weak var albumView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    
    // 滑块
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var playOrPauseBtn: UIButton!
    @IBOutlet weak var lrcLabel: ADLrcLabel!
    @IBOutlet weak var lrcView: ADLrcView!

    
    // MARK: 界面相关
    override func viewDidLoad() {
        super.viewDidLoad()

        // 添加毛玻璃效果
        setupBlur()
        
        // 设置slider
        self.progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: UIControlState.normal)
        
        
        // 显示界面信息
        startPlaying()
    }
    
    override func viewWillLayoutSubviews() {
        // 给iconView设置圆角, 边框
        self.iconView.layer.cornerRadius = self.iconView.bounds.width * 0.5
        self.iconView.layer.masksToBounds = true
        self.iconView.layer.borderWidth = 8.0
        self.iconView.layer.borderColor = UIColor(colorLiteralRed: 36/255.0, green: 36/255.0, blue: 36/255.0, alpha: 1.0).cgColor
    }
    
    // 添加毛玻璃效果. 可以使用UIToolbar, 因为其半透明效果
    private func setupBlur() {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.black
        self.albumView.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false

        _ = toolbar.andy_alignInner(orientation: Andy_Align.topLeft, referView: self.albumView, size: nil)
        _ = toolbar.andy_alignInner(orientation: Andy_Align.bottomLeft, referView: self.albumView, size: nil)
        _ = toolbar.andy_alignInner(orientation: Andy_Align.topRight, referView: self.albumView, size: nil)
        _ = toolbar.andy_alignInner(orientation: Andy_Align.bottomRight, referView: self.albumView, size: nil)
        
//        toolbar.mas_makeConstraints { (make: MASConstraintMaker?) in
//            make?.edges.equalTo(self.albumView)
//        }
    }
    
    // 把statusBar变为白色. storyboard里的选项无效
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: 开始播放音乐
    func startPlaying() {
        let playingMusic = ADMusicPlayingTool.playingMusic
        
        // 设置界面信息
        self.albumView.image = UIImage(named: playingMusic.icon!)
        self.iconView.image = UIImage(named: playingMusic.icon!)
        self.songLabel.text = playingMusic.name!
        self.singerLabel.text = playingMusic.singer!
        
        // 播放音乐
        let player = ADAudioTool.audioPlayWith(musicName: playingMusic.filename!)
        self.totalTimeLabel.text = String(time: player.duration)
        self.currentTimeLabel.text = String(time: player.currentTime)
        
    }
    
    
    

    // MARK: 按钮响应
    @IBAction func next(_ sender: UIButton) {
        
    }

    @IBAction func previous(_ sender: UIButton) {
        
    }
    
    @IBAction func startSlider(_ sender: UISlider) {
    }
    
    @IBAction func endSlider(_ sender: UISlider) {
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
    }
    
    @IBAction func playOrPause(_ sender: UIButton) {
    }
    
    
    
}
