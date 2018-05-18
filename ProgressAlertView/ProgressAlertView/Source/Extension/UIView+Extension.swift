//
//  UIView+Extension.swift
//  ProgressAlertView
//
//  Created by iMac on 2018/5/15.
//  Copyright © 2018年 iMac. All rights reserved.
//

import Foundation

extension UIView {
    
    convenience init(view: UIView) {
        self.init(frame: view.bounds)
    }

    var alertView: ProgressAlertView? {
        var alertView: ProgressAlertView?
        let reversedSubViews = self.subviews.reversed()
        for view in reversedSubViews {
            if view.isKind(of: ProgressAlertView.self) {
                alertView = view as? ProgressAlertView
                break
            }
        }

        guard let resultView = alertView else {
            return nil
        }
        return resultView.isFinished ? nil : resultView
    }
}
