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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        label.text = "[Insert your app here]"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Menlo-Bold", size: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
