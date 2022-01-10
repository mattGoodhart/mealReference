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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var resumeData: Data!
    
    override func viewDidLoad() {
        thankYou.text = "mealReference app by Matt Goodhart, January 2022\n\nfor the Fetch Rewards iOS Coding Challenge\nas part of his application to the iOS Engineer Apprenticeship"
        
        activityIndicator.isHidden = true
    }
    @IBAction func seeTheCodeTapped() {
        let codeURLString =  "https://github.com/mattGoodhart/mealReference"
        presentSafariViewController(urlString: codeURLString)
    }
    @IBAction func linkedinTapped() {
        let linkedInURLString = "https://linkedin.com/in/matthewgoodhart"
        loadLinkedIn(linkedInURLString: linkedInURLString)
    }
    
    @IBAction func resumeTapped() {

        let resumeURLString = "https://drive.google.com/u/0/uc?id=1NxNt1KZdMnr09gLhOmq48s9t43MRxxnf&export=download"
        
        guard let resumeURL = URL(string: resumeURLString) else {
        
            //fire alert vc
            return
        }
        fetchResume(url: resumeURL)
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
    
    func fetchResume(url: URL) {
        
        activityIndicator.isHidden = false
        // turn on activity indicator
        Networking.shared.fetchData(at: url) { data in
            guard let data = data else {
                print("resume download failure.")
                self.activityIndicator.isHidden = true
                return
            }
          //  self.resumeData = data
            self.activityIndicator.isHidden = true
            let pdfViewController = self.storyboard!.instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
            pdfViewController.resumeData = data
            pdfViewController.modalTransitionStyle = .crossDissolve
            self.present(pdfViewController, animated: true, completion: nil)
            
           // self.moveToPDFViewController(pdfData: data)
            //turn off activity indicator
        }
    }
    
    func moveToPDFViewController(pdfData: Data) {
        let pdfViewController = storyboard!.instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
        pdfViewController.resumeData = resumeData
        pdfViewController.modalTransitionStyle = .crossDissolve
        present(pdfViewController, animated: true, completion: nil)
        
        
    }
    
    
}
