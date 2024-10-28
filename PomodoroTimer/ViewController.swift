//
//  ViewController.swift
//  PomodoroTimer
//
//  Created by admin on 21/10/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var startCounter: UIButton!
    @IBOutlet weak var resetCounter: UIButton!
    @IBOutlet weak var timeCounter: UILabel!
    private let initialTime = 25 * 60
    private var totalSeconds = 25 * 60
    private var timerCounter : Timer?
    private var isStartCounting = false
    private let primaryColor : UIColor = UIColor.orange
    private let ringLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUi()
    }
    
    private func loadUi () {
        timeCounter.text = convertTime(remainingSecond: initialTime)
        view.self.backgroundColor = UIColor.black
        timeCounter.textColor = UIColor.white
        
        let ringPath = UIBezierPath(arcCenter: CGPoint(x: view.center.x, y: view.center.y), radius: 75, startAngle: -CGFloat.pi / 2, endAngle: -CGFloat.pi / 2 + 2 * CGFloat.pi, clockwise: true)
        ringLayer.path = ringPath.cgPath
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeColor = UIColor.orange.cgColor
        ringLayer.lineWidth = 3
        ringLayer.strokeEnd = 1
        view.layer.addSublayer(ringLayer)
        
        view.layer.addSublayer(ringLayer)
        
        NSLayoutConstraint.activate([
            timeCounter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeCounter.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startCounter.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 120),
            resetCounter.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 120)
        ])
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        if !isStartCounting {
            startCounting()
            isStartCounting = !isStartCounting
            startCounter.setTitle("Pause", for: .normal)
        } else {
            startCounter.setTitle("Start", for: .normal)
            pauseCounting()
            isStartCounting = !isStartCounting
        }
    }
    @IBAction func resetButtonAction(_ sender: Any) {
        resetCounting()
    }
    
    func startCounting(){
        timerCounter = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.updateTimerCounter()
        })
    }
    
    func pauseCounting(){
        timerCounter?.invalidate()
    }
    
    func resetCounting(){
        timeCounter.text = convertTime(remainingSecond: initialTime)
        totalSeconds = initialTime
        ringLayer.strokeEnd = 1
        timerCounter?.invalidate()
        startCounter.setTitle("Start", for: .normal)
        isStartCounting = false
    }
    
    @objc func updateTimerCounter(){
        if totalSeconds == 0 {
            resetCounting()
            return
        }
        
        totalSeconds -= 1
        updateRingProgress()
        
        timeCounter.text = convertTime(remainingSecond: totalSeconds)
    }
    
    private func convertTime (remainingSecond : Int) -> String {
        let minutes : Int = remainingSecond / 60
        let seconds = remainingSecond % 60
        return String(format: "%02d:%02d",  minutes, seconds)
    }
    
    private func updateRingProgress() {
        let progress = CGFloat(totalSeconds) / CGFloat(initialTime)
        ringLayer.strokeEnd = progress
    }
}

