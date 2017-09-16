//
//  NotchlessWindow.swift
//  Notchless
//
//  Created by Harshil Shah on 16/09/17.
//

import UIKit

public final class NotchlessWindow: UIWindow {
    
    public enum CornerRadius {
        case standard
        case custom(CGFloat)
    }
    
    /// The corner radius for the rounded view. It can be set to a custom value,
    /// or to use the standard value which sets the corner radius appropriately
    /// for the screen size
    public var cornerRadius: CornerRadius = .standard {
        didSet { updateCornerRadii() }
    }
    
    // MARK:- Private variables
    
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
    
    // MARK:- UIView methods
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        bringSubview(toFront: safeView)
        updateCornerRadii()
    }
    
    // MARK:- Public methods
    
    /// Sets the insets for the window
    ///
    /// This method is required because while on iPhone X the window's safeArea
    /// is adjusted to accomodate for the notch, and thus for the status bar by
    /// proxy, on older iPhones windows aren't updated for the status bar, and
    /// there is no way to be notified that the insets have even changed to
    /// trigger a manual check and update
    ///
    /// - Parameter insets: An object representing your view controller's
    ///   new `safeAreaInsets`
    public func setSafeAreaInsets(_ insets: UIEdgeInsets) {
        UIView.animate(withDuration: 0.1) { [unowned self] in
            self.safeView.frame = self.bounds.insetBy(insets: insets)
        }
    }
    
    // MARK:- Private methods
    
    private func updateCornerRadii() {
        let newCornerRadius: CGFloat = {
            switch cornerRadius {
                
            case .standard:
                /// iPhone X gets a larger corner radius by default. There are
                /// probably better ways to check this, but this works for now
                /// and also doesn't trigger for split-view iPads, so why not
                if screen.nativeBounds.height == 2436 && screen.nativeBounds.width == 1125 {
                    return 44
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
    
}

