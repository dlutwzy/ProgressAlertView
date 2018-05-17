//
//  PABarProgressView.swift
//  ProgressAlertView
//
//  Created by iMac on 2018/5/17.
//  Copyright © 2018年 iMac. All rights reserved.
//

import UIKit

class PABarProgressView: UIView {

    convenience init() {
        self.init(frame: CGRect(origin: .zero, size: StaticValue.defaultSize))
    }

    override init(frame: CGRect) {

        super.init(frame: frame)

        self.backgroundColor = UIColor.clear
        self.isOpaque = false
    }

    var progress: CGFloat = 0.0 {
        didSet {
            if progress != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    var lineColor: UIColor = StaticValue.defaultLineColor {
        didSet {
            if lineColor.isEqual(oldValue) == false {
                self.setNeedsDisplay()
            }
        }
    }
    var progressTintColor: UIColor = StaticValue.defaultProgressColor {
        didSet {
            if progressTintColor.isEqual(oldValue) == false {
                self.setNeedsDisplay()
            }
        }
    }
    var trackTintColor: UIColor = StaticValue.defaultRemainingColor {
        didSet {
            if trackTintColor.isEqual(oldValue) == false {
                self.setNeedsDisplay()
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 120.0, height: 10.0)
    }

    override func draw(_ rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()
        let lineWidth: CGFloat = 2.0

        context?.setLineWidth(lineWidth)
        context?.setStrokeColor(lineColor.cgColor)
        context?.setFillColor(trackTintColor.cgColor)

        let width = rect.width
        let height = rect.height
        let radius = (height - lineWidth) / 2.0
        context?.move(to: CGPoint(x: lineWidth, y: height / 2.0))
        context?.addArc(tangent1End: CGPoint(x: width - lineWidth, y: lineWidth),
                        tangent2End: CGPoint(x: width - lineWidth, y: height / 2.0),
                        radius: radius)
        context?.addArc(tangent1End: CGPoint(x: width - lineWidth, y: height - lineWidth),
                        tangent2End: CGPoint(x: width - lineWidth, y: height / 2.0),
                        radius: radius)
        context?.addArc(tangent1End: CGPoint(x: width - lineWidth, y: lineWidth),
                        tangent2End: CGPoint(x: width / 2.0, y: lineWidth),
                        radius: radius)
        context?.addArc(tangent1End: CGPoint(x: lineWidth, y: lineWidth),
                        tangent2End: CGPoint(x: lineWidth, y: height / 2.0),
                        radius: radius)
        context?.drawPath(using: .fillStroke)

        guard self.progress > 0.0 && self.progress <= 1.0  else {
            return
        }

        context?.setFillColor(progressTintColor.cgColor)
        let offset = lineWidth * 2.0
        let progressRadius = radius - lineWidth
        let progressTotalWidth = width - lineWidth * 2.0
        let amount = self.progress * progressTotalWidth

        if amount < progressRadius {

            let lenght = progressRadius - amount
            let angle = asin(lenght / progressRadius)

            context?.move(to: CGPoint(x: offset, y: height / 2.0))
            context?.addArc(center: CGPoint(x: offset + progressRadius, y: height / 2.0),
                            radius: progressRadius,
                            startAngle: CGFloat.pi, endAngle: (CGFloat.pi * 0.5 + angle),
                            clockwise: false)
            context?.addLine(to: CGPoint(x: offset + amount, y: height / 2.0))
            context?.move(to: CGPoint(x: offset, y: height / 2.0))
            context?.addArc(center: CGPoint(x: offset + progressRadius, y: height / 2.0),
                            radius: progressRadius,
                            startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2.0 - angle,
                            clockwise: true)
            context?.addLine(to: CGPoint(x: offset + amount, y: height / 2.0))

            context?.fillPath()
        }
        else if amount >= progressRadius && amount <= (progressTotalWidth - progressRadius) {
            context?.move(to: CGPoint(x: offset, y: height / 2.0))
            context?.addArc(tangent1End: CGPoint(x: offset, y: height - offset),
                            tangent2End: CGPoint(x: offset + progressRadius, y: height - offset),
                            radius: progressRadius)
            context?.addLine(to: CGPoint(x: offset + amount, y: height - offset))
            context?.addLine(to: CGPoint(x: offset + amount, y: offset))
            context?.addLine(to: CGPoint(x: offset + progressRadius, y: offset))
            context?.addArc(tangent1End: CGPoint(x: offset, y: offset),
                            tangent2End: CGPoint(x: offset, y: height / 2.0),
                            radius: progressRadius)

            context?.fillPath()
        } else if amount > (progressTotalWidth - progressRadius) && amount <= progressTotalWidth {

            let squareLength = progressTotalWidth - progressRadius
            let lenght = amount - squareLength
            let angle = asin(lenght / progressRadius)

            context?.move(to: CGPoint(x: offset, y: height / 2.0))
            context?.addArc(tangent1End: CGPoint(x: offset, y: height - offset),
                            tangent2End: CGPoint(x: offset + progressRadius, y: height - offset),
                            radius: progressRadius)
            context?.addLine(to: CGPoint(x: offset + squareLength, y: height - offset))
            context?.addArc(center: CGPoint(x: offset + squareLength, y: height / 2.0),
                            radius: progressRadius,
                            startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi * 0.5 - angle,
                            clockwise: false)
            context?.addLine(to: CGPoint(x: offset + amount, y: height / 2.0))

            context?.move(to: CGPoint(x: offset, y: height / 2.0))
            context?.addArc(tangent1End: CGPoint(x: offset, y: offset),
                            tangent2End: CGPoint(x: offset + progressRadius, y: offset),
                            radius: progressRadius)
            context?.addLine(to: CGPoint(x: offset + squareLength, y: offset))
            context?.addArc(center: CGPoint(x: offset + squareLength, y: height / 2.0),
                            radius: progressRadius,
                            startAngle: -(CGFloat.pi * 0.5), endAngle: -(CGFloat.pi * 0.5 - angle),
                            clockwise: true)
            context?.addLine(to: CGPoint(x: offset + amount, y: height / 2.0))

            context?.fillPath()
        }
    }

    private struct StaticValue {
        static let defaultSize = CGSize(width: 120.0, height: 20.0)
        static let defaultLineColor = UIColor.white
        static let defaultProgressColor = UIColor.white
        static let defaultRemainingColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
