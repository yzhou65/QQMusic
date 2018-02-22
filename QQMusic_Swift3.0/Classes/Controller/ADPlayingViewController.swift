//
//  ADPlayingViewController.swift
//  QQMusic_Swift
//
//  Created by Yue Zhou on 2/20/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import Masonry
import AVFoundation

class ADPlayingViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var albumView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    // 滑块
    @IBOutlet weak var progressSlider: UISlider!
    
    // 歌词的view
    @IBOutlet weak var lrcView: ADLrcView!
    @IBOutlet weak var playOrPauseBtn: UIButton!
    @IBOutlet weak var lrcLabel: ADLrcLabel!
    

    // 当前歌曲的播放器
    var currentPlayer: AVAudioPlayer?
    
    // 进度的timer
    var progressTimer: Timer?
    
    // 歌词更新的定时器(因为有些歌比较快, 所以需要更快的更新频率, 所以用CADisplayLink)
    var lrcTimer: CADisplayLink?
    
    
    // MARK: 界面相关
    override func viewDidLoad() {
        super.viewDidLoad()

        // 添加毛玻璃效果
        setupBlur()
        
        // 设置slider
        self.progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: UIControlState.normal)
        
        
        // 显示界面信息
        startPlaying()
        
        // 设置lrcView的contentSize
        self.lrcView.contentSize = CGSize(width: self.view.bounds.width * 2, height: 0)
        
        // 让storyboard里的lrcLabel和lrcView里的lrcLabel同步
        self.lrcView.lrcLabel = self.lrcLabel
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

        _ = toolbar.ad_alignInner(orientation: AD_Align.topLeft, referView: self.albumView, size: nil)
        _ = toolbar.ad_alignInner(orientation: AD_Align.bottomLeft, referView: self.albumView, size: nil)
        _ = toolbar.ad_alignInner(orientation: AD_Align.topRight, referView: self.albumView, size: nil)
        _ = toolbar.ad_alignInner(orientation: AD_Align.bottomRight, referView: self.albumView, size: nil)
        
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
        let playingMusic = ADMusicPlayingTool.getPlayingMusic()
        
        // 设置界面信息
        self.albumView.image = UIImage(named: playingMusic.icon!)
        self.iconView.image = UIImage(named: playingMusic.icon!)
        self.songLabel.text = playingMusic.name!
        self.singerLabel.text = playingMusic.singer!
        
        // 播放音乐
        let player = ADAudioTool.audioPlayWith(musicName: playingMusic.filename!)
        self.currentPlayer = player
        
        // 更新子控件文字, 播放按钮状态
        self.totalTimeLabel.text = String(time: player.duration)
        self.currentTimeLabel.text = String(time: player.currentTime)
        self.playOrPauseBtn.isSelected = self.currentPlayer!.isPlaying
        
        // 更新歌词
        self.lrcView.lrcname = playingMusic.lrcname!
        
        // 开始播放的动画
