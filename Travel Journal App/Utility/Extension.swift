//
//  Extension.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 17/08/23.
//

import Foundation
import UIKit


// MARK: - UIView
extension UIView {
    
    // This function is use for providing corner Radius and border color
    func textFieldBackgourndView () {
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(named: AppColorConstant.colorCACBD2)?.cgColor
    }
    
    // This function is use for providing shadow
    func addShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
    }
    
    func radius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
    }
    
    func topRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
    func makeDashedBorder()  {
        let mViewBorder = CAShapeLayer()
        mViewBorder.fillColor = UIColor(named: AppColorConstant.BlueColor_50)?.cgColor
        mViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(mViewBorder)
    }
    
    func setOnClickListener(action :@escaping () -> Void) {
        let tapRecogniser = ClickListener(target: self, action: #selector(onViewClicked(sender:)))
        tapRecogniser.onClick = action
        self.addGestureRecognizer(tapRecogniser)
    }
    
    @objc func onViewClicked(sender: ClickListener) {
        if let onClick = sender.onClick {
            onClick()
        }
    }
}



// MARK: - UIViewController
extension UIViewController {
    
    static let thisActivityIndicator = UIActivityIndicatorView()
    
    func startIndicatingActivity() {
        DispatchQueue.main.async {
            self.view.addSubview(UIViewController.thisActivityIndicator)
            UIViewController.thisActivityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            UIViewController.thisActivityIndicator.style = .large
            UIViewController.thisActivityIndicator.color = .lightGray
            UIViewController.thisActivityIndicator.center = self.view.center
            UIViewController.thisActivityIndicator.startAnimating()
        }
    }
    
    func stopIndicatingActivity() {
        DispatchQueue.main.async {
            UIViewController.thisActivityIndicator.removeFromSuperview()
            UIViewController.thisActivityIndicator.stopAnimating()
        }
    }
    
    func singleButtonAlertbox(_ title:String, _ message:String, _ buttonText:String, _ whenClicked: @escaping () -> ()) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertAction.Style.default){ action in
            whenClicked()
        })
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func hideNavigationBar() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func showNavigationBar() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func initKeyborad() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }
        // check if the top of the keyboard is above the bottom of the currently focused textbox
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
        
        // if textField bottom is below keyboard bottom - bump the frame up
        if textFieldBottomY > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            view.frame.origin.y = newFrameY
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }
    
}

// MARK: - UIResponder
extension UIResponder {
    
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc private func _trap() {
        Static.responder = self
    }
}

// MARK: - UITextField
extension UITextField {
    
    // This function is use for provide to text field left padding
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    // This function is use for provide to text field right padding
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func disableSpaceKey(_ enterLetter: String) -> Bool {
        return enterLetter != " "
    }
    
    func disableNumberKey(_ enterLetter: String) -> Bool {
        return enterLetter != "0" && enterLetter != "1" && enterLetter != "2" && enterLetter != "3" && enterLetter != "4" && enterLetter != "5" && enterLetter != "6" && enterLetter != "7" && enterLetter != "8" && enterLetter != "9"
    }
    
    func passwordMaxLength(_ enterLetter: String, _ range: NSRange) -> Bool {
        let length = (self.text?.utf16.count ?? 0) + enterLetter.utf16.count - range.length
        return length < AppValueConstant.passwordMaxCount
    }
    
}

// MARK: - String?
extension String? {
    
    func isNilorEmpty() -> Bool {
        return (self ?? "").isEmpty
    }
    
    func isNotNilorEmpty() -> Bool {
        return !((self ?? "").isEmpty)
    }
    
    func isValidUserName() -> Bool {
        let test = NSPredicate(format:AppValueConstant.selfMatchesFormat, AppValueConstant.regEx)
        return test.evaluate(with: self)
    }
    
    func isValidMobileNumber() -> Bool {
        return (self ?? "").count == AppValueConstant.mobileNumberMaxCount
    }
    
    func isValidEmail() -> Bool {
        let emailPred = NSPredicate(format:AppValueConstant.selfMatchesFormat, AppValueConstant.emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        return NSPredicate(format:AppValueConstant.selfMatchesFormat, AppValueConstant.passwordRegex).evaluate(with: self)
    }
    
    func toInt() -> Int? {
        if self.isNilorEmpty() {
            return nil
        } else {
            return Int(self!)
        }
    }
}

//MARK: UIImageView
extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
