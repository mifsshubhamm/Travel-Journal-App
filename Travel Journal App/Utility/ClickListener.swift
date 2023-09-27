//
//  ClickListener.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 03/09/23.
//

import Foundation
import UIKit

// MARK: ClickListener
class ClickListener: UITapGestureRecognizer {
    var onClick : (() -> Void)? = nil
}
