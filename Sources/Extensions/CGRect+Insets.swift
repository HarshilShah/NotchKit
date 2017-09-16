//
//  CGRect+Insets.swift
//  Notchless
//
//  Created by Harshil Shah on 16/09/17.
//

import CoreGraphics
import UIKit

extension CGRect {
    
    /// Returns a new rectangle by moving all it's edges towards the center by a
    /// given amount
    func insetBy(insets: UIEdgeInsets) -> CGRect {
        return CGRect(x: self.origin.x + insets.left,
                      y: self.origin.y + insets.top,
                      width: self.width - (insets.left + insets.right),
                      height: self.height - (insets.top + insets.bottom))
    }
    
}

