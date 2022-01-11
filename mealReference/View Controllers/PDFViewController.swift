//
//  PDFViewController.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/10/22.
//

import PDFKit


class PDFViewController: UIViewController {
    

@IBOutlet weak var pdfView: PDFView!

var resumeData: Data!
    
    override func viewDidLoad() {
        setPDFView()
    }
    
    func setPDFView() {
        let resume = PDFDocument(data: resumeData)
        pdfView.contentMode = .scaleAspectFit
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        pdfView.document = resume
        pdfView.frame = view.frame
    }
}
