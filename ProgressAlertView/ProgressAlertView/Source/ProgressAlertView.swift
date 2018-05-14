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

class ProgressAlertView: UIView {
    typealias CompletionBlock = () -> Void

    @objc dynamic var contentColor: UIColor?
    @objc dynamic var animationType: ProgressAlertViewAnimation = .zoom
    @objc dynamic var offset: CGPoint = .zero
    @objc dynamic var margin: CGFloat = 0.0
    @objc dynamic var minSize: CGSize = .zero
    @objc dynamic var isSquare: Bool = true
    @objc dynamic var isMotionEffectsEnabled: Bool = false

    var progress: Float = 0.0
    lazy var lezelView: UIView = { return UIView(frame: .zero) }()
    lazy var backgroundView: UIView = { return UIView(frame: .zero) }()
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
    private var isFinished: Bool = false

    private lazy var indicator: UIView = { return UIView() }()
    private var showStarted: NSDate?
    private var paddingConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    private var bezelConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    private lazy var topSpacer: UIView = { return UIView() }()
    private lazy var bottomSpacer: UIView = { return UIView() }()
    private var graceTimer: Timer?
    private var minShowTimer: Timer?
    private var hideDelayTimer: Timer?
    private var processObjectDisplayLink: CADisplayLink?

    private struct StaticValue {
        let maxOffset: CGFloat = 1000000.0
        let defaultPadding: CGFloat = 4.0
        let defaultLabelFontSize: CGFloat = 17.0
        let defaultDetailsLabelFontSize: CGFloat = 12.0
    }
}

extension ProgressAlertView {

    func testUI() {
        let appearance = ProgressAlertView.appearance()
//        appearance.contentColor
    }
}
