//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Patrick Donahue on 12/22/16.
//  Copyright © 2016 Patrick Donahue. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        manager.get("https://api.flickr.com/services/rest/",
//                    parameters: searchParameters,
//                    progress: nil,
//                    success: { (operation: URLSessionDataTask, responseObject:Any?) in
//                        if let responseObject = responseObject {
//                        let json = JSON(responseObject)
//                        print(json)
//
//                        let photos = json["photos"]["photo"].arrayObject
//                            print(photos!)
//                            self.scrollView.contentSize = CGSize(width: 320, height: 320 * CGFloat((photos?.count)!))
//                            for (i,photoDictionary) in (photos?.enumerated())! {                             //1
//                                if let imageURLString = photoDictionary["url_m"] as? String {               //2
//                                    let imageData = NSData(contentsOf: URL(string: imageURLString)!)        //2
//                                    if let imageDataUnwrapped = imageData {                                     //3
//                                        let imageView = UIImageView(image: UIImage(data: imageDataUnwrapped as Data))   //4
//                                        imageView.frame = CGRect(x: 0, y: 320 * CGFloat(i), width: 320, height: 320) //5
//                                        self.scrollView.addSubview(imageView)                                   //6
//                                    }
//                                }
//                            }
//                            
//                        
//                        }
//        }) { (operation:URLSessionDataTask?, error:Error) in
//            print("Error: " + error.localizedDescription)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Search Bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            searchFlickrBy(searchString: searchText)
        }
    }


    func searchFlickrBy(searchString: String)
    {
        
        let imageWidth = self.view.frame.width
        let manager = AFHTTPSessionManager()
        let searchParameters:[String:Any] = ["method": "flickr.photos.search",
                                             "api_key": "7d69afb971370300b2a3fe358951ce74",
                                             "format": "json",
                                             "nojsoncallback": 1,
                                             "text": searchString,
                                             "extras": "url_m",
                                             "per_page": 5]
        manager.get("https://api.flickr.com/services/rest/",
                    parameters: searchParameters,
                    progress: nil,
                    success: { (operation: URLSessionDataTask, responseObject:Any?) in
                        if let responseObject = responseObject as? [String: AnyObject] {
                            print("Response: " + (responseObject as AnyObject).description)
                            if let photos = responseObject["photos"] as? [String: AnyObject] {
                                if let photoArray = photos["photo"] as? [[String: AnyObject]] {
                                    self.scrollView.contentSize = CGSize(width: imageWidth, height: imageWidth * CGFloat(photoArray.count))
                                    for (i,photoDictionary) in photoArray.enumerated() {                             //1
                                        if let imageURLString = photoDictionary["url_m"] as? String {               //2
                                            let imageData = NSData(contentsOf: URL(string: imageURLString)!)        //2
                                            if let imageDataUnwrapped = imageData {                                     //3
                                                let imageView = UIImageView(frame: CGRect(x:0, y:320*CGFloat(i), width:imageWidth, height:imageWidth))     //#1
                                                if let url = URL(string: imageURLString) {
                                                    imageView.setImageWith(url)                                             //#2
                                                    self.scrollView.addSubview(imageView)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
        }) { (operation:URLSessionDataTask?, error:Error) in
            print("Error: " + error.localizedDescription)
        }
    }

    
}

