//
//  PaddingTextField.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 17/08/23.
//

import UIKit

class PaddingTextField: UITextField {
    
    //MARK: Variable
    private var paddingTop: CGFloat = 0
    private var paddingLeft: CGFloat  = 0
    private var paddingBottom: CGFloat  = 0
    private var paddingRight: CGFloat  = 0
    
    //MARK: preDefine fuction
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: setPadding())
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: setPadding())
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: setPadding())
    }
    
    //MARK: Inspectable
    @IBInspectable
    var setPLeft: CGFloat {
        set { paddingLeft = newValue }
        get { return paddingLeft }
    }
    
    @IBInspectable
    var setPRight: CGFloat {
        set { paddingRight = newValue }
        get { return paddingRight }
    }
    
    @IBInspectable
    var setPTop: CGFloat {
        set { paddingTop = newValue }
        get { return paddingTop}
    }
    
    @IBInspectable
    var setPBottom: CGFloat {
        set { paddingBottom = newValue }
        get { return paddingBottom }
    }
    
    //MARK: set Padding
    func setPadding() -> UIEdgeInsets {
        UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
    }
}
