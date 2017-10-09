//
//  UIView+Extension.swift
//  Case
//
//  Created by 张淏 on 2017/7/28.
//  Copyright © 2017年 cc.umoney. All rights reserved.
//

import Foundation

// 屏幕比
func SCaleW(_ num: CGFloat) -> CGFloat {
    
    return UIScreen.main.bounds.width * (num / 375.0)
}
func SCaleH(_ num: CGFloat) -> CGFloat {
    return UIScreen.main.bounds.height * (num / 667.0)
}


extension UIView {
    
    func ScaleSizeToFit() {
        sizeToFit()
        
        if frame.width >= frame.height {
            let w = frame.width
            frame.size.width = SCaleW(w)
            frame.size.height = frame.size.width / w * frame.size.height
        } else {
            let h = frame.height
            frame.size.height = SCaleH(h)
            frame.size.width = frame.size.height / h * frame.size.width
        }
    }
    
    func setCornerRadiusInTable(backgroundColor: UIColor = UIColor.white, cornerRadius: CGFloat) {
        
        self.backgroundColor = UIColor.clear
        // Set view.layer.backgroundColor not view.backgroundColor otherwise the background is not masked to the rounded border.
        layer.backgroundColor = backgroundColor.cgColor
        layer.cornerRadius = cornerRadius
        // Huge change in performance by explicitly setting the below (even though default is supposedly NO)
        layer.masksToBounds = false
        // Performance improvement here depends on the size of your view
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
