//
//  MealCollectionCell.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/7/22.
//

import UIKit

class MealCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MealCollectionCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.hidesWhenStopped = true
        textView.text = ""
        imageView.image = UIImage(systemName: "greetingcard.fill")
    }
    
}
