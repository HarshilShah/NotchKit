//
//  ViewController.swift
//  NotchKitExample
//
//  Created by Harshil Shah on 16/09/17.
//  Copyright © 2017 Harshil Shah. All rights reserved.
//

import UIKit
import NotchKit

class ViewController: UIViewController {
    
    private let label = UILabel()
    private let toggle = UISwitch()
    
    private var isNotchHidden = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let topText = NSMutableAttributedString(string: "[Insert your app here]\n\n", attributes: [
            NSAttributedStringKey.font: UIFont(name: "Menlo-Bold", size: 40) as Any
        ])
        
        let switchText = NSAttributedString(string: "P.S.: Flip that switch\n\n", attributes: [
            NSAttributedStringKey.font: UIFont(name: "Menlo-Regular", size: 20) as Any
        ])
        
        topText.append(switchText)
        
        label.attributedText = topText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.safeLayoutGuideWithFallback.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: view.safeLayoutGuideWithFallback.trailingAnchor, constant: -32)
        ])
        
        toggle.addTarget(self, action: #selector(toggleWasToggled), for: .valueChanged)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toggle)
        NSLayoutConstraint.activate([
            toggle.topAnchor.constraint(equalTo: label.bottomAnchor),
            toggle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isNotchHidden ? .lightContent : .default
    }
    
    @objc private func toggleWasToggled(_ toggle: UISwitch) {
        isNotchHidden = toggle.isOn
        
        if #available(iOS 11, *) {
            (self.view.window as? NotchKitWindow)?.maskedEdges = isNotchHidden ? [.top, .left, .right] : []
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

}

