//
//  Utilities.swift
//  CodeChallenge
//
//  Created by Supriya Rajkoomar on 13/09/2022.
//

import Foundation
import UIKit

//Adding activity indicator to a given view
public func addLoader(ToMainView view : UIView) -> UIActivityIndicatorView{
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.center = CGPoint.init(x: view.center.x, y: view.center.y - 64)
    activityIndicator.startAnimating()
    view.addSubview(activityIndicator)
    
    return activityIndicator
}

class AlertViewUtility{
    
    open class func showAlertWithTitle(_ container:UIViewController, tintColor:UIColor?,title:String , message:String , cancelButtonTitle:String , completion :@escaping (_ completion:Bool) ->Void){
        let alert =  UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction.init(title: cancelButtonTitle, style: .cancel) { (action :UIAlertAction) in
            
            alert.dismiss(animated: true, completion: {
                
            })
            completion(true)
        }
        
        alert.addAction(alertAction)
        container.present(alert, animated: true, completion: nil)
    }

}


