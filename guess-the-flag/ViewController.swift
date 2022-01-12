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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score: \(score)", style: UIBarButtonItem.Style.plain , target: self, action: #selector(shareScore))
        
        askQuestion()
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
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        questionsAnswered += 1
        
        if (questionsAnswered < 10) {
            // An unique tag was set to each button
            // in Storyboard to match the correct answser
            if sender.tag == correctAnswer {
                title = "Correct"
                score += 1
                navigationItem.rightBarButtonItem?.title = "Score: \(score)"
            } else {
                let flagName = countries[correctAnswer].capitalized
                title = "Wrong! That's the flag of \(flagName)"
                navigationItem.rightBarButtonItem?.title = "Score: \(score)"
            }
            
            let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            
            // Animate the alert
            present(ac, animated: true)
        } else {
            questionsAnswered = 0
            let ac = UIAlertController(title: "Game finished", message: "Your score is \(score)", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Play again", style: .default, handler: askQuestion))
            
            // Animate the alert
            present(ac, animated: true)
        }
    }
    
    @objc func shareScore() {
        let message = "My score in Guess the Flags: \(score)"
        
        let vc = UIActivityViewController(activityItems: [message], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
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
