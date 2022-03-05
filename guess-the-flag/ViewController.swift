//
//  ViewController.swift
//  guess-the-flag
//
//  Created by Bruno Guirra on 02/01/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsAnswered = 0
    var highestScore = HighestScore(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score: \(score)", style: .plain, target: nil, action: nil)
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "highestScore") as? Data {
            let decoder = JSONDecoder()
            
            do {
                highestScore = try decoder.decode(HighestScore.self, from: savedData)
            } catch {
                print("Failed loading highest score.")
            }
        }
        
        starGame()
    }
    
    // Receive a UIAlertAction because it's used as a handler
    // to UIAlertController. It's default nil because the
    // first time the method is called, there's no alert to show
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        questionsAnswered += 1
        
        var acTitle: String
        
        // An unique tag was set to each button
        // in Storyboard to match the correct answser
        if sender.tag == correctAnswer {
            acTitle = "Correct"
            score += 1
            navigationItem.rightBarButtonItem?.title = "Score: \(score)"
        } else {
            score -= 1
            let flagName = countries[correctAnswer].uppercased()
            acTitle = "Wrong! That's the flag of \(flagName)"
            navigationItem.rightBarButtonItem?.title = "Score: \(score)"
        }
        
        
        if (questionsAnswered < 10) {
            let ac = UIAlertController(title: acTitle, message: "Your score is \(score)", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            
            // Animate the alert
            present(ac, animated: true)
        } else {
            var message: String
            
            if score > highestScore.value {
                highestScore = HighestScore(value: score)
                save()
                message = "Congratulations, you broke your previous record!"
            } else {
                message = "Your score is \(score)"
            }
            
            let ac = UIAlertController(title: "Game finished", message: message, preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Play again", style: .default, handler: starGame))
            
            // Animate the alert
            present(ac, animated: true)
        }
    }
    
    func starGame(action: UIAlertAction! = nil) {
        score = 0
        questionsAnswered = 0
        
        navigationItem.rightBarButtonItem?.title = "Score: \(score)"
        askQuestion()
    }
    
    func save() {
        let enconder = JSONEncoder()
        
        if let savedData = try? enconder.encode(highestScore) {
            let defaults = UserDefaults.standard
            
            defaults.set(savedData, forKey: "highestScore")
        } else {
            print("Failed saving highest score.")
        }
    }
}

//extension UINavigationItem {
//    func setTitle(title: String, subtitle: String) {
//        let titleLabel = UILabel()
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
//        titleLabel.text = title
//
//        let subtitleLabel = UILabel()
//        subtitleLabel.text = subtitle
//
//        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
//        stackView.distribution = .equalCentering
//        stackView.alignment = .center
//        stackView.axis = .vertical
//
//        self.titleView = stackView
//    }
//}
