//
//  BubbleShakeView.swift
//  Animation-Week3
//
//  Created by GM on 16/8/9.
//  Copyright © 2016年 LGM. All rights reserved.
//

import UIKit
//类似gameCenter的动画
class BubbleShakeView: UIView {

    var bubbleLayer = CALayer();


    override init(frame: CGRect) {
        super.init(frame: frame);
        self.config();
    }
    func config(){
        bubbleLayer.frame = CGRectMake(10, 10, self.width / 2, self.height / 2);
        bubbleLayer.backgroundColor = UIColor.redColor().CGColor;
        bubbleLayer.cornerRadius = self.width/4;
        self.layer.addSublayer(bubbleLayer);
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addAnimation(){
        //1、按照椭圆的路径运动
        let pathAniamtion = CAKeyframeAnimation(keyPath: "position");
        pathAniamtion.removedOnCompletion = false;
        pathAniamtion.repeatCount = Float.infinity;
        pathAniamtion.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear);
        pathAniamtion.duration = 5;
        pathAniamtion.fillMode = kCAFillModeForwards;
        let path = CGPathCreateMutable();
        CGPathAddEllipseInRect(path, nil, CGRectInset(bubbleLayer.frame, bubbleLayer.frame.width / 2 - 3, bubbleLayer.frame.height / 2 - 3));
        pathAniamtion.path = path;
        bubbleLayer.addAnimation(pathAniamtion, forKey: "position");
        //2、周期性的放大缩小
        let scaleAniamtion = CAKeyframeAnimation(keyPath: "transform.scale");
        scaleAniamtion.removedOnCompletion = false;
        scaleAniamtion.duration = 2;
        scaleAniamtion.fillMode = kCAFillModeForwards;
        scaleAniamtion.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear);
        scaleAniamtion.repeatCount = Float.infinity;
        scaleAniamtion.values = [1,1.1,1];
        scaleAniamtion.keyTimes = [0.0,1,2];
        scaleAniamtion.autoreverses = true;
        bubbleLayer.addAnimation(scaleAniamtion, forKey: "scale");
    }
    func clearAnimation(){
        bubbleLayer.removeAllAnimations();
    }

}