//        self.startAnimation()
        self.iconView.layer.add(self.iconViewRotationAnim, forKey: nil)
        
        // 先移除以前的定时器, 再启动定时器操作
        removeProgressTimer()
        addProgressTimer()
        removeLrcTimer()
        addLrcTimer()
    }
    
    
    // MARK: 定时器操作
    // 歌曲播放的进度定时器
    private func addProgressTimer() {
        self.updateProgress()   // 一开始就强制让滑块和时间归0
        self.progressTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        RunLoop.main.add(self.progressTimer!, forMode: RunLoopMode.commonModes)
    }
    
    // 歌词的定时器
    private func addLrcTimer() {
        self.lrcTimer = CADisplayLink(target: self, selector: #selector(updateLrc))
        
        // 与Timer类添加到runLoop的方式略不同
        self.lrcTimer!.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    
    
    private func removeProgressTimer() {
        self.progressTimer?.invalidate()
        self.progressTimer = nil
    }
    
    private func removeLrcTimer() {
        self.lrcTimer?.invalidate()
        self.lrcTimer = nil
    }
    
    // MARK: 定时器调用的函数
    // 更新歌曲进度和slider进度
    @objc private func updateProgress() {
        // 设置当前的播放时间
        self.currentTimeLabel.text = String(time: self.currentPlayer!.currentTime)
        
        // 更新slider
        self.progressSlider.value = Float(self.currentPlayer!.currentTime) / Float(self.currentPlayer!.duration)
        
        // 播放完一首歌默认自动播放下一首
        if Int(self.currentPlayer!.currentTime) >= Int(self.currentPlayer!.duration) - 1 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { 
                self.next(nil)
            })
        }
    }
    
    // 更新歌词的切换. 放入了CADisplayLink里, 那么1秒就会调用60次
    @objc private func updateLrc() {
        self.lrcView.currentTime = self.currentPlayer!.currentTime
    }

    
    // MARK: slider事件
    
    @IBAction func startDraggingSlider(_ sender: UISlider) {
        // 移除timer
        self.removeProgressTimer()
    }
    
    @IBAction func endDraggingSlider(_ sender: UISlider) {
        // 把歌曲调整为当前播放的时间
        // 这句话要在下面添加timer之前, 因为addTimer()需要最新的播放进度
        self.currentPlayer!.currentTime = self.currentPlayer!.duration * Double(sender.value)
        
        // 把timer添加回来
        self.addProgressTimer()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        // 更新播放时间的文字
        self.currentTimeLabel.text = String(time: self.currentPlayer!.duration * Double(sender.value))
    }
    
    @IBAction func sliderTapped(_ tgr: UITapGestureRecognizer) {
        let p = tgr.location(in: tgr.view)
        
        // 获取点击的位置在slider中占据总长的比例
        let slider: UISlider = tgr.view! as! UISlider
        let ratio = Float(p.x / slider.bounds.width)
        
        // 更新歌曲播放的时间. 如果只更新歌曲播放时间就要等一秒(等定时器)才能更新文字, 所以可以手动updateProgress
        self.currentPlayer!.currentTime = Double(ratio) * self.currentPlayer!.duration
        updateProgress()
//        updateLrc()
    }
    
    
    // MARK: 按钮响应
    @IBAction func next(_ sender: UIButton?) {
        let nextMusic = ADMusicPlayingTool.nextMusic()
//        print(nextMusic.name!)
        self.playMusic(with: nextMusic)
    }
    
    @IBAction func previous(_ sender: UIButton) {
        let previousMusic = ADMusicPlayingTool.previousMusic()
//        print(previousMusic.name!)
        self.playMusic(with: previousMusic)
    }
    
    @IBAction func playOrPause(_ sender: UIButton) {
        // 暂停
        if self.currentPlayer!.isPlaying {
            self.currentPlayer!.pause()
            self.playOrPauseBtn.isSelected = false
            self.removeProgressTimer()  // 移除progressTimer
            self.removeLrcTimer()   // 移除歌词的timer
            self.iconView.layer.pauseAnimation()    // 暂停动画
            
        } else {    // 播放
            self.currentPlayer!.play()
            self.playOrPauseBtn.isSelected = true
            self.addProgressTimer()     // 恢复progressTimer
            self.addLrcTimer()          // 恢复歌词的timer
            self.iconView.layer.resumeAnimation()   // 恢复动画
        }
    }
    
    private func playMusic(with music: ADMusic) {
        // 先停止上一首正在播放的歌曲
        let playing = ADMusicPlayingTool.getPlayingMusic()
        ADAudioTool.audioStopWith(musicName: playing.filename!)
        
        // 播放
        _ = ADAudioTool.audioPlayWith(musicName: music.filename!)
        ADMusicPlayingTool.setPlayingMusic(with: music)
        
        // 更新音乐转盘动画
        self.startPlaying()
    }
    
    
    // MARK: iconView的旋转动画, 懒加载
    lazy var iconViewRotationAnim: CABasicAnimation = {
        let anim = CABasicAnimation()
        anim.keyPath = "transform.rotation" // 或者"transform.rotation.z", 默认围绕z轴
        anim.fromValue = 0
        anim.toValue = M_PI * 2
        anim.repeatCount = MAXFLOAT
        anim.duration = 30
        return anim
    }()
    
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 获取滑动的偏移量
        let point = scrollView.contentOffset
        
        let ratio = 1 - point.x / scrollView.bounds.width
        
        // 设置iconView和歌词的label的透明度
        self.iconView.alpha = ratio
        self.lrcLabel.alpha = ratio
        
    }
}
