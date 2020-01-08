//
//  ViewController.swift
//  ios2_Day1
//
//  Created by MacStudent on 2020-01-07.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer


class ViewController: UIViewController {

    var 	audioplayer = AVAudioPlayer()
    var timer: Timer?
    var toggle = 1
    let audioPath:NSURL! = Bundle.main.url(forResource: "example", withExtension: "mp3") as NSURL?
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var seeker: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playBtn: UIBarButtonItem!
    
    let sound = Bundle.main.path(forResource: "example", ofType: "mp3")
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        var updateTimer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
        
        do{
        
            audioplayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            
        }
        catch{
            	print(error)
        }
        
        seeker.maximumValue = Float(audioplayer.duration)
        setDuration()
        updateTime()
        // Do any additional setup after loading the view.
    }
    
    @objc func updateSlider() {
    seeker.value = Float(audioplayer.currentTime)
    }
    
    @objc func updateTime() {
        let currentTime = Int(audioplayer.currentTime)
        let duration = Int(audioplayer.duration)
        let total = currentTime - duration
        _ = String(total)

        let minutes = currentTime/60
        var seconds = currentTime - minutes / 60
        if minutes > 0 {
           seconds = seconds - 60 * minutes
        }
        
        time.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    }

    @IBAction func playBtn(_ sender: UIButton)
    {
        if audioplayer.isPlaying
        {
            audioplayer.pause()
            updateTime()
            sender.setBackgroundImage(UIImage(named: "pause.png"), for: .normal)
        }
        else
        {
            audioplayer.play()
            updateTime()
            //sender.setBackgroundImage(UIImage(named: "play.png"), for: .normal)
            
        }
        
        let playerItem = AVPlayerItem(url: audioPath as URL)
        let metadataList = playerItem.asset.metadata
        
        for item in metadataList {

            guard let key = item.commonKey?.rawValue, let value = item.value else{
                continue
            }

           switch key {
            case "title" : trackLabel.text = value as? String
            case "artist": artistLabel.text = value as? String
            case "artwork" where value is Data : artistImage.image = UIImage(data: value as! Data)
            default:
              continue
           }
        }
    }
    
        
    
    
    @IBAction func pause(_ sender: Any)
    {
        audioplayer.pause()
        updateTime()
    }
    
    
    @IBAction func volume(_ sender: Any)
    {
        audioplayer.volume = volumeSlider.value
    }
    
    
    
    @IBAction func scrubAudio(_ sender: Any)
    {
        seeker.maximumValue = Float(audioplayer.duration)
        audioplayer.stop()
        audioplayer.currentTime = TimeInterval(seeker.value)
        audioplayer.prepareToPlay()
        audioplayer.play()
    }
    
    func setDuration()
    {
        let duration = Int(audioplayer.duration)
        let minutes = duration/60
        var seconds = duration - minutes / 60
        if minutes > 0 {
           seconds = seconds - 60 * minutes
        }
        durationLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        
    }
    
    
    
}

