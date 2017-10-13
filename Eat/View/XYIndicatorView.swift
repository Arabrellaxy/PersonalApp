//
//  XYIndicatorView.swift
//  Eat
//
//  Created by 谢艳 on 2017/10/11.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import UIKit

public enum XYIndicatorType:Int{
    case pacman
    case orbit
    case ballScaleMultiple
    
    static let allTypes = (pacman.rawValue ... ballScaleMultiple.rawValue).map { XYIndicatorType(rawValue: $0)! }
    func animation() -> XYActivityIndicatorAnimationDelegate {
        switch self {
        case .pacman:
            return XYActivityIndicatorAnimationPacman()
        default:
            return XYActivityIndicatorAnimationPacman()
        }
    }
}

class XYIndicatorView: UIView {
    public static var DEFAULT_TYPE: XYIndicatorType = .pacman

    public static var DEFAULT_COLOR = UIColor.orange

    public var type: XYIndicatorType = XYIndicatorView.DEFAULT_TYPE
    
    public var color: UIColor = XYIndicatorView.DEFAULT_COLOR

    public var animation:Bool {return isAnimating}
    
    private(set) public var isAnimating:Bool = false
    
    public  init(frame: CGRect,type:XYIndicatorType? = nil,color:UIColor? = nil) {
        self.type = type ?? XYIndicatorView.DEFAULT_TYPE
        self.color = color ?? XYIndicatorView.DEFAULT_COLOR
        super.init(frame: frame)
        isHidden = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public final func startAnimating() {
        isHidden = false
        isAnimating = true
        layer.speed = 1
        setupAnimation()
    }

    public final func stopAnimating() {
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
    }

    private final func setupAnimation() {
        let animation:XYActivityIndicatorAnimationDelegate = type.animation()
        var animationRect = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake((frame.size.height - 60) / 2, (frame.size.width - 60) / 2, (frame.size.height - 60) / 2, (frame.size.width - 60) / 2))
        let minEdge = min(animationRect.width, animationRect.height)
        
        layer.sublayers = nil
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        animation.setupAnimation(in: layer, size: animationRect.size, color: color)
    }
}
