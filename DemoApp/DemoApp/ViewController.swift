//
//  ViewController.swift
//  DemoApp
//
//  Created by Tecordeon-14 on 16/02/18.
//  Copyright © 2018 Tecordeon. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation



class ViewController: UIViewController,AVAudioPlayerDelegate {

    @IBOutlet weak var playButton: UIButton!
     @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var songNameLbl: UILabel!
    
    let player = MPMusicPlayerController.systemMusicPlayer
    
    var audioPlayer:AVAudioPlayer! = nil
    var currentAudio = ""
    var currentAudioPath:URL!
    var currentAudioIndex = 0
    var timer:Timer!
    var audioLength = 0.0
    var toggle = true
     var effectToggle = true
      var totalLengthOfAudio = ""
    
    var audioList : [MPMediaItem]? = nil
    
    //MARK:- Lockscreen Media Control
    
    // This shows media info on lock screen - used currently and perform controls
    func showMediaInfo(){
       
        let songName = readSongNameFromPlist(currentAudioIndex)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle : songName]
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event!.type == UIEventType.remoteControl{
            switch event!.subtype{
            case UIEventSubtype.remoteControlPlay:
                play(self)
            case UIEventSubtype.remoteControlPause:
                play(self)
            case UIEventSubtype.remoteControlNextTrack:
                next(self)
            case UIEventSubtype.remoteControlPreviousTrack:
                previous(self)
            default:
                print("There is an issue with the control")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         audioList = MPMediaQuery.songs().items
        
//        let mediaCollection = MPMediaItemCollection(items: mediaItems!)
//
//        print(mediaCollection)
//        print(mediaItems)
        
       // let mediaCollection = MPMediaItemCollection(items: mediaItems!)
       
//        player.setQueue(with: mediaCollection)
//        player.play()
//        playerTime()
        
      
        retrieveSavedTrackNumber()
        prepareAudio()
        updateLabels()
        assingSliderUI()
        retrieveprogressBarValue()
        //LockScreen Media control registry
        if UIApplication.shared.responds(to: #selector(UIApplication.beginReceivingRemoteControlEvents)){
            UIApplication.shared.beginReceivingRemoteControlEvents()
            UIApplication.shared.beginBackgroundTask(expirationHandler: { () -> Void in
            })
        }
        
        
        
    }
    
    // MARK:- AVAudioPlayer Delegate's Callback method
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        prepareAudio()
        playAudio()
            
        
    }
    
    
    //Sets audio file URL
    func setCurrentAudioPath(){
//        currentAudio = readSongNameFromPlist(currentAudioIndex)
//        currentAudioPath = URL(fileURLWithPath: Bundle.main.path(forResource: currentAudio, ofType: "mp3")!)
       
        
        let currentSong = audioList![currentAudioIndex]
        currentAudioPath = currentSong.assetURL
         print("\(currentAudioPath)")
        
    }
    
    
    func saveCurrentTrackNumber(){
        UserDefaults.standard.set(currentAudioIndex, forKey:"currentAudioIndex")
        UserDefaults.standard.synchronize()
        
    }
    
    func retrieveSavedTrackNumber(){
        if let currentAudioIndex_ = UserDefaults.standard.object(forKey: "currentAudioIndex") as? Int{
            currentAudioIndex = currentAudioIndex_
        }else{
            currentAudioIndex = 0
        }
    }
    
    // Prepare audio for playing
    func prepareAudio(){
        setCurrentAudioPath()
        do {
            //keep alive audio at background
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
        audioPlayer = try? AVAudioPlayer(contentsOf: currentAudioPath)
        audioPlayer.delegate = self
        audioLength = audioPlayer.duration
        progressBar.maximumValue = CFloat(audioPlayer.duration)
        progressBar.minimumValue = 0.0
        progressBar.value = 0.0
        audioPlayer.prepareToPlay()
        showTotalSongLength()
        updateLabels()
        currentTime.text = "00:00"
        
        
    }
    
    //MARK:- Player Controls Methods
    func  playAudio(){
        audioPlayer.play()
        startTimer()
        updateLabels()
        saveCurrentTrackNumber()
        showMediaInfo()
    }
    
    func playNextAudio(){
        currentAudioIndex += 1
        if currentAudioIndex>(audioList?.count)!-1{
            currentAudioIndex -= 1
            return
        }
        if audioPlayer.isPlaying{
            prepareAudio()
            playAudio()
        }else{
            prepareAudio()
        }
        
    }
    
    
    func playPreviousAudio(){
        currentAudioIndex -= 1
        if currentAudioIndex<0{
            currentAudioIndex += 1
            return
        }
        if audioPlayer.isPlaying{
            prepareAudio()
            playAudio()
        }else{
            prepareAudio()
        }
        
    }
    
    
    func stopAudiplayer(){
        audioPlayer.stop();
        
    }
    
    func pauseAudioPlayer(){
        audioPlayer.pause()
        
    }
    
    //MARK:-
    
    func startTimer(){
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update(_:)), userInfo: nil,repeats: true)
           // timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)

