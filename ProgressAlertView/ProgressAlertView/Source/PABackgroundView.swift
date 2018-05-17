//
//  ProgressAlertBackgroundView.swift
//  ProgressAlertView
//
//  Created by WZY on 2018/5/14.
//  Copyright © 2018年 iMac. All rights reserved.
//

import UIKit

class PABackgroundView: UIView {

    @objc dynamic var style: ProgressAlertViewBackgroundStyle = .blur {
        didSet {
            guard style != oldValue else {
                return
            }
            self.updateUI()
        }
    }
    @objc dynamic var blurEffectStyle: UIBlurEffectStyle = .light {
        didSet {
            guard blurEffectStyle != oldValue else {
                return
            }
            guard style == .blur else {
                return
            }
            self.effectView?.effect = UIBlurEffect(style: blurEffectStyle)
        }
    }
    @objc dynamic var color: UIColor = UIColor(white: 0.8, alpha: 0.6) {
        didSet {
            guard color.isEqual(oldValue) == false else {
                return
            }
            switch style {

            case .solidColor:
                self.toolBar?.barTintColor = color
            case .blur:
                self.backgroundColor = color
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.clipsToBounds = true

        updateUI()
    }

    override var intrinsicContentSize: CGSize {
        return .zero
    }

    private var effectView: UIVisualEffectView?
    private var toolBar: UIToolbar?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PABackgroundView {

    private func updateUI() {

        self.effectView?.removeFromSuperview()
        self.effectView = nil
        self.toolBar?.removeFromSuperview()
        self.toolBar = nil

        switch self.style {

        case .solidColor:
            updateSolidColorUI()
        case .blur:
            updateBlurUI()
        }
    }

    private func updateBlurUI() {

        self.backgroundColor = self.color
        self.layer.allowsGroupOpacity = false

        let blurEffect = UIBlurEffect(style: self.blurEffectStyle)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(effectView)
        self.effectView = effectView

        let toolBar = UIToolbar(frame: self.bounds.insetBy(dx: -100, dy: -100))
        toolBar.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        toolBar.barTintColor = self.color
        toolBar.isTranslucent = true
        self.addSubview(toolBar)
        self.toolBar = toolBar
    }

    private func updateSolidColorUI() {

        self.backgroundColor = self.color
    }
}
