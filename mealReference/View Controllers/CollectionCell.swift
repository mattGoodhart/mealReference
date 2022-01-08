//
//  CollectionCell.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/6/22.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CollectionCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.hidesWhenStopped = true
        textView.text = ""
        imageView.image = UIImage(systemName: "menucard.fill")
    }
    
}
