//
//  ViewController.swift
//  DKPauseableTimerDemo
//
//  Created by Derek_Lin on 2020/1/3.
//  Copyright © 2020 Derek_Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var timer: DKPauseableTimer? = nil
    var count: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        let pauseBtn = UIButton(type: .system)
        pauseBtn.frame = CGRect(x: view.center.x - 120, y: view.center.y + 100.0, width: 80.0, height: 30.0)
        pauseBtn.setTitle("Pause", for: .normal)
        pauseBtn.addTarget(self, action: #selector(pauseAciton), for: .touchUpInside)
        view.addSubview(pauseBtn)

        let resumeBtn = UIButton(type: .system)
        resumeBtn.frame = CGRect(x: view.center.x + 30, y: view.center.y + 100.0 , width: 80.0, height: 30.0)
        resumeBtn.setTitle("Resume", for: .normal)
        resumeBtn.addTarget(self, action: #selector(resumeAction), for: .touchUpInside)
        view.addSubview(resumeBtn)

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100.0, height: 30))
        label.center = CGPoint(x: view.center.x, y: view.center.y - 100)
        label.textAlignment = .center
        view.addSubview(label)

        timer = DKPauseableTimer(timeInterval: 1.0, repeats: true, autoPauseInBackground: true, block: { [weak self] (_) in
            guard let self = self else { return }
            self.count += 1
            label.text = "\(self.count)"
        })
    }

    @objc func pauseAciton() {
        timer?.pause()
    }
    @objc func resumeAction() {
        timer?.resume()
    }
    deinit {
        timer?.invalidate()
    }
}

