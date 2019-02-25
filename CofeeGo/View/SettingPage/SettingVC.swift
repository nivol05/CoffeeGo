//
//  SettingVC.swift
//  CofeeGo
//
//  Created by NI Vol on 10/3/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import SimplePDF
import ExpandableLabel
import ReadMoreTextView
import MessageUI
import PopupDialog

class SettingVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var supportBgView: UIView!
    @IBOutlet weak var childSupportBgView: UIView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    
    
    let instUrl = "https://www.instagram.com/coffee.go/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRatio(view: supportBgView, ratio: 5, shadow: false)
        cornerRatio(view: childSupportBgView, ratio: 5, shadow: false)
        
        if header != nil{
            userNameLbl.text = current_coffee_user.first_name!
            userEmailLbl.text = current_coffee_user.username!
        } else {
            userNameLbl.text = "Имя"
            userEmailLbl.text = "Почта"
        }
        
    }
    
    func showStandardDialog(animated: Bool = true , tag : Int) {
        
        // Prepare the popup
        let title = ""
        let message = "Вы уверены, что хотите выйти?"
        
        // Create the dialog
        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                tapGestureDismissal: true,
                                panGestureDismissal: true,
                                hideStatusBar: true) {
                                    print("Completed")
        }
        
        // Create first button
        let buttonOne = CancelButton(title: "Нет") {
            
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "Да") {
            let database = Database()
            database.delUser()
            
            header = [
                "Authorization" : ""
            ]
            
            isOrdered = false
            
            setNotifsEnabled(enabled: false)
            // LOAD PROGRAMME AGAIN
            self.performSegue(withIdentifier: "logOut", sender: nil)
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }
    @IBAction func coffeeGoSupportBtn(_ sender: Any) {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["contact.coffee.go@gmail.com"])
        composeVC.setSubject("Coffee Go Feedback")
//        composeVC.setMessageBody("Message content.", isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func coffeeGoWebBtn(_ sender: Any) {
        guard let url = URL(string: BASE_URL)  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func coffeeGoInstBtn(_ sender: Any) {
        guard let url = URL(string: instUrl)  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        showStandardDialog(tag: (sender as AnyObject).tag)
    }

}
