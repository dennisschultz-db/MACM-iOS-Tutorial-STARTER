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
import Shimmer

let kCAASDidSignIn = "CAASDidSignIn"

class SignInController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var hairLine: HairLine!
    
    
    @IBOutlet weak var fbShimmeringView: FBShimmeringView!
    
    @IBOutlet weak var caas: UILabel!
    @IBOutlet weak var heightShimmerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var widthShimmerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shimmeringViewVerticalSpacing: NSLayoutConstraint!
    private var shimmeringViewVerticalCenter:NSLayoutConstraint!
    
    var fieldWithFocus:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        updatePlaceholderColor(username)
        updatePlaceholderColor(password)
        
        let label = caas
        caas.removeFromSuperview()
        
        fbShimmeringView.contentView = label
        fbShimmeringView.backgroundColor = UIColor.clearColor()
        self.widthShimmerConstraint.constant = caas.bounds.width
        self.heightShimmerConstraint.constant = caas.bounds.height
        
        shimmeringViewVerticalCenter = NSLayoutConstraint(item:self.fbShimmeringView!,
            attribute:.CenterY,
            relatedBy:.Equal,
            toItem:self.view!,
            attribute:.CenterY,
            multiplier:1, constant:0)
        

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        self.view.addGestureRecognizer(gestureRecognizer)
        
        // Do any additional setup after loading the view.
    }

    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            if self.fieldWithFocus != nil {
                self.fieldWithFocus.resignFirstResponder()
                self.fieldWithFocus = nil
            }
            // handling code
        }
    }
    
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
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func updatePlaceholderColor(textField:UITextField) {
        
        let placeholderText = textField.placeholder
        if placeholderText != nil {
            let placeholderColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText!, attributes: [NSForegroundColorAttributeName: placeholderColor])
                
                
            
        }
    }
}

extension SignInController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField:UITextField) {
        
        self.fieldWithFocus = textField
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidChange:", name: UITextFieldTextDidChangeNotification, object: textField)
        
    }
    func textFieldDidEndEditing(textField:UITextField) {
        self.fieldWithFocus = nil
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: textField)
        
    }
    func textFieldDidChange(note:NSNotification) {
        
    }
    
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        
        if self.username.text?.isEmpty ?? true {
            self.username.becomeFirstResponder()
            return false
        }
        
        if self.password.text?.isEmpty ?? true {
            self.password.becomeFirstResponder()
            return false
        }
        
        if textField == self.username {
            self.password.becomeFirstResponder()
        }
        else {
            self.doSignIn()
        }
        
        return false
    }
    
    func doSignIn() {
        
        if (self.username.text?.isEmpty ?? true) || (self.password.text?.isEmpty ?? true) {
            return
        }
        
        if self.fieldWithFocus != nil {
            self.fieldWithFocus.resignFirstResponder()
            self.fieldWithFocus = nil
        }
        
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.username.alpha = 0
            self.password.alpha = 0
            self.hairLine.alpha = 0
            
            self.view.removeConstraint(self.shimmeringViewVerticalSpacing)
            self.view.addConstraint(self.shimmeringViewVerticalCenter)
            
            //self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
        
        fbShimmeringView.shimmering = true
        fbShimmeringView.shimmeringOpacity = 0.1
        
        self.checkUser()
        
    }
    

    //TODO: CAAS Tutorial:: replace func checkUser
    // >>>>>> Start cut
    func checkUser() {
        // Override point for customization after application launch.
        
        NSNotificationCenter.defaultCenter().postNotificationName(kCAASDidSignIn, object: self)
        AppDelegate.goInitialController()
    }
    // >>>>>> End cut

}


