//
//  UIView+SafeLayoutGuideWithFallback.swift
//  NotchKitExample
//
//  Created by Harshil Shah on 30/09/17.
//  Copyright © 2017 Harshil Shah. All rights reserved.
//

import UIKit

extension UIView {
    
    var safeLayoutGuideWithFallback: UILayoutGuide {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide
        } else {
            return layoutMarginsGuide
        }
    }
    
}
