//
//  NotchKitWindow.swift
//  NotchKit
//
//  Created by Harshil Shah on 16/09/17.
//  Copyright © 2017 Harshil Shah. All rights reserved.
//

import UIKit

public final class NotchKitWindow: UIWindow {
    
    // MARK:- Types
    
    public enum CornerRadius {
        case standard
        case custom(CGFloat)
    }
    
    // MARK:- Public variables
    
    /// The corner radius for the rounded view. It can be set to a custom value,
    /// or to use the standard value which sets the corner radius appropriately
    /// for the screen size
    public var cornerRadius: CornerRadius = .standard {
        didSet { updateCornerRadii() }
    }
    
    /// A Bool indicating whether bars are shown only on the iPhone X.
    ///
    /// When this property's value is true, black bars to cover the notch and
    /// the home indicator are shown only on the iPhone X.
    ///
    /// When this property's value is false, black bars and curved corners are
    /// shown on all devices
    ///
    /// The default value of this property is `false`
    public var shouldShowBarsOnlyOniPhoneX = false {
        didSet { layoutSubviews() }
    }
    
    public override var rootViewController: UIViewController? {
        didSet {
            updateRootViewController(from: oldValue, to: rootViewController)
        }
    }
    
    // MARK:- Private variables
    
    private let safeAreaInsetsKeyPath = "safeAreaInsets"
    
    private let safeView = UIView()
    
    private let topBarView = UIView()
    private let bottomBarView = UIView()
    private let leadingBarView = UIView()
    private let trailingBarView = UIView()
    
    private let topLeftCorner = CornerView()
    private let topRightCorner = CornerView()
    private let bottomLeftCorner = CornerView()
    private let bottomRightCorner = CornerView()
    
    private var barViews: [UIView] {
        return [topBarView, bottomBarView, leadingBarView, trailingBarView]
    }
    
    private var cornerViews: [CornerView] {
        return [topLeftCorner, topRightCorner, bottomLeftCorner, bottomRightCorner]
    }
    
    // MARK:- Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        addSubview(safeView)
        
        barViews.forEach { bar in
            bar.backgroundColor = .black
            bar.translatesAutoresizingMaskIntoConstraints = false
            safeView.addSubview(bar)
        }
        
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: topAnchor),
            topBarView.bottomAnchor.constraint(equalTo: safeView.topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            bottomBarView.topAnchor.constraint(equalTo: safeView.bottomAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            leadingBarView.topAnchor.constraint(equalTo: topAnchor),
            leadingBarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            leadingBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            leadingBarView.trailingAnchor.constraint(equalTo: safeView.leadingAnchor),
            
            trailingBarView.topAnchor.constraint(equalTo: topAnchor),
            trailingBarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            trailingBarView.leadingAnchor.constraint(equalTo: safeView.trailingAnchor),
            trailingBarView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        topLeftCorner.corner = .topLeft
        topRightCorner.corner = .topRight
        bottomLeftCorner.corner = .bottomLeft
        bottomRightCorner.corner = .bottomRight
        
        cornerViews.forEach { corner in
            corner.cornerRadius = 44
            corner.translatesAutoresizingMaskIntoConstraints = false
            safeView.addSubview(corner)
        }
        
        NSLayoutConstraint.activate([
            topLeftCorner.topAnchor.constraint(equalTo: safeView.topAnchor),
            topLeftCorner.leadingAnchor.constraint(equalTo: safeView.leadingAnchor),
            
            topRightCorner.topAnchor.constraint(equalTo: safeView.topAnchor),
            topRightCorner.trailingAnchor.constraint(equalTo: safeView.trailingAnchor),
            
            bottomLeftCorner.bottomAnchor.constraint(equalTo: safeView.bottomAnchor),
            bottomLeftCorner.leadingAnchor.constraint(equalTo: safeView.leadingAnchor),
            
            bottomRightCorner.bottomAnchor.constraint(equalTo: safeView.bottomAnchor),
            bottomRightCorner.trailingAnchor.constraint(equalTo: safeView.trailingAnchor)
        ])
    }
    
    deinit {
        updateRootViewController(from: rootViewController, to: nil)
    }
    
    // MARK:- UIView methods
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        bringSubview(toFront: safeView)
        updateCornerRadii()
    }
    
    // MARK:- Key value observation
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == safeAreaInsetsKeyPath,
              let view = object as? UIView,
              view.isEqual(rootViewController?.view)
        else {
            return
        }
        
        setSafeAreaInsets(view.safeAreaInsets)
    }
    
    // MARK:- Private methods
    
    private func updateCornerRadii() {
        let newCornerRadius: CGFloat = {
            if shouldShowBarsOnlyOniPhoneX && !screen.isiPhoneX {
                return 0
            }
            
            switch cornerRadius {
                
            case .standard:
                if screen.isiPhoneX {
                    return 22
                } else {
                    return 8
                }
                
            case .custom(let customValue):
                return customValue
            
            }
        }()
        
        cornerViews.forEach {
            $0.cornerRadius = newCornerRadius
        }
    }
    
    private func setSafeAreaInsets(_ insets: UIEdgeInsets) {
        let safeViewFrame: CGRect = {
            if shouldShowBarsOnlyOniPhoneX && !screen.isiPhoneX {
                return bounds
            } else {
                return bounds.insetBy(insets: insets)
            }
        }()
        
        UIView.animate(withDuration: 0.1) { [unowned self] in
            self.safeView.frame = safeViewFrame
        }
    }
    
    private func updateRootViewController(from oldValue: UIViewController?, to newValue: UIViewController?) {
        if let oldValue = oldValue {
            oldValue.view.removeObserver(self, forKeyPath: safeAreaInsetsKeyPath)
        }
        
        if let newValue = newValue {
            newValue.view.addObserver(self, forKeyPath: safeAreaInsetsKeyPath, options: [.initial], context: nil)
        }
    }
    
}

