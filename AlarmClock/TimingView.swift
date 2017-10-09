//
//  TimingView.swift
//  Case
//
//  Created by 张淏 on 2017/7/26.
//  Copyright © 2017年 cc.umoney. All rights reserved.
//

import UIKit

func colorConversion (Color_Value:String, alpha: CGFloat)->UIColor{
    
    
    var  Str :NSString = Color_Value.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased() as NSString
    if Color_Value
        .hasPrefix("#"){
        Str=(Color_Value as NSString).substring(from: 1) as NSString
    }
    let redStr = (Str as NSString ).substring(to: 2)
    let greenStr = ((Str as NSString).substring(from: 2) as NSString).substring(to: 2)
    let blueStr = ((Str as NSString).substring(from: 4) as NSString).substring(to: 2)
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string:redStr).scanHexInt32(&r)
    Scanner(string: greenStr).scanHexInt32(&g)
    Scanner(string: blueStr).scanHexInt32(&b)
    return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
}


class TimingView: UIView {

    fileprivate let zhongDeng = UIImageView.init(image: #imageLiteral(resourceName: "zhongDengYuan"))// 针的父视图圆圈
    fileprivate let tableNeedle = UIImageView.init(image: #imageLiteral(resourceName: "TableNeedle"))// 针
    fileprivate let hasTimed = UILabel()
    fileprivate let timingLbl = UILabel()// 定时多少分钟的 label
    fileprivate let minAngle: CGFloat = 360 / 60// 每分钟 6 度
    fileprivate var timing: CGFloat = 0 {// 定时多少分钟
        didSet {
            if timing > 60 {
                timingLbl.text = "\(Int(timing) / 60)小时\(Int(timing) % 60)分钟"
            } else {
                timingLbl.text = "\(Int(timing))分钟"
            }
        }
    }
    fileprivate var lastAngle: CGFloat = 0// 记录上一个角度
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        backgroundColor = colorConversion(Color_Value: "EAEAEA", alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc fileprivate func panHandle(gesture: UIPanGestureRecognizer) {
        
        let touchPoint = gesture.location(in: zhongDeng.superview)// 手势的位置
        var startPoint = tableNeedle.frame.origin// 角度开始的位置
        let tableNeedleCenter = tableNeedle.superview!.center// 中心点
        startPoint.x += tableNeedle.bounds.width * 0.5// 角度开始的 x 并不是表针的 x， 而应该是表针 x 的中点
 
        var angle = AngleTools.getAngleBetweenLines(startPoint, line1End: tableNeedleCenter, line2Start: touchPoint, line2End: tableNeedleCenter)// 算出角度
        if touchPoint.x < startPoint.x {// 得出正确的位置
            angle = 360 - angle
        }
        
        print("angle: \(angle), lastAngle: \(lastAngle)")
        
        // 如果上一次指针在 6 - 12, 这一次在 0 - 3, 则认为多了一个小时
        if lastAngle > 360 * 0.5 && angle < 360 * 0.25 {
            timing += 60
        }
        // 如果上一次指针在 0 - 3, 这一次在 6 - 12, 则认为少了一个小时
        else if lastAngle < 360 * 0.25 && angle > 360 * 0.5 {
            if timing >= 60 {
                timing -= 60
            }
            // 如果时间小于 60 还到了 0 这里，说明要负数了，做判断不继续旋转
            else {
                tableNeedle.superview?.layer.transform = CATransform3DMakeRotation(0 / 180 * .pi, 0, 0, 1)
                lastAngle = 0
                timing = 0
                return
            }
        }
        tableNeedle.superview?.layer.transform = CATransform3DMakeRotation(angle / 180 * .pi, 0, 0, 1)// 旋转
        timing += (angle - lastAngle) / minAngle
        lastAngle = angle
    }
    
    @objc fileprivate func refreshClick() {
        
        print("点击了刷新")
        UIView.animate(withDuration: 0.25) { 
            
            self.tableNeedle.superview?.layer.transform = CATransform3DMakeRotation(0 / 180 * .pi, 0, 0, 1)
        }
        lastAngle = 0
        timing = 0
    }
}

// MARK: - UI
extension TimingView {
    
    fileprivate func setupUI() {
        
        let plate = UIImageView.init(image: #imageLiteral(resourceName: "oclock_plate"))
        plate.ScaleSizeToFit()
        plate.origin = CGPoint(x: bounds.width * 0.5 - plate.width * 0.5, y: SCaleH(60))
        addSubview(plate)
        
        zhongDeng.sizeToFit()
        zhongDeng.isUserInteractionEnabled = true
        zhongDeng.clipsToBounds = false
        zhongDeng.width = bounds.width
        zhongDeng.height = zhongDeng.width
        zhongDeng.contentMode = .center
        zhongDeng.origin = CGPoint(x: plate.x + plate.width * 0.5 - zhongDeng.width * 0.5, y: plate.y + plate.height * 0.5 - zhongDeng.height * 0.5)
        addSubview(zhongDeng)
        
        let zhongDengBg = UIView(frame: zhongDeng.bounds)
        zhongDeng.addSubview(zhongDengBg)
        
        
        
        let xiaoYuan = UIImageView.init(image: #imageLiteral(resourceName: "xiaoYuan"))
        xiaoYuan.sizeToFit()
        xiaoYuan.isUserInteractionEnabled = true
        xiaoYuan.clipsToBounds = false
        xiaoYuan.origin = CGPoint(x: zhongDeng.width * 0.5 - xiaoYuan.width * 0.5, y: zhongDeng.height * 0.5 - xiaoYuan.height * 0.5)
        
        
        tableNeedle.ScaleSizeToFit()
        tableNeedle.isUserInteractionEnabled = true
        let tableneedleScale: CGFloat = 1 - 70 / 395
        tableNeedle.x = zhongDeng.width * 0.5 - tableNeedle.width * 0.5
        tableNeedle.y = zhongDeng.height * 0.5 - tableNeedle.height * tableneedleScale
        zhongDengBg.addSubview(tableNeedle)
        
        zhongDeng.addSubview(xiaoYuan)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panHandle(gesture:)))
        tableNeedle.addGestureRecognizer(pan)
        
        
        hasTimed.font = UIFont.init(name: "PingFangSC-Light", size: 12)
        hasTimed.text = "已定时"
        hasTimed.textColor = UIColor.black
        hasTimed.sizeToFit()
        hasTimed.origin = CGPoint(x: bounds.width * 0.5 - hasTimed.width * 0.5, y: bounds.height - SCaleH(66) - hasTimed.height)
        addSubview(hasTimed)
        
        timingLbl.font = UIFont.init(name: "PingFangSC-Light", size: 11)
        timingLbl.textAlignment = .center
        timingLbl.text = "0分钟"
        timingLbl.textColor = UIColor.black
        timingLbl.sizeToFit()
        timingLbl.width = bounds.width
        timingLbl.y = hasTimed.y + hasTimed.height + 4
        addSubview(timingLbl)
        
        let refresh = UIButton()
        refresh.setImage(#imageLiteral(resourceName: "refresh"), for: .normal)
        refresh.setImage(#imageLiteral(resourceName: "refresh_y"), for: .highlighted)
        refresh.sizeToFit()
        refresh.addTarget(self, action: #selector(refreshClick), for: .touchUpInside)
        refresh.origin = CGPoint(x: bounds.width - SCaleW(66) - refresh.width, y: hasTimed.y)
        addSubview(refresh)
        
    }
}
