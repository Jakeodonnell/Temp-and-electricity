//
//  ViewController.swift
//  IsTheElectrisityOn?
//
//  Created by Jake O´Donnell on 2019-08-04.
//  Copyright © 2019 Jake O´Donnell. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    var ref: DatabaseReference!
    var tid: Int = Int(INT8_MIN)
    var prev: Int = Int(INT_MAX)
    var timer = Timer()
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var temperature: Int = 0
    //var tidprev = Date()
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBOutlet weak var onoffLabel: UILabel!
    @IBOutlet weak var onoff: UIImageView!
    var pulsatingLayer: CAShapeLayer!
    let trackLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.onoff.image = UIImage(named: "onbutt.png")

        timer = Timer.scheduledTimer(timeInterval: 5, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        

        ref = Database.database().reference().child("timeEsp")
        ref.observe(.value, with: { (snapshot) in
            let timerCheck = snapshot.value!
            self.tid = timerCheck as! Int
            print(self.tid)
        })
        
        onoffLabel.font = UIFont(name: onoffLabel.font.fontName, size: 30)
        
        ref = Database.database().reference().child("logs")
        ref.observe(.value, with: { (snapshot) in
            let temp = snapshot.value!
            self.temperature = temp as! Int
            self.temperatureLabel.text = "\(self.temperature)"
            print(self.temperature)
        })
        
        //Animation
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)

        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = 10
        pulsatingLayer.fillColor = UIColor.lowTempPulsatingInner.cgColor
        pulsatingLayer.lineCap = CAShapeLayerLineCap.round
        pulsatingLayer.position = view.center
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lowTempPulsatingInner.cgColor
        trackLayer.lineWidth = 20
        trackLayer.fillColor = UIColor.transparentColor.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.position = view.center
        
        
        animatePulsatingLayer()

        
        view.layer.addSublayer(pulsatingLayer)
        view.layer.addSublayer(trackLayer)
        
    }
    
    func animatePulsatingLayer(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    
    
    @objc func updateTimer() {
        if(prev == tid){
            print("STRÖM HAR GÅTT")
            self.onoff.image = UIImage(named: "onbutt.png")
        }else {
            print("STRÖM PÅ")
            self.onoff.image = UIImage(named: "onbutt.png")
        }
        prev = tid
    }
}

func getTime(){
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    let timeString = formatter.string(from: NSDate() as Date)
    print(timeString)
}


