//
//  ProgressAlertRoundProgressView.swift
//  ProgressAlertView
//
//  Created by iMac on 2018/5/16.
//  Copyright © 2018年 iMac. All rights reserved.
//

import UIKit

class PARoundProgressView: UIButton {

    convenience init() {
        self.init(frame: CGRect(origin: .zero, size: StaticValue.defaultSize))
    }

    override init(frame: CGRect) {

        super.init(frame: frame)

        self.backgroundColor = UIColor.clear
        self.isOpaque = false
    }

    override func draw(_ rect: CGRect) {

        if isAnnular {
            drawAnnularProgress(rect: rect)
        } else {
            drawCircleProgress(rect: rect)
        }
    }

    override var intrinsicContentSize: CGSize {
        return StaticValue.defaultSize
    }

    @objc
    dynamic var progress: CGFloat = 0.0 {
        didSet {
            if progress != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    var progressTintColor: UIColor = StaticValue.defaultProgressTintColor {
        didSet {
            if progressTintColor.isEqual(oldValue) == false {
                self.setNeedsDisplay()
            }
        }
    }
    var backgroundTintColor: UIColor = StaticValue.defaultBackgroundTintColor {
        didSet {
            if backgroundTintColor.isEqual(oldValue) == false {
                self.setNeedsDisplay()
            }
        }
    }
    var isAnnular: Bool = false {
        didSet {
            if isAnnular != oldValue {
                self.setNeedsDisplay()
            }
        }
    }

    private struct StaticValue {
        static let defaultSize = CGSize(width: 37.0, height: 37.0)
        static let defaultProgressTintColor = UIColor(white: 1.0, alpha: 1.0)
        static let defaultBackgroundTintColor = UIColor(white: 1.0, alpha: 1.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PARoundProgressView {

    private func drawAnnularProgress(rect: CGRect) {

        let lineWidth: CGFloat = 2.0
        let startAngle = -(CGFloat.pi / 2)
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let radius = (min(self.bounds.width, self.bounds.height) - lineWidth) / 2

        do {
            let bezierPath = UIBezierPath()
            bezierPath.lineWidth = lineWidth
            bezierPath.lineCapStyle = .butt
            let endAngle = 2 * CGFloat.pi + startAngle

            bezierPath.addArc(withCenter: center, radius: radius,
                              startAngle: startAngle, endAngle: endAngle,
                              clockwise: true)
            backgroundColor?.set()
            bezierPath.stroke()
        }

        do {
            let bezierPath = UIBezierPath()
            bezierPath.lineWidth = lineWidth
            bezierPath.lineCapStyle = .square

            let endAngle = self.progress * (2 * CGFloat.pi) + startAngle
            bezierPath.addArc(withCenter: center, radius: radius,
                              startAngle: startAngle, endAngle: endAngle,
                              clockwise: true)
            progressTintColor.set()
            bezierPath.stroke()
        }
    }

    private func drawCircleProgress(rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let lineWidth: CGFloat = 2.0
        let allRect = self.bounds
        let circleRect = allRect.insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0)
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        progressTintColor.setStroke()
        backgroundTintColor.setFill()
        context.setLineWidth(lineWidth)
        context.strokeEllipse(in: circleRect)

        let startAngle = -(CGFloat.pi / 2)
        let endAngle = self.progress * (2 * CGFloat.pi) + startAngle
        let radius = (min(self.bounds.width, self.bounds.height) - lineWidth * 2) / 2
        let bezierPath = UIBezierPath()
        bezierPath.lineWidth = lineWidth * 2
        bezierPath.lineCapStyle = .butt
        bezierPath.addArc(withCenter: center, radius: radius,
                          startAngle: startAngle, endAngle: endAngle,
                          clockwise: true)
        context.setBlendMode(.copy)
        bezierPath.stroke()
    }
}
