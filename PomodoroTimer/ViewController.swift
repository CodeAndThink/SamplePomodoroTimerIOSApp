//
//  ViewController.swift
//  PomodoroTimer
//
//  Created by admin on 21/10/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var startCounter: UIButton!
    @IBOutlet private weak var resetCounter: UIButton!
    @IBOutlet private weak var timeCounter: UILabel!
    
    private let initialTime = 5 * 60
    private var totalSeconds = 5 * 60
    private var timerCounter : Timer?
    private var isStartCounting = false
    
    private let ringLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUi()
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
    
    private func startCounting(){
        timerCounter = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.updateTimerCounter()
        })
    }
    
    private func pauseCounting(){
        timerCounter?.invalidate()
    }
    
    private func resetCounting(){
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
    
    private func loadUi () {
        timeCounter.text = convertTime(remainingSecond: initialTime)
        view.self.backgroundColor = UIColor.black
        startCounter.layer.cornerRadius = 2
        
        let ringPath = UIBezierPath(arcCenter: CGPoint(x: view.center.x, y: view.center.y), radius: 50, startAngle: -CGFloat.pi / 2, endAngle: -CGFloat.pi / 2 + 2 * CGFloat.pi, clockwise: true)
        ringLayer.path = ringPath.cgPath
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeColor = UIColor(named: "mainColor")?.cgColor
        ringLayer.lineWidth = 3
        ringLayer.strokeEnd = 1
        
        view.layer.addSublayer(ringLayer)
        
        NSLayoutConstraint.activate([
            timeCounter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeCounter.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

