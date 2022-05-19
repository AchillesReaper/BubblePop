//
//  ViewController.swift
//  BubblePop_v5
//
//  Created by Donald Ho on 24/4/2022.
//

import UIKit
let KEY_NEW_RECORD = "newGameRecord"
class GameVC: UIViewController {

    @IBOutlet var remainingTimeLabel: UILabel!
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var topScoreLabel: UILabel!
    @IBOutlet var flashingMSG: UILabel!
    
    
    var playerName = "Anonymous"
    var remainingTime = 60
    var gameTime = 60
    var maxBubble = 15
    var bubbleArray: [Bubble] = []
    var lastBubbleValue = 0.0
    var currentScore = 0.0
    var topScoreRecord = 0
    var countingToStart = 4
    var timerInitial = Timer()
    var timer = Timer()
    var comboTime = 0
    var removeAcceleration = 0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerNameLabel.text = playerName
        remainingTimeLabel.text = String(remainingTime)
        scoreLabel.text = "0"
        readTopScoreFromRecord()
        gameTime = remainingTime
        timerInitial = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){
            timerInitial in
            self.initialTimer()
        }
        
    }
    
    //Flash count down at the begining of the play
    func initialTimer(){
        switch countingToStart {
        case 4:
            flashingMSG.text = "Game is about to begin in ..."
            flashingMSG.font = UIFont(name: "Chalkboard SE Bold", size: 20)
        case 3:
            flashingMSG.text = "3"
            flashingMSG.textColor = .green
            flashingMSG.font = UIFont(name: "Chalkboard SE Bold", size: 40)
        case 2:
            flashingMSG.text = "2"
            flashingMSG.textColor = .yellow
            flashingMSG.font = UIFont(name: "Chalkboard SE Bold", size: 60)
        case 1:
            flashingMSG.text = "1"
            flashingMSG.textColor = .red
            flashingMSG.font = UIFont(name: "Chalkboard SE Bold", size: 80)
        case 0:
            flashingMSG.text = "💫GO!"
            flashingMSG.font = UIFont(name: "Chalkboard SE Bold", size: 80)
        default:
            flashingMSG.text=""
            timerInitial.invalidate()
            startBubblePop()
        }
        countingToStart -= 1
    }
    
    //active the play timer. Bubbles will be generate and remove every second.
    func startBubblePop(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.generateBubble()
            self.removeBubble()
            self.counting()
        }
    }
    
    // to update the time remaining label on top
    // when t = 0, push HightScoreVC
    @objc func counting() {
        remainingTime -= 1
        remainingTimeLabel.text = String(remainingTime)
        
        if remainingTime == 0 {
            // At the end of the play,
            // 1) the play timer will be invalidated.
            // 2) the score of the play will be saved to UserDefaults as a new record.
            // 3) the UIView will be redirect to HighScoreVC
            timer.invalidate()
            
            generateNewGameRecord(NR_playerName: playerName, NR_gameScore: Int(currentScore))

            let vc = storyboard?.instantiateViewController(identifier: "HighScoreVC") as! HighScoreVC
            self.navigationController?.pushViewController(vc, animated: true)
            vc.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    func isOverlapped(bubbleToBeGen: Bubble) -> Bool{
        for existingBubble in bubbleArray {
            if bubbleToBeGen.frame.intersects(existingBubble.frame){
                return true
            }
        }
        return false
    }
    
    @objc func generateBubble() {
        let bubbleToGen = Int.random(in: 0...(maxBubble - bubbleArray.count))
        for _ in (0...bubbleToGen){
            let newBubble = Bubble()
            // the newly generated bubble will be check if it is overlapped with the existing bubble before it is added to the view and stored in the program.
            if !isOverlapped(bubbleToBeGen: newBubble){
                newBubble.animation()
                newBubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
                self.view.addSubview(newBubble)
                bubbleArray.append(newBubble)
            }
        }
    }
    
    
    @IBAction func bubblePressed(_ sender: Bubble) {
        // remove pressed bubble from view
        sender.removeFromSuperview()
        
        //combo effect: 1.5 times in score
        if lastBubbleValue == sender.value {
            currentScore += sender.value * 1.5
            comboTime += 1
            switch comboTime {
            case 1:
                flashingMSG.textColor = .white
            case 2:
                flashingMSG.textColor = .blue
            case 3:
                flashingMSG.textColor = .purple
            case 4:
                flashingMSG.textColor = .brown
            case 5:
                flashingMSG.textColor = .black
            default:
                flashingMSG.textColor = .red
            }
            flashingMSG.font = UIFont(name: "Chalkduster", size: CGFloat(20 + 5 * comboTime))
            flashingMSG.text = "💥Combo X \(comboTime)!🔥"
            
        }else{
            currentScore += sender.value
            flashingMSG.text = ""
            comboTime = 0
        }
        lastBubbleValue = sender.value
        
        //the current label and the top record label are updated simultaneously.
        scoreLabel.text = String(currentScore)
        if Int(currentScore) > topScoreRecord {
            topScoreRecord = Int(currentScore)
            topScoreLabel.text = String(topScoreRecord)
        }
        
       //when the bubble is popped, it is also removed from the bubbleArry
        if let firstIndex = bubbleArray.firstIndex(of: sender){
            bubbleArray.remove(at: firstIndex)
        }
    }
    
    func removeBubble(){
        //random amount of bubble will be removed every second
        var i = 0
        removeAcceleration = Int((gameTime - remainingTime) * 60 / gameTime)
        //when the time closing to the end of the play, the bubble will be removed in an accelerating rate.
        while i < bubbleArray.count{
            if arc4random_uniform(100) < (20 + removeAcceleration) {
                bubbleArray[i].flash()
                bubbleArray[i].removeFromSuperview()
                bubbleArray.remove(at: i)
            }
            i += 1
        }
    }
    
    //at the end of the game a "new record" is stored to the UserDefault.
    func generateNewGameRecord(NR_playerName: String, NR_gameScore: Int){
        let defaults = UserDefaults.standard
        let new_record = GameScore(player: NR_playerName, score: NR_gameScore)
        defaults.set(try? PropertyListEncoder().encode([new_record]), forKey: KEY_NEW_RECORD)
    }
    
    // this function is created to display the highest score in the scoreboard.
    func readTopScoreFromRecord(){
        let defaults = UserDefaults.standard
        if let savedArrayData = defaults.value(forKey:KEY_HIGH_SCORE) as? Data {
            if let array = try? PropertyListDecoder().decode(Array<GameScore>.self, from: savedArrayData) {
                topScoreRecord = array[0].score
            } else {
                topScoreRecord = 0
            }
        } else {
            topScoreRecord = 0
        }
    }
  


}

