//
//  ProgressAlertRoundedButton.swift
//  ProgressAlertView
//
//  Created by iMac on 2018/5/15.
//  Copyright © 2018年 iMac. All rights reserved.
//

import UIKit

class ProgressAlertRoundedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1.0
    }

    override func setTitleColor(_ color: UIColor?, for state: UIControlState) {

        super.setTitleColor(color, for: state)

        let isHighlighted = self.isHighlighted
        self.isHighlighted = isHighlighted
        self.layer.borderColor = color?.cgColor
    }

    override func layoutSubviews() {

        super.layoutSubviews()

        let radius = ceil(min(self.bounds.width, self.bounds.height) / 2.0)
        self.layer.cornerRadius = radius
    }

    override var isHighlighted: Bool {
        didSet {
            let baseColor = titleColor(for: .selected)
            self.backgroundColor = isHighlighted ? baseColor?.withAlphaComponent(0.1) : UIColor.clear
        }
    }

    override var intrinsicContentSize: CGSize {

        guard self.allControlEvents.rawValue != 0 else {
            return .zero
        }

        var size = super.intrinsicContentSize
        size.width += 20.0
        return size
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
