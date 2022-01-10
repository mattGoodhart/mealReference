//
//  InfoViewController.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/10/22.
//

import UIKit
import SafariServices

class InfoViewController: UIViewController {
    
    @IBOutlet weak var thankYou: UILabel!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var linkedInButton: UIButton!
    @IBOutlet weak var seeTheCodeButton: UIButton!
    
    override func viewDidLoad() {
        thankYou.text = "mealReference app by Matt Goodhart, January 2022\n\nfor the Fetch Rewards iOS Coding Challenge\nas part of his application to the iOS Engineer Apprenticeship"
    }
    @IBAction func seeTheCodeTapped() {
        let codeURLString =  "https://github.com/mattGoodhart/mealReference"
        presentSafariViewController(urlString: codeURLString)
    }
    @IBAction func linkedinTapped() {
        let linkedInURLString = "https://linkedin.com/in/matthewgoodhart"
        loadLinkedIn(linkedInURLString: linkedInURLString)
    }
    
    @IBAction func resumeTapped() { //make pdf viewcontroller?
        let resumeURLString = "https://drive.google.com/file/d/1NxNt1KZdMnr09gLhOmq48s9t43MRxxnf"
        presentSafariViewController(urlString: resumeURLString)
    }
    
    func loadLinkedIn(linkedInURLString: String) {
        guard let linkedInURL = URL(string: linkedInURLString) else {
            return
        }
        UIApplication.shared.open(linkedInURL, options: [:], completionHandler: nil)
    }
    
    func presentSafariViewController(urlString: String) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}
