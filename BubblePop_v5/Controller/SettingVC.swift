//
//  ViewController.swift
//  BubblePop_v5
//
//  Created by Donald Ho on 24/4/2022.
//

import UIKit

class SettingVc: UIViewController {

    @IBOutlet var playerNameTextField: UITextField!
    @IBOutlet var timeSlider: UISlider!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var maxBubbleSlider: UISlider!
    @IBOutlet var maxBubbleLabel: UILabel!
    
    @IBAction func timeSlider (_ sender: UISlider) {
        timeLabel.text = String(Int(timeSlider.value)) + " seconds"
    }
    
    @IBAction func maxBubble(_ sender: UISlider){
        maxBubbleLabel.text = String(Int(maxBubbleSlider.value))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame" {
            let VC = segue.destination as! GameVC
            if playerNameTextField.text! == ""{
                VC.playerName = "Anonymous"
            }else{
                VC.playerName = playerNameTextField.text!
            }
            VC.remainingTime = Int(timeSlider.value)
            VC.maxBubble = Int(maxBubbleSlider.value)
        }
    }


}

