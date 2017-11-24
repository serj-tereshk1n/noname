//
//  ViewController.swift
//  noname
//
//  Created by sergey.tereshkin on 20/11/2017.
//  Copyright © 2017 sergey.tereshkin. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ViewController: UIViewController, LeftMenuDelegate, RightMenuDelegate {

    // variable properties
    var xMinLimit: CGFloat = 0
    var yMinLimit: CGFloat = 0
    var xMaxLimit: CGFloat = 0
    var yMaxLimit: CGFloat = 0
    
    var touchedView: UIView?
    var touch: UITouch?
    var hilightView: UIView?
    var viewsData = Dictionary<UIView, Dictionary<String, String>>()
    
    // views closure declaration
    var leftBarItem: UIBarButtonItem {
        return UIBarButtonItem(
            image: UIImage(named: "leftDrawer"),
            style: .plain,
            target: self.slideMenuController(),
            action: #selector(toggleLeft)
        )
    }
    
    var rightBarItem: UIBarButtonItem {
        return UIBarButtonItem(
            image: UIImage(named: "rightDrawer"),
            style: .plain,
            target: self.slideMenuController(),
            action: #selector(toggleRight)
        )
    }
    
    // viewcontroller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = leftBarItem
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        self.hilightView = UIView()
        if let hv = self.hilightView {
            self.view.addSubview(hv)
            hv.translatesAutoresizingMaskIntoConstraints = false
            hv.clipsToBounds = false
            hv.backgroundColor = .black
            
            let horizontalConstraint = NSLayoutConstraint(item: hv, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
            let verticalConstraint = NSLayoutConstraint(item: hv, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
            let widthConstraint = NSLayoutConstraint(item: hv, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
            let heightConstraint = NSLayoutConstraint(item: hv, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
            
//            let arrows = ["lav":UIImageView()
////                          "tav":UIImageView(),
////                          "rav":UIImageView(),
////                          "bav":UIImageView()
//            ]
//
//            arrows.forEach({ (key: String, av: UIImageView) in
//                av.translatesAutoresizingMaskIntoConstraints = false
//                hv.addSubview(av)
//
//                av.backgroundColor = .red
//
//                let hrzc = NSLayoutConstraint(item: av, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: hv, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
//                let vtlc = NSLayoutConstraint(item: av, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
//                let wdthc = NSLayoutConstraint(item: av, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 44)
//                let hthc = NSLayoutConstraint(item: av, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: hv, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
//
//                
//                hv.addConstraints([hrzc, vtlc, wdthc, hthc])
//            })
            
            self.view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        }
    }
    
    // touches interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == self.view { return }
        if touches.first?.view == hilightView { return }
        
        touch = touches.first
        touchedView = touch?.view
        
        if let v = touchedView {
            self.view.bringSubview(toFront: hilightView!)
            self.view.bringSubview(toFront: v)
            updateLimitsFor(view:v)
            highlightSelection(view:v)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touch, let v = touchedView, let hv = hilightView {
            let location = t.location(in: v.superview)
            var x = location.x
            var y = location.y
            
            if x < xMinLimit { x = xMinLimit }
            if y < yMinLimit { y = yMinLimit }
            if x > xMaxLimit { x = xMaxLimit }
            if y > yMaxLimit { y = yMaxLimit }
            
            x = x - self.view.center.x
            y = y - self.view.center.y
            
            v.constraintCentrY = y
            v.constraintCentrX = x
            hv.constraintCentrY = y
            hv.constraintCentrX = x
            
            UIView.animate(withDuration: 0.05, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = nil
        touchedView = nil
    }
    
    // Utils
    func updateLimitsFor(view: UIView) {
        xMinLimit = view.frame.size.width / 2.0
        yMinLimit = view.frame.size.height / 2.0
        
        if let w = self.view?.frame.width, let h = self.view?.frame.height {
            xMaxLimit = w - xMinLimit
            yMaxLimit = h - yMinLimit
        }
    }
    
    func highlightSelection(view: UIView) {
        if let hv = hilightView {
            
            self.view.bringSubview(toFront: hv)
            self.view.bringSubview(toFront: view)
            
            let p: CGFloat = 1.15 // percentage eto make hv bigger
            let w = view.frame.size.width * p
            let h = view.frame.size.height * p
            
            hv.constraintWidth = w + 44
            hv.constraintHeight = h + 44
            hv.constraintCentrY = view.constraintCentrY
            hv.constraintCentrX = view.constraintCentrX
            
            UIView.animate(withDuration: 0.15, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func addSubview(_ class: AnyClass?) {
        let w: CGFloat = 100
        let h: CGFloat = 100
        
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(v)

        let horizontalConstraint = NSLayoutConstraint(item: v, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: v, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: v, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: w)
        let heightConstraint = NSLayoutConstraint(item: v, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: h)
        
        self.view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        UIView.animate(withDuration: 0.3, animations: {
            v.backgroundColor = .clear
        }) { (value: Bool) in
            UIView.animate(withDuration: 0.3, animations: {
                v.backgroundColor = self.randomColor()
            }) { (value: Bool) in
                self.highlightSelection(view: v)
                v.isUserInteractionEnabled = true
            }
        }
    }
    
    func getSubviews() -> [UIView] {
        var views = self.view.subviews
        if let hv = hilightView {
           let i = views.index(of: hv)
            views.remove(at: i!)
        }
        return views
    }
    
    func randomColor() -> UIColor {
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}

