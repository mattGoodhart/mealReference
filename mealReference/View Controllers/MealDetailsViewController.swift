//
//  MealDetailsViewController.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/5/22.
//

import UIKit

class MealDetailsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var allTextLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var youtubeButton: UIButton!

   
    
    var mealDetailsBaseURLString: String = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
    var mealID: String = ""
    var mealName: String = ""
    var chosenMealDetails: MealDetailResults!
    var newIngredientsAndMeasures: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMealDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  rebuildStackView()
    }
    
    func loadYoutube(videoURLString: String) {
        guard let youtubeURL = URL(string: videoURLString) else {
            return
        }
        UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
    }
    
    @IBAction func youtubeButtonTapped(sender: UIButton) {
        loadYoutube(videoURLString: chosenMealDetails.youtubeURLString)
    }

    func loadPhotoFromURL(url: URL) {
        
        guard let imageData = try? Data(contentsOf: url) else {
            print("Photo Download Failure")
            return
        }
        
        DispatchQueue.main.async {
            let image = UIImage(data: imageData)
            self.imageView.image = image
            self.handleActivityIndicator(indicator: self.activityIndicator, viewController: self, isActive: false)
        }
    }
    func rebuildStackView() {
        
        for view in stackView.subviews {
            stackView.removeArrangedSubview(view)
        }
        
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(allTextLabel)
       // stackView.addArrangedSubview(areaLabel)
//        stackView.addArrangedSubview(youtubeButton)
   
        //stackView.addArrangedSubview(ingredientsLabel)
     //   stackView.addArrangedSubview(instructionsTextView)
    }
    
    func placeYoutubeButton() {
        youtubeButton.translatesAutoresizingMaskIntoConstraints = false
        youtubeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        youtubeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
    }
    
    func setUpView() {
        var newIngredientsText: String = ""
        self.navigationItem.title = self.chosenMealDetails.mealName
       // self.areaLabel.text = self.chosenMealDetails.area
      //  self.instructionsTextView.text = self.chosenMealDetails.instructions
      
        
        for item in newIngredientsAndMeasures {
            newIngredientsText += item
        }
        
        allTextLabel.text = newIngredientsText + "\n\n\n\n" + chosenMealDetails.instructions
        
        
       // self.ingredientsLabel.text = newIngredientsText
        
        let urlString = self.chosenMealDetails.mealImageURL
        
        if let url = URL(string: urlString) {
            self.loadPhotoFromURL(url: url)
        }
        
        rebuildStackView()
        
      //  placeYoutubeButton()
    }

    
    func parseMealDetails() {
        
        var cleanIngredientsStringArray: [String] = []
        var cleanMeasuresStringArray: [String] = []
        let mirror = Mirror(reflecting: self.chosenMealDetails!)
        
        for child in mirror.children {
            
            if let label = child.label, let value = child.value as? String {
                
                if (value != "" && value != " " && value != "  ")  {
                    if label.prefix(10) == "ingredient" {
                        cleanIngredientsStringArray.append(value + " - ")
                    } else if label.prefix(7) == "measure" {
                        cleanMeasuresStringArray.append(value + "\n")
                    }
                }
                
                newIngredientsAndMeasures = zip(cleanIngredientsStringArray, cleanMeasuresStringArray).map(+)
                
            }
        }
        setUpView()
    }
    
        func fetchMealDetails() {
            
            guard let url = URL(string: mealDetailsBaseURLString + mealID) else {
                print("Couldnt Create URL for Meal Details")
                return
            }
            
            print("fetching meal details")
            
            Networking.shared.taskForJSON(url: url, responseType: MealDetailsResponse.self) { response, error in
                
                guard let response = response else {
                    print("Error fetching Meal Details Response from theMealDB")
                    print(error as Any)
                    self.handleActivityIndicator(indicator: self.activityIndicator, viewController: self, isActive: false)
                    return // add alert message?
                }
                self.chosenMealDetails = response.meals.first
                self.parseMealDetails()
            }
        }
    }
    
    
    
    
    
    

