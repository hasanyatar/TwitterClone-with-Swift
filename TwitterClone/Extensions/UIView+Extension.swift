//
//  UIView+Extensions.swift
//  TwitterClone
//
//  Created by Hasan YATAR on 25.02.2023.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    @IBInspectable var circleCorner: Bool {
        get { return self.circleCorner }
        set {
            if newValue {
                self.layer.cornerRadius = self.bounds.size.width * 0.5
            }
        }
    }
}
