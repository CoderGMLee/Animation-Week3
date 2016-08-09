//
//  ViewController.swift
//  Animation-Week3
//
//  Created by GM on 16/8/8.
//  Copyright © 2016年 LGM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var bubbleShake : BubbleShakeView?

    override func viewDidLoad() {
        super.viewDidLoad()

        var bubbleView = BubbleView(frame :  CGRectMake(100, 100, 100, 100));
        bubbleView.fillColor = UIColor.redColor();
        self.view.addSubview(bubbleView);



        bubbleShake = BubbleShakeView(frame : CGRectMake(100,300,100,100));
        self.view.addSubview(bubbleShake!);
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func action(sender: AnyObject) {
        bubbleShake?.addAnimation();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

