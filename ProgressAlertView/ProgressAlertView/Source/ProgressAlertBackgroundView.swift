//
//  ProgressAlertBackgroundView.swift
//  ProgressAlertView
//
//  Created by WZY on 2018/5/14.
//  Copyright © 2018年 iMac. All rights reserved.
//

import UIKit

class ProgressAlertBackgroundView: UIView {

    @objc dynamic var style: ProgressAlertViewBackgroundStyle = .blur
    @objc dynamic var blurEffectStyle: UIBlurEffectStyle = .light
    var color: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
