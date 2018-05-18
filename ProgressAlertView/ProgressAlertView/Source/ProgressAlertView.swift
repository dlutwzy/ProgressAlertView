//
//  ProgressAlertViewDelegate.swift
//  ProgressAlertView
//
//  Created by iMac on 2018/5/14.
//  Copyright © 2018年 iMac. All rights reserved.
//

import Foundation

@objc
protocol ProgressAlertViewDelegate {

    @objc optional
    func alertViewDidHidden(alertView: ProgressAlertView)
}

extension ProgressAlertView {

    convenience init(showAlertView inView: UIView, animated: Bool) {

        self.init(view: inView)

        self.isRemoveFromSuperViewWhenHide = true
        inView.addSubview(self)
        self.showAlertView(animated: animated)
    }

    convenience init(hideAlertView inView: UIView, animated: Bool) {

        self.init(view: inView)

        self.isRemoveFromSuperViewWhenHide = true
        self.hideAlertView(animated: animated)
    }
}

extension ProgressAlertView {

    private func showAlertView(animated: Bool) {

        self.minShowTimer?.invalidate()
        self.useAnimation = animated
        self.isFinished = false

        if self.graceTimeInterval > 0.0 {
            let timer = Timer(timeInterval: self.graceTimeInterval,
                                    target: self,
                                    selector: #selector(graceTimerHandle),
                                    userInfo: nil,
                                    repeats: false)
            RunLoop.current.add(timer, forMode: .commonModes)
            self.graceTimer = timer
        } else {
            self.show(animated: self.useAnimation)
        }
    }

    private func hideAlertView(animated: Bool) {

        self.graceTimer?.invalidate()
        self.useAnimation = animated
        self.isFinished = true

        if self.minShowTimeInterval > 0.0 && self.shownDate != nil {
            let timeInterval = NSDate().timeIntervalSince(self.shownDate!)
            if timeInterval < self.minShowTimeInterval {
                let timer = Timer(timeInterval: self.minShowTimeInterval - timeInterval,
                                  target: self,
                                  selector: #selector(minShowTimerHandle),
                                  userInfo: nil,
                                  repeats: false)
                RunLoop.current.add(timer, forMode: .commonModes)
                self.minShowTimer = timer

                return
            }
        }

        self.hide(animated: self.useAnimation)
    }

    @objc
    private func graceTimerHandle() {
        if self.isFinished == false {
            self.show(animated: self.useAnimation)
        }
    }

    @objc
    private func minShowTimerHandle() {
        self.hide(animated: self.useAnimation)
    }

    private func show(animated: Bool) {
        self.bezelView.layer.removeAllAnimations()
        self.backgroundView.layer.removeAllAnimations()

        self.hideDelayTimer?.invalidate()

        self.shownDate = Date()
        self.alpha = 1.0

        self.isProgressDisplayerLinkEnable = true

        if animated {
            self.animate(animateIn: true, type: self.animationType, completion: nil)
        } else {
            self.bezelView.alpha = 1.0
            self.backgroundView.alpha = 1.0
        }
    }

    private func hide(animated: Bool) {
        self.hideDelayTimer?.invalidate()
        if animated && self.shownDate != nil {
            self.shownDate = nil
            self.animate(animateIn: false, type: self.animationType) { [weak self] (finished) in
                self?.done()
            }
        }
    }

    private func animate(animateIn: Bool,
                         type: ProgressAlertViewAnimation,
                         completion: ((Bool) -> Void)?) {

        let type = (type == .zoom ? (animateIn ? .zoomIn : .zoomOut) : type)

        let small = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let large = CGAffineTransform(scaleX: 1.5, y: 1.5)

        if animateIn && self.bezelView.alpha == 0.0 {
            if type == .zoomIn {
                bezelView.transform = small
            } else if type == .zoomOut {
                bezelView.transform = large
            }
        }

        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.0,
                       options: .beginFromCurrentState,
                       animations: { [weak self] in
                            if animateIn {
                                self?.bezelView.transform = CGAffineTransform.identity
                            } else {
                                if type == .zoomIn {
                                    self?.bezelView.transform = large
                                } else if type == .zoomOut {
                                    self?.bezelView.transform = small
                                }
                            }

                            let alpha: CGFloat = animateIn ? 1.0 : 0.0
                            self?.bezelView.alpha = alpha
                            self?.backgroundView.alpha = alpha
                        },
                       completion: completion)
    }

    private func done() {

        self.isProgressDisplayerLinkEnable = false
        if self.isFinished {
            self.alpha = 0.0
            if self.isRemoveFromSuperViewWhenHide {
                self.removeFromSuperview()
            }
        }
        self.completionBlock?()
        self.delegate?.alertViewDidHidden?(alertView: self)
    }
}

extension ProgressAlertView {
    private func initializeUI() {

    }

