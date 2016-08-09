//
//  ViewController.swift
//  Animation-Week3
//
//  Created by GM on 16/8/8.
//  Copyright © 2016年 LGM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var bubbleView = BubbleView(frame :  CGRectMake(100, 100, 100, 100));
        bubbleView.fillColor = UIColor.redColor();
        self.view.addSubview(bubbleView);

        // Do any additional setup after loading the view, typically from a nib.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

