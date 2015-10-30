/*
********************************************************************
* Licensed Materials - Property of IBM                             *
*                                                                  *
* Copyright IBM Corp. 2015 All rights reserved.                    *
*                                                                  *
* US Government Users Restricted Rights - Use, duplication or      *
* disclosure restricted by GSA ADP Schedule Contract with          *
* IBM Corp.                                                        *
*                                                                  *
* DISCLAIMER OF WARRANTIES. The following [enclosed] code is       *
* sample code created by IBM Corporation. This sample code is      *
* not part of any standard or IBM product and is provided to you   *
* solely for the purpose of assisting you in the development of    *
* your applications. The code is provided "AS IS", without         *
* warranty of any kind. IBM shall not be liable for any damages    *
* arising out of your use of the sample code, even if they have    *
* been advised of the possibility of such damages.                 *
********************************************************************
*/


import UIKit
import CAASObjC

class CoverController: UIViewController {
    
    @IBOutlet weak var cover: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var book:Book!{
        didSet {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        /*
        self.cover.layer.borderWidth = 1/UIScreen.mainScreen().scale
        self.cover.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.cover.layer.cornerRadius = 4
        self.cover.backgroundColor = UIColor.lightGrayColor()
        */
        
        if let coverURLString = book.cover {

            //TODO: CAAS Tutorial:: Replace imageHostBaseURL
            let imageHostBaseURL = NSURL(string: "https://upload.wikimedia.org")

            let imageURL = NSURL(
                string: coverURLString,
                relativeToURL: imageHostBaseURL)
            
            // check of the image is already in the cache
            if let image = imageCache?.objectForKey(imageURL!.absoluteString) as? UIImage {
                self.cover.image = image
                self.cover.setNeedsLayout()
                self.cover.layoutIfNeeded()
                
            } else {
                downloadImage(imageURL)
                
            }
            
        } else {
            self.cover.hidden = true
        }
    }
    
    
    
//TODO: CAAS Tutorial:: Replace func downloadImage
// >>>>>> Start cut
    /**
        Download an image from the given URL on the internet
    
        @param imageURL  the URL of the image to be downloaded
    */
    func downloadImage(imageURL: NSURL?) {
        self.cover.hidden = true
        // Execute a request for getting an image
        self.activityIndicator.startAnimating()
        
        let request: NSURLRequest = NSURLRequest(URL: imageURL!)
        let mainQueue = NSOperationQueue.mainQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
            if error == nil {
                // Convert the downloaded data in to a UIImage object
                if let image = UIImage(data: data!) {
                    self.cover.image = image
                    self.cover.hidden = false
                    
                    self.activityIndicator.stopAnimating()
                    
                    // Store the image in to our cache
                    imageCache?.setObject(image, forKey: imageURL!.absoluteString)
                }
            }
            else {
                print("Error: \(error!.localizedDescription)")
            }
        })
        
    }
// >>>>>> End cut
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
