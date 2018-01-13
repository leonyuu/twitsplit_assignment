//
//  TwitAddPostView.swift
//  twitsplit
//
//  Created by Leon Yuu on 1/13/18.
//  Copyright © 2018 Leon Yuu. All rights reserved.
//

import UIKit

class TwitAddPostView: UIView {
    
    var numInputText:UILabel!
    var inputTextField:UITextView!
    var cancelBtn:UIButton!
    var confirmBtn:UIButton!
    var cancelHandler:() -> Void = {}
    var confirmHandler:() -> Void = {}
    let aninationTime:TimeInterval = 0.3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLayout() {
        
        // Set Background for View
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        // Dismiss view when touch on screen
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(dismissView))
        tapRecognizer.cancelsTouchesInView = true
        self.addGestureRecognizer(tapRecognizer)
        
        // Add Content View
        let contentWidth = self.frame.size.width * (560.0/640.0)
        let contentHeight = contentWidth * (300.0/400.0)
        let margin = (self.frame.size.width - contentWidth)/2.0
        let contentView = UIView(frame: CGRect(x: margin,
                                               y: margin,
                                               width: contentWidth,
                                               height: contentHeight))
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = UIColor.white
        contentView.clipsToBounds = true
        self.addSubview(contentView)
        
        // Add Text Label
        numInputText = UILabel(frame: CGRect(x: 0,
                                          y: 0,
                                          width: contentView.frame.size.width,
                                          height: 25))
        numInputText.backgroundColor = UIColor.clear
        numInputText.textColor = UIColor.darkGray
        numInputText.font = UIFont.systemFont(ofSize: 14)
        numInputText.numberOfLines = 3
        numInputText.textAlignment = .center
        numInputText.text = "0"
        contentView.addSubview(numInputText)
        
        // Add Input Text Field
        inputTextField = UITextView(frame: CGRect(x: 8,
                                                  y: numInputText.frame.origin.y +
                                                     numInputText.frame.size.height,
                                                  width: contentWidth - 16,
                                                  height: contentHeight - numInputText.frame.size.height - contentWidth * (60.0/360)))
        inputTextField.textColor = UIColor.darkGray
        inputTextField.font = UIFont.systemFont(ofSize: 15)
        inputTextField.keyboardType = UIKeyboardType.twitter
        contentView.addSubview(inputTextField)
        
        // Add Button View
        let btnViewWidth = contentWidth
        let btnViewHeight = btnViewWidth * (60.0/360)
        let btnView = UIView(frame: CGRect(x: 0,
                                           y: (contentView.frame.size.height - btnViewHeight),
                                           width: btnViewWidth,
                                           height: btnViewHeight))
        btnView.backgroundColor = UIColor.clear
        btnView.clipsToBounds = true
        contentView.addSubview(btnView)
        
        // Add Cancel Button
        cancelBtn = UIButton(frame: CGRect(x: 0,
                                               y: 0,
                                               width: btnViewWidth/2.0,
                                               height: btnViewHeight))
        cancelBtn.backgroundColor = UIColor.clear
        cancelBtn.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
        cancelBtn.setTitleColor(UIColor.gray, for:.normal)
        cancelBtn.setTitleColor(UIColor.darkGray, for: .highlighted)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btnView.addSubview(cancelBtn)
        
        // Add Confirm Button
        confirmBtn = UIButton(frame: CGRect(x: btnViewWidth/2.0,
                                               y: 0,
                                               width: btnViewWidth/2.0,
                                               height: btnViewHeight))
        confirmBtn.backgroundColor = UIColor.clear
        confirmBtn.addTarget(self, action: #selector(tapConfirm), for: .touchUpInside)
        confirmBtn.setTitleColor(UIColor.init(red: 67.0/255, green: 193.0/255, blue: 235.0/255, alpha: 1), for: .normal)
        confirmBtn.setTitleColor(UIColor.darkGray, for: .highlighted)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btnView.addSubview(confirmBtn)
        
        // Add Sub Divide Lines
        let topline = UIView(frame: CGRect(x: 0,
                                           y: 0,
                                           width: btnViewWidth,
                                           height: 0.5))
        topline.backgroundColor = UIColor.gray
        btnView.addSubview(topline)
        
        let divideline = UIView(frame: CGRect(x: btnViewWidth/2.0,
                                              y: 0,
                                              width: 0.5,
                                              height: btnViewHeight))
        divideline.backgroundColor = UIColor.gray
        btnView.addSubview(divideline)
        
    }
    
    func showViewinSuperView(_ superview:UIView) {
        if self.superview == nil {
            superview.addSubview(self)
        } else {
            superview.bringSubview(toFront: self)
        }
        
        self.isHidden = true
        
        UIView.transition(with: self,
                          duration: aninationTime,
                          options: UIViewAnimationOptions.transitionCrossDissolve,
                          animations: {
                            self.isHidden = false
                            
        }) { (completed) in
            // Completed Transition
        }
    }
    
    @objc func dismissView() {
        UIView.transition(with: self,
                          duration: aninationTime,
                          options: UIViewAnimationOptions.transitionCrossDissolve,
                          animations: {
                            self.isHidden = true
                            
        }) { (completed) in
            // Completed Transition
        }
    }
    
    func setContentDialog(_ cancelText:String?,
                          _ confirmText:String?,
                           cancelHandler:@escaping () -> Void,
                           confirmHandler:@escaping () -> Void) {
        
        // Reset Num of Input and Input Text Field
        numInputText.text = "0"
        inputTextField.text = ""
        
        cancelBtn.setTitle(cancelText, for: .normal)
        confirmBtn.setTitle(confirmText, for: .normal)
        
        self.cancelHandler = cancelHandler
        self.confirmHandler = confirmHandler
    }
    
    func dismissKeyBoard() {
        self.endEditing(true)
    }
    
    @objc func tapCancel() {
        dismissKeyBoard()
        cancelHandler()
    }
    
    @objc func tapConfirm() {
        dismissKeyBoard()
        confirmHandler()
    }
    
}

extension TwitAddPostView:UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
}
