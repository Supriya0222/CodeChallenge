//
//  DetailsViewController.swift
//  CodeChallenge
//
//  Created by Supriya Rajkoomar on 14/09/2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var itemModel : Item?

    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var photographerLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var scrollViewWidthConstant: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        //Set width barometer for scroll view
        scrollViewWidthConstant.constant = UIScreen.main.bounds.width

    }
    
    //Update UI when feed is obtained. Remove all white spaces when displaying information
    fileprivate func updateUI(){
        if let item = itemModel{
            if let title = item.title{
                titleLbl.text = title.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            if let desc = item.descriptionDisplay{
                descLbl.text = desc.trimmingCharacters(in: .whitespacesAndNewlines)
                descLbl.setLineHeight(lineHeight: 8.0)
            }
            
            if let dateString = item.dateCreated{
                dateLbl.text = getDate(WithString: dateString, format: "dd MMM, yyyy")
            }
            
            if let urlString = item.imageUrl, let url = URL.init(string: urlString.trimmingCharacters(in: .whitespacesAndNewlines)){
                detailsImageView.load(url: url)
            }
            
            if let photographer = item.photographer {
                photographerLbl.text = photographer.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
    }

    
}