            timer.fire()
        }
    }
    
    func stopTimer(){
        timer.invalidate()
        
    }
    
     @objc func update(_ timer: Timer){
        if !audioPlayer.isPlaying{
            return
        }
        let time = calculateTimeFromNSTimeInterval(audioPlayer.currentTime)
        currentTime.text  = "\(time.minute):\(time.second)"
        progressBar.value = CFloat(audioPlayer.currentTime)
        UserDefaults.standard.set(progressBar.value , forKey: "progressBarValue")
        
        
    }
    
    func retrieveprogressBarValue(){
        let progressBarValue =  UserDefaults.standard.float(forKey: "progressBarValue")
        if progressBarValue != 0 {
            progressBar.value  = progressBarValue
            audioPlayer.currentTime = TimeInterval(progressBarValue)
            
            let time = calculateTimeFromNSTimeInterval(audioPlayer.currentTime)
            currentTime.text  = "\(time.minute):\(time.second)"
            progressBar.value = CFloat(audioPlayer.currentTime)
            
        }else{
            progressBar.value = 0.0
            audioPlayer.currentTime = 0.0
            currentTime.text = "00:00:00"
        }
    }
    func showTotalSongLength(){
        calculateSongLength()
        totalTime.text = totalLengthOfAudio
    }
    
    func calculateSongLength(){
        let time = calculateTimeFromNSTimeInterval(audioLength)
        totalLengthOfAudio = "\(time.minute):\(time.second)"
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateLabels(){
        updateSongNameLabel()
        
        
    }
    
    func readSongNameFromPlist(_ indexNumber: Int) -> String {
       
       
        let songDetails = audioList![indexNumber]
        
        let songName = songDetails.title
        return songName!
    }
    

    
    func updateSongNameLabel(){
        let songName = readSongNameFromPlist(currentAudioIndex)
        songNameLbl.text = songName
    }
    
    
    
    
    func assingSliderUI () {
//        let minImage = UIImage(named: "slider-track-fill")
//        let maxImage = UIImage(named: "slider-track")
//        let thumb = UIImage(named: "thumb")
//
//        progressBar.setMinimumTrackImage(minImage, for: UIControlState())
//        progressBar.setMaximumTrackImage(maxImage, for: UIControlState())
//        progressBar.setThumbImage(thumb, for: UIControlState())
        
        
    }
    
    
   // MARK: Controls
    
    @IBAction func play(_ sender : AnyObject) {
        
      
        let play = UIImage(named: "play")
        let pause = UIImage(named: "pause")
        if audioPlayer.isPlaying{
            pauseAudioPlayer()
            audioPlayer.isPlaying ? "\(playButton.setImage( pause, for: UIControlState()))" : "\(playButton.setImage(play , for: UIControlState()))"
            
        }else{
            playAudio()
            audioPlayer.isPlaying ? "\(playButton.setImage( pause, for: UIControlState()))" : "\(playButton.setImage(play , for: UIControlState()))"
        }
    }
    
    
    
    @IBAction func next(_ sender : AnyObject) {
        playNextAudio()
    }
    
    
    @IBAction func previous(_ sender : AnyObject) {
        playPreviousAudio()
    }
    
    
    
    
    @IBAction func changeAudioLocationSlider(_ sender : UISlider) {
        audioPlayer.currentTime = TimeInterval(sender.value)
        
    }
  
    
    
    //This returns song length
    func calculateTimeFromNSTimeInterval(_ duration:TimeInterval) ->(minute:String, second:String){
        // let hour_   = abs(Int(duration)/3600)
        let minute_ = abs(Int((duration/60).truncatingRemainder(dividingBy: 60)))
        let second_ = abs(Int(duration.truncatingRemainder(dividingBy: 60)))
        
        // var hour = hour_ > 9 ? "\(hour_)" : "0\(hour_)"
        let minute = minute_ > 9 ? "\(minute_)" : "0\(minute_)"
        let second = second_ > 9 ? "\(second_)" : "0\(second_)"
        return (minute,second)
    }
    
    
}

