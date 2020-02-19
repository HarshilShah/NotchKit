//
//  NotchKitWindow.swift
//  NotchKit
//
//  Created by Harshil Shah on 16/09/17.
//  Copyright © 2017 Harshil Shah. All rights reserved.
//

import UIKit

@available(iOS 11, *)
open class NotchKitWindow: UIWindow {
    
    // MARK:- Types
    
    public enum CornerRadius {
        case standard
        case custom(CGFloat)
    }
    
    // MARK:- Public variables
    
    /// The edges of the screen to be masked
    ///
    /// Each of the edges works as follows:
    /// - `.top`: Shows a bar underneath the status bar on all iPhones and iPads.
    ///   This is the only property applicable to all devices; the remaining
    ///   3 apply only to iPhone X
    /// - `.left`: Shows a bar along the left edge of the screen when in
    ///   landscape orientation. Only applicable for iPhone X
    /// - `.right`: Shows a bar along the right edge of the screen when in
    ///   landscape orientation. Only applicable for iPhone X
    /// - `.bottom`: Shows a bar underneath the home indicator regardless of
    ///   orientation. Only applicable for iPhone X
    ///
    /// The default value of this property is `.all`
    @objc open var maskedEdges: UIRectEdge = .all {
        didSet { updateSafeAreaInsets(animated: true) }
    }
    
    /// The corner radius for the rounded view. It can be set to a custom value,
    /// or to use the standard value which sets the corner radius appropriately
    /// for the screen size
    open var cornerRadius: CornerRadius = .standard {
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
    @objc open var shouldShowBarsOnlyOniPhoneX = false {
        didSet { layoutSubviews() }
    }
    
    open override var rootViewController: UIViewController? {
        didSet {
            updateRootViewController(from: oldValue, to: rootViewController)
        }
    }
    
    // MARK:- Private variables
    
    private let safeAreaInsetsKeyPath = "safeAreaInsets"
    
    private var isiPhoneX: Bool {
        return screen.nativeBounds.size == CGSize(width: 1125, height: 2436)
    }
    
    // MARK:- View hierarchy
    
    private let safeView = UIView()
    
    private let topBarView = UIView()
    private let leftBarView = UIView()
    private let rightBarView = UIView()
    private let bottomBarView = UIView()
    
    private let topLeftCorner = CornerView()
    private let topRightCorner = CornerView()
    private let bottomLeftCorner = CornerView()
    private let bottomRightCorner = CornerView()
    
    private var barViews: [UIView] {
        return [topBarView, leftBarView, rightBarView, bottomBarView]
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
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    @available(iOS 13, *)
    public override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        setup()
    }
    
    private func setup() {
        safeView.isUserInteractionEnabled = false
        addSubview(safeView)
        
        barViews.forEach { bar in
            bar.backgroundColor = .black
            bar.translatesAutoresizingMaskIntoConstraints = false
            safeView.addSubview(bar)
        }
        
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: topAnchor),
            topBarView.bottomAnchor.constraint(equalTo: safeView.topAnchor),
            topBarView.leftAnchor.constraint(equalTo: leftAnchor),
            topBarView.rightAnchor.constraint(equalTo: rightAnchor),
            
            leftBarView.topAnchor.constraint(equalTo: topAnchor),
            leftBarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftBarView.leftAnchor.constraint(equalTo: leftAnchor),
            leftBarView.rightAnchor.constraint(equalTo: safeView.leftAnchor),
            
            rightBarView.topAnchor.constraint(equalTo: topAnchor),
            rightBarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightBarView.leftAnchor.constraint(equalTo: safeView.rightAnchor),
            rightBarView.rightAnchor.constraint(equalTo: rightAnchor),
            
            bottomBarView.topAnchor.constraint(equalTo: safeView.bottomAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBarView.leftAnchor.constraint(equalTo: leftAnchor),
            bottomBarView.rightAnchor.constraint(equalTo: rightAnchor)
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
            topLeftCorner.leftAnchor.constraint(equalTo: safeView.leftAnchor),
            
            topRightCorner.topAnchor.constraint(equalTo: safeView.topAnchor),
            topRightCorner.rightAnchor.constraint(equalTo: safeView.rightAnchor),
            
            bottomLeftCorner.bottomAnchor.constraint(equalTo: safeView.bottomAnchor),
            bottomLeftCorner.leftAnchor.constraint(equalTo: safeView.leftAnchor),
            
            bottomRightCorner.bottomAnchor.constraint(equalTo: safeView.bottomAnchor),
            bottomRightCorner.rightAnchor.constraint(equalTo: safeView.rightAnchor)
        ])
    }
    
    deinit {
        updateRootViewController(from: rootViewController, to: nil)
    }
    
    // MARK:- UIView methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        bringSubview(toFront: safeView)
        updateCornerRadii()
        updateSafeAreaInsets()
    }
    
    // MARK:- Key value observation
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == safeAreaInsetsKeyPath,
              let view = object as? UIView,
              view.isEqual(rootViewController?.view)
        else {
            return
        }
        
        updateSafeAreaInsets()
    }
    
    // MARK:- Private methods
    
    private func updateCornerRadii() {
        let newCornerRadius: CGFloat = {
            if shouldShowBarsOnlyOniPhoneX && !isiPhoneX {
                return 0
            }
            
            switch cornerRadius {
                
            case .standard:
                if isiPhoneX {
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
    
    private func updateSafeAreaInsets(animated: Bool = false) {
        guard let insets = rootViewController?.view.safeAreaInsets else {
            return
        }
        
        let finalInsets = UIEdgeInsets(
            top:    maskedEdges.contains(.top)    ? insets.top    : 0,
            left:   maskedEdges.contains(.left)   ? insets.left   : 0,
            bottom: maskedEdges.contains(.bottom) ? insets.bottom : 0,
            right:  maskedEdges.contains(.right)  ? insets.right  : 0)
        
        let safeViewFrame: CGRect = {
            if shouldShowBarsOnlyOniPhoneX && !isiPhoneX {
                return bounds
            } else {
                return bounds.insetBy(insets: finalInsets)
            }
        }()
        
        let duration = animated ? 0.3 : 0
        
        UIView.animate(withDuration: duration) { [unowned self] in
            self.safeView.frame = safeViewFrame
            self.safeView.layoutIfNeeded()
        }
    }
    
    private func updateRootViewController(from oldValue: UIViewController?, to newValue: UIViewController?) {
        oldValue?.view.removeObserver(self, forKeyPath: safeAreaInsetsKeyPath)
        newValue?.view.addObserver(self, forKeyPath: safeAreaInsetsKeyPath, options: [.initial], context: nil)
    }
    
}

