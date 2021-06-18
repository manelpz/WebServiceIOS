//
//  ViewController.swift
//  WebServiceIOS
//
//  Created by Emmanuel Lopez Guerrero on 15/06/21.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    var word: String?
    
    @IBOutlet var webView: WKWebView!
   
    @IBOutlet var SearchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func SearchButton(_ sender: Any) {
        
        if SearchField.text?.isEmpty != nil {
            word = SearchField.text!
        }
            
        let urlComplete = "https://en.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&titles=\(word!.replacingOccurrences(of: " ", with: "%20"))"
        
        let urlObj = URL(string: urlComplete)
        
        let task = URLSession.shared.dataTask(with: urlObj!){
            data, request, error in
            
            if error != nil {
                print(error!)
            }else{
               
                do {
                     let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                        print(json)
                    
                    let querySubJson = json["query"] as! [String:Any]
                    let pagesSubJson = querySubJson["pages"] as! [String: Any]
                    let pageId = pagesSubJson.keys
                    let firstKey = pageId.first!
                    let idSubJson = pagesSubJson[firstKey] as! [String:Any]
                    let extractStringHTML = idSubJson["extract"] as! String
                    
                    DispatchQueue.main.sync {
                        self.webView.loadHTMLString(extractStringHTML, baseURL: nil)
                    }
                    
                }catch{
                    print("Json parse error")
                }
               
            }
        }
        
        task.resume()
        
    }
    
}


