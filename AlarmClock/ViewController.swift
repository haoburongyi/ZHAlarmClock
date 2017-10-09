//
//  ViewController.swift
//  AlarmClock
//
//  Created by 张淏 on 2017/10/9.
//  Copyright © 2017年 cc.umoney. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.isUserInteractionEnabled = true
        let alarmClock = TimingView.init(frame: view.bounds)
        view.addSubview(alarmClock)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

