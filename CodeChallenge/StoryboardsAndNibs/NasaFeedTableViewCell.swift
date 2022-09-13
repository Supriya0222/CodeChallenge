//
//  NasaFeedTableViewCell.swift
//  CodeChallenge
//
//  Created by Supriya Rajkoomar on 13/09/2022.
//

import UIKit

class NasaFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var feedTitleLbl: UILabel!
    @IBOutlet weak var feedPhotographerLbl: UILabel!
    @IBOutlet weak var feedDateLbl: UILabel!
    
    var item: Item? = nil {
        didSet {
            if let item = item{
                if let title = item.title{
                    feedTitleLbl.text = title.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                
                if let photographer = item.photographer{
                    feedPhotographerLbl.text = photographer.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                
                if let urlString = item.imageUrl, let url = URL.init(string: urlString.trimmingCharacters(in: .whitespacesAndNewlines)){
                    feedImageView.load(url: url)
                }
                
                if let dateString = item.dateCreated {
                    feedDateLbl.text = getDate(WithString: dateString, format: "dd MMM, yyyy")
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
