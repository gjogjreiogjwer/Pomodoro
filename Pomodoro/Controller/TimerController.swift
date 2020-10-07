//
//  TimerController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/7.
//

import UIKit
import AVFoundation

protocol TimerDelegate {
    func didUpdateTime(time:Int)
}


class TimerController: UIViewController {
    
    var time = 0.0
    var timer = Timer()
    var isCounting = false
    var delegate:TimerDelegate?
    var i = 0
    let themeArr = ["Spring", "Summer", "Autumn", "Winter"]
    var player:AVAudioPlayer?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var muteBotton: UIBarButtonItem!
    
    
    
    @objc func UpdateTimer() {
        time = time - 0.1
        timeLabel.text = String(format: "%.1f", time)
    }
    
    @IBAction func startTimer(_ sender: Any) {
        if(isCounting) {
            return
        }
        startButton.isEnabled = false
        pauseButton.isEnabled = true
            
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TimerController.UpdateTimer), userInfo: nil, repeats: true)
        isCounting = true
    }
    
    @IBAction func pauseTimer(_ sender: Any) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
            
        timer.invalidate()
        isCounting = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = String(time)
        pauseButton.isEnabled = false
        muteBotton.isEnabled = false

    }
    
    @IBAction func done(_ sender: Any) {
        delegate?.didUpdateTime(time: Int(time))
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mute(_ sender: Any) {
        if player!.isPlaying{
            player!.stop()
            muteBotton.title = "Unmute"
        }
        else{
            player!.play()
            muteBotton.title = "Mute"
        }
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        muteBotton.isEnabled = true
        changeTheme()
        changeMusic()
        
        i = i >= themeArr.count-1 ? 0 : i+1
    }
    
    
    func changeTheme(){
        let themeLabel = UILabel()
//        themeLabel.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        themeLabel.layer.cornerRadius = 5.0
        themeLabel.font = UIFont.systemFont(ofSize: 30)
        themeLabel.adjustsFontSizeToFitWidth=true
        themeLabel.text = "Theme: \(themeArr[i])"
        view.addSubview(themeLabel)
        
        themeLabel.frame.size.width = 300
        themeLabel.frame.size.height = 100
        themeLabel.center.x = view.center.x
        themeLabel.center.y = view.frame.height + 50
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 10,
                       options: [],
                       animations: {
                        themeLabel.frame.size.width = 600
                        themeLabel.frame.size.height = 100
                        themeLabel.center.x = self.view.frame.width - 10
                        themeLabel.center.y -= 150
                       },
                       completion: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 2,
                       options: .curveEaseIn) {
            themeLabel.frame.size.width = 300
            themeLabel.frame.size.height = 100
            themeLabel.center.x = self.view.frame.width
            themeLabel.center.y = self.view.frame.height + 50
        } completion: { _ in
            themeLabel.removeFromSuperview()
        }
    }
    
    
    func changeMusic(){
        let url = Bundle.main.url(forResource: themeArr[i], withExtension: "mp3")
        do{
            player = try AVAudioPlayer(contentsOf: url!)
            player!.numberOfLoops = -1
            player!.play()
        }catch{
            print(error)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
