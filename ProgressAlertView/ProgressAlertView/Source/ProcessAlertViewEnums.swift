//
//  ProcessAlertViewType.swift
//  ProgressAlertView
//
//  Created by iMac on 2018/5/14.
//  Copyright © 2018年 iMac. All rights reserved.
//

import Foundation

enum ProgressAlertViewStyle {
    case indicator
    case determinate
    case horizontalProgressBar
    case annularDeterminate
    case customView
    case textOnly
}

@objc
enum ProgressAlertViewAnimation: Int {
    case fade
    case zoom
    case zoomOut
    case zoomIn
}

@objc
enum ProgressAlertViewBackgroundStyle: Int {
    case solidColor
    case blur
}
