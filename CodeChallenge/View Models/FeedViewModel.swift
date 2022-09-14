//
//  FeedViewModel.swift
//  CodeChallenge
//
//  Created by Supriya Rajkoomar on 13/09/2022.
//

import Foundation

class FeedViewModel {
    // Create URL
    let url = URL(string: "https://images-api.nasa.gov/search?q=%22%22")
    var feeds: [Item] = []
    
     func requestCall(completed: @escaping (_ success :Bool, _ error: String?) -> Void){
        guard let requestUrl = url else { fatalError() }
        
         var request = URLRequest(url: requestUrl)
         
        request.httpMethod = "GET"
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                completed(false, error.localizedDescription)
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String.init(data: data, encoding: .utf8) {
                let result = self.convertStringToDictionary(text: dataString)
               
                if let collection = result?["collection"] as? [String: Any], let items = collection["items"] as? [[String: AnyObject]]{
                    self.feeds = DBManager.shared.parseResponse(Reponse: items)
                    
                    completed(true, "")

                } else {
                    completed(false, "An error has occurred. Please try again later.")
                }
            } else {
                completed(false, "An error has occurred. Please try again later.")
            }
            
        }
        task.resume()

    }
    
    func convertStringToDictionary(text: String) -> [String:Any]? {
       if let data = text.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
   }
    
    func getDate(WithString string: String, format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: string)

        dateFormatter.dateFormat = format
        
        if let _ = date{
            return "\(dateFormatter.string(from: date!))"
        }
        return ""

    }


}
