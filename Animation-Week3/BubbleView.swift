//
//  BubbleView.swift
//  Animation-Week3
//
//  Created by GM on 16/8/8.
//  Copyright © 2016年 LGM. All rights reserved.
//

import UIKit

/*
 1、动画由3部分组成，两个圆点，和一个动态更新的色块，其中一个圆点的大小是随着拖动距离改变的
 2、主要难点在于计算用于绘制贝塞尔曲线的6个关键点
 3、抄袭地址：http://kittenyang.com/drawablebubble/
 */

class BubbleView: UIView {

    var fillColor : UIColor?
    var containerView : UIView?
    var path : UIBezierPath?
    var shapeLayer : CAShapeLayer?
    var frontView : UIView?
    var backView : UIView?
    var panGuesture : UIPanGestureRecognizer?

    var backSize = CGSizeMake(20, 20)
    var frontSize = CGSizeMake(20, 20)

    var pointA = CGPointZero;
    var pointO = CGPointZero;
    var pointD = CGPointZero;

    var pointB = CGPointZero;
    var pointP = CGPointZero;
    var pointC = CGPointZero;
    //弹性系数  数值越大 可以拖的越长
    var springValue :CGFloat = 5;
    var minRadius : CGFloat = 6;

    var x1 : CGFloat {
        get{
            return backView!.centerX;
        }
    }
    var x2 : CGFloat{
        get{
            return frontView!.centerX;
        }
    }

    var y1 : CGFloat{
        get{
            return backView!.centerY;
        }
    }
    var y2 : CGFloat{
        get{
            return frontView!.centerY;
        }
    }

    var r1 : CGFloat{
        get{
            return backSize.width / 2;
        }
    }

    var r2 : CGFloat{
        get{
            return frontSize.width / 2;
        }
    }
    var centerDistance : CGFloat{
        get{
            return sqrt(pow((x2 - x1), 2) + pow(y2 - y1, 2));
        }
    }

    var cosDigree : CGFloat{
        get{
            return (y2 - y1) / centerDistance;
        }
    }
    var sinDigree : CGFloat{
        get{
            return (x2 - x1) / centerDistance;
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame);
        self.config();
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    //绘制
    override func drawRect(rect: CGRect) {

        CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
        backView?.frame = CGRectMake(0, 0, backSize.width, backSize.height);
        backView?.center = CGPointMake(self.width / 2, self.height / 2);
        backView?.layer.cornerRadius = (backView?.width)! / 2;

        path = UIBezierPath();
        path?.moveToPoint(pointA);
        path?.addQuadCurveToPoint(pointD, controlPoint: pointO);
        path?.addLineToPoint(pointC);
        path?.addQuadCurveToPoint(pointB, controlPoint: pointP);
        path?.addLineToPoint(pointA);

        shapeLayer?.path = path?.CGPath;
        shapeLayer?.fillColor = fillColor?.CGColor;
        self.layer.addSublayer(shapeLayer!);
        self.containerView?.bringSubviewToFront(self);
    }
    //动态计算6个关键点的值
    func setup(){

        backSize = frontSize;
        let tmpWid = backSize.width - centerDistance / springValue;
        backSize = CGSizeMake(tmpWid, tmpWid);
        //重要的是以下几个点坐标的计算
        pointA = CGPointMake(x1 - r1 * cosDigree, y1 + r1 * sinDigree); // A
        pointB = CGPointMake(x1 + r1 * cosDigree, y1 - r1 * sinDigree); // B
        pointD = CGPointMake(x2 - r2 * cosDigree, y2 + r2 * sinDigree); // D
        pointC = CGPointMake(x2 + r2 * cosDigree, y2 - r2 * sinDigree); // C
        pointO = CGPointMake(pointA.x + (centerDistance / 2) * sinDigree,
                             pointA.y + (centerDistance / 2) * cosDigree);
        pointP = CGPointMake(pointB.x + (centerDistance / 2) * sinDigree,
                             pointB.y + (centerDistance / 2) * cosDigree);
        self.setNeedsDisplay();
    }
    //初始化工作
    func config(){

        self.backgroundColor = UIColor.clearColor();

        backView = UIView();
        backView?.width = backSize.width;
        backView?.height = backSize.height;
        backView?.center = CGPointMake(self.width / 2, self.height / 2);
        backView?.backgroundColor = UIColor.redColor();
        backView?.layer.cornerRadius = (backView?.width)! / 2;
        self.addSubview(backView!);

        frontView = UIView();
        frontView?.width = frontSize.width;
        frontView?.height = frontSize.height;
        frontView?.center = CGPointMake(self.width / 2, self.height / 2);
        frontView?.userInteractionEnabled = true;
        frontView?.backgroundColor = UIColor.redColor();
        frontView?.layer.cornerRadius = (frontView?.width)! / 2;
        self.addSubview(frontView!);

        panGuesture = UIPanGestureRecognizer(target: self, action: #selector(BubbleView.panGuestureAtion(_:)));
        frontView?.addGestureRecognizer(panGuesture!);

        shapeLayer = CAShapeLayer();
        shapeLayer?.fillColor = fillColor?.CGColor;
        shapeLayer?.frame = self.bounds;
        self.layer.addSublayer(shapeLayer!);

        pointA = CGPointMake(x1 - r1, y1); // A
        pointB = CGPointMake(x1 + r1, y1); // B
        pointD = CGPointMake(x2 - r2, y2); // D
        pointC = CGPointMake(x2 + r2, y2); // C
        pointO = CGPointMake(x1 - r1, y1); // O
        pointP = CGPointMake(x2 + r2, y2); // P
    }

    //手势处理
    func panGuestureAtion(guesture:UIPanGestureRecognizer){
        if guesture.state == .Began {

            self.backView?.hidden = false;
            backSize = frontSize;
            shapeLayer?.fillColor = fillColor?.CGColor;
        }else if guesture.state == .Changed {
            let location = guesture.locationInView(self);
            frontView?.center = location;
            if backSize.width <= minRadius {
                self.backView?.hidden = true;
                shapeLayer?.path = nil;
                shapeLayer?.fillColor = UIColor.clearColor().CGColor;
                shapeLayer?.removeFromSuperlayer();
            }else{
                self.setup();
            }
        } else if guesture.state == .Ended || guesture.state == .Cancelled || guesture.state == .Failed{
            shapeLayer?.removeFromSuperlayer();
            backView?.hidden = true;
            if backSize.width <= minRadius {
                print("1234567890");
                UIView.animateWithDuration(0.1, animations: {
                    self.frontView?.center = CGPointMake(self.width / 2, self.height / 2);
                });
            }else{
                UIView.animateWithDuration(0.1, animations: {
                    self.frontView?.center = CGPointMake(self.width / 2, self.height / 2);
                });
            }
        }
    }
}