    private func updateIndicator() {
        switch self.style {

        case .indicator:
            if self.indicator.isKind(of: UIActivityIndicatorView.self) == false {
                self.indicator.removeFromSuperview()
                self.indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
                self.bezelView.addSubview(self.indicator)
            }
        case .horizontalProgressBar:
            self.indicator.removeFromSuperview()
            self.indicator = PABarProgressView(frame: .zero)
            self.bezelView.addSubview(indicator)
        case .determinate:
            if self.indicator.isKind(of: PARoundProgressView.self) == false {
                self.indicator.removeFromSuperview()
                self.indicator = PARoundProgressView(frame: .zero)
                self.bezelView.addSubview(indicator)
            }
        case .annularDeterminate:
            if self.indicator.isKind(of: PARoundProgressView.self) == false {
                self.indicator.removeFromSuperview()
                self.indicator = PARoundProgressView(frame: .zero)
                self.bezelView.addSubview(indicator)
            }
            (self.indicator as? PARoundProgressView)?.isAnnular = true
        case .customView:
            if self.customView == self.indicator {}
        case .textOnly:
            <#code#>
        }
    }
}

class ProgressAlertView: UIView {
    typealias CompletionBlock = () -> Void

    @objc dynamic var contentColor: UIColor? {
        didSet {
            if contentColor != oldValue &&
                contentColor?.isEqual(oldValue) == false {

            }
        }
    }
    @objc dynamic var animationType: ProgressAlertViewAnimation = .fade
    @objc dynamic var offset: CGPoint = .zero
    @objc dynamic var margin: CGFloat = 0.0
    @objc dynamic var minSize: CGSize = .zero
    @objc dynamic var isSquare: Bool = true
    @objc dynamic var isMotionEffectsEnabled: Bool = false {
        didSet {
            if isMotionEffectsEnabled != oldValue {
                self.updateBezelMontionEffects()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUI()
    }

    var progress: Double = 0.0
    var progressObject: Progress?
    lazy var bezelView: UIView = { return PABackgroundView(frame: .zero) }()
    lazy var backgroundView: UIView = { return PABackgroundView(frame: .zero) }()
    var customView: UIView? {
        didSet {
            guard self.style == .customView else {
                return
            }
        }
    }
    lazy var label: UILabel = { return UILabel(frame: .zero) }()
    lazy var detailsLabel: UILabel = { return UILabel(frame: .zero) }()
    lazy var button: UIButton = { return UIButton(frame: .zero) }()

    weak var delegate: ProgressAlertViewDelegate?
    var style: ProgressAlertViewStyle = .indicator {
        didSet {
            if self.style != oldValue {
                self
            }
        }
    }
    var completionBlock: CompletionBlock?
    var graceTimeInterval: TimeInterval = 0.0
    var minShowTimeInterval: TimeInterval = 0.0
    var isRemoveFromSuperViewWhenHide: Bool = true

    private var activityIndicatorColor: UIColor?
    private var opacity: CGFloat = 0.0

    private var useAnimation: Bool = true
    var isFinished: Bool = false

    private lazy var indicator: UIView = { return UIView() }()
    private var shownDate: Date?
    private var paddingConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    private var bezelConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    private lazy var topSpacer: UIView = { return UIView() }()
    private lazy var bottomSpacer: UIView = { return UIView() }()
    private var graceTimer: Timer?
    private var minShowTimer: Timer?
    private var hideDelayTimer: Timer?
    private var progressObjectDisplayLink: CADisplayLink?
    private var isProgressDisplayerLinkEnable: Bool = false {
        didSet {
            if isProgressDisplayerLinkEnable && self.progressObject != nil {
                if progressObjectDisplayLink == nil {
                    progressObjectDisplayLink = CADisplayLink(target: self,
                                                              selector: #selector(updateProgressFromProgressObject))
                }
            } else {
                progressObjectDisplayLink = nil
            }
        }
    }

    private struct StaticValue {
        let maxOffset: CGFloat = 1000000.0
        let defaultPadding: CGFloat = 4.0
        let defaultLabelFontSize: CGFloat = 17.0
        let defaultDetailsLabelFontSize: CGFloat = 12.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProgressAlertView {

    @objc
    private func updateProgressFromProgressObject() {
        self.progress = self.progressObject?.fractionCompleted ?? 0.0
    }

    private func updateBezelMontionEffects() {
        guard bezelView.responds(to: #selector(PABackgroundView.addMotionEffect(_:))) else {
            return
        }

        if isMotionEffectsEnabled {
            let effectOffset: CGFloat = 10.0
            let effectX = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
            effectX.minimumRelativeValue = -effectOffset
            effectX.maximumRelativeValue = effectOffset

            let effectY = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
            effectX.minimumRelativeValue = -effectOffset
            effectX.maximumRelativeValue = effectOffset

            let effectGroup = UIMotionEffectGroup()
            effectGroup.motionEffects = [effectX, effectY]

            bezelView.addMotionEffect(effectGroup)
        } else {
            let effectGroup = bezelView.motionEffects
            for effect in effectGroup {
                bezelView.removeMotionEffect(effect)
            }
        }
    }

    private func updateView(byColor color: UIColor?) {
        guard let color = color else {
            return
        }

        self.label.textColor = color
        self.detailsLabel.textColor = color
        self.button.setTitleColor(color, for: .normal)

        if indicator.isKind(of: UIActivityIndicatorView.self) {
            let appearance: UIActivityIndicatorView = UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [PABackgroundView.self])
            if appearance.color == nil {
                (indicator as? UIActivityIndicatorView)?.color = color
            }
        } else if indicator.isKind(of: PARoundedButton.self) {

        } else if indicator.isKind(of: ProgressAlertView.self) {

        } else {
            if indicator.responds(to: #selector(setter: UIView.tintColor)) {
                indicator.tintColor = color
            }
        }
    }
}
