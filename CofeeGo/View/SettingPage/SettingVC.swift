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

class SettingVC: UIViewController {
    @IBOutlet weak var textView: ReadMoreTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = "Lorem http://ipsum.com dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        
        textView.shouldTrim = true
        textView.maximumNumberOfLines = 4
        textView.attributedReadMoreText = NSAttributedString(string: "... Read more")
        textView.attributedReadLessText = NSAttributedString(string: " Read less")
//        pdf()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func pdf(){
        
        let A4paperSize = CGSize(width: 595, height: 842)
        let pdf = SimplePDF(pageSize: A4paperSize, pageMargin: 20.0)
        // or define all margins extra
//        let pdf = SimplePDF(pageSize: A4paperSize, pageMarginLeft: 35, pageMarginTop: 50, pageMarginBottom: 40, pageMarginRight: 35)
        
        pdf.addText( "Отчет 1" )
        pdf.addLineSeparator()

        pdf.addText( "      запулка" )
        pdf.addLineSeparator()
        
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            
            let fileName = "example.pdf"
            let documentsFileName = documentDirectories + "/" + fileName
            
            let pdfData = pdf.generatePDFdata()
            do{
                try pdfData.write(to: URL(fileURLWithPath: documentsFileName), options: .atomic)
                print("\nThe generated pdf can be found at:")
                print("\n\t\(documentsFileName)\n")
            }catch{
                print(error)
            }
        }
    }

}
