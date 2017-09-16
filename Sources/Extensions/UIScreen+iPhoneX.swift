//
//  UIScreen+iPhoneX.swift
//  Notchless
//
//  Created by Harshil Shah on 16/09/17.
//  Copyright © 2017 Harshil Shah. All rights reserved.
//

import UIKit

extension UIScreen {
    
    var isiPhoneX: Bool {
        return nativeBounds.height == 2436
            && nativeBounds.width  == 1125 
    }
    
}
