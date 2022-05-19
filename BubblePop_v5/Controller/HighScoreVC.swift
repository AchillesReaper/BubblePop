//
//  HighScoreVC.swift
//  BubblePop_v5
//
//  Created by Donald Ho on 24/4/2022.
//

import UIKit
let KEY_HIGH_SCORE = "ranking"
struct GameScore: Codable {
    var player: String
    var score: Int
}

class HighScoreVC: UIViewController {
    
    var highScores:[GameScore] = []
    var newRecordPlayer: String?
    var newRecordScore: Int?
    
    @IBOutlet var newGameScoreLable: UILabel!
    @IBOutlet var rankingTable: UITableView!
    
    @IBAction func backToHome(){
        let vc = storyboard?.instantiateViewController(identifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
        vc.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    //reset button is used to clear the game score record in UserDefaults
    @IBAction func resetRanking(){
        removeUserDefaultsObj(key: KEY_HIGH_SCORE)
        highScores = []
        rankingTable.reloadData()
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        rankingTable.delegate = self
        rankingTable.dataSource = self
        updateUserDefaults()
        
    }
    
    
    // retrive the record from the UserDefaults and update the new record to it
    func updateUserDefaults(){
        let previousRecord = readUserDefaults(key: KEY_HIGH_SCORE)
        highScores = previousRecord
        let newRecordRead = readUserDefaults(key: KEY_NEW_RECORD)
        if newRecordRead.count == 1 {
            newGameScoreLable.text = "Your score: \(newRecordRead[0].score)!!"
            highScores.append(newRecordRead[0])
            highScores.sort{$0.score > $1.score}
            writeHighScores(updatedRecords: highScores)
            //to prepare a new game, this "new record" need to be cleaned once it become part of the exsiting record
            removeUserDefaultsObj(key: KEY_NEW_RECORD)
        }else{
            newGameScoreLable.text = "👑 Top Ranking 👑"
        }
    }
    
    func writeHighScores(updatedRecords: [GameScore]){
        let defaults = UserDefaults.standard
        defaults.set(try? PropertyListEncoder().encode(updatedRecords), forKey: KEY_HIGH_SCORE)
    }
    
    
    //this function can be used to retrived data score in UserDefaults.
    //It is designed to retrive the existing record and the new record from the game just finished
    func readUserDefaults(key: String) -> [GameScore]{
        let defaults = UserDefaults.standard
        if let savedArrayData = defaults.value(forKey:key) as? Data {
            if let array = try? PropertyListDecoder().decode(Array<GameScore>.self, from: savedArrayData) {
                return array
            } else {
                return []
            }
        } else {
            return []
        }
    }
    
    func removeUserDefaultsObj(key: String){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
    }
}

extension HighScoreVC: UITableViewDelegate{
    
}

extension HighScoreVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameScoreCell", for: indexPath)
        let score = highScores[indexPath.row]
        cell.textLabel?.text = score.player
        cell.detailTextLabel?.text = "Score: \(score.score)"
        return cell
    }
    
}
