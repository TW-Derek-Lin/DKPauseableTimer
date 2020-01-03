//
//  DKPauseableTimer.swift
//  DKPauseableTimerDemo
//
//  Created by Derek_Lin on 2020/1/3.
//  Copyright © 2020 Derek_Lin. All rights reserved.
//

import UIKit
import Foundation

class DKPauseableTimer: NSObject {
    private var timer: Timer
    private(set) var isPause: Bool = false
    private var pauseTime: TimeInterval = 0
    private var foregroundObserver: NSObjectProtocol?
    private var backgroundObserver: NSObjectProtocol?
    deinit {
        removeObserver()
    }
    private init(timeInterval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: repeats, block: block)
    }
    convenience init(timeInterval: TimeInterval, repeats: Bool, autoPauseInBackground: Bool = false, block: @escaping (Timer) -> Void) {
        self.init(timeInterval: timeInterval, repeats: repeats, block: block)
        self.autoPause(autoPauseInBackground)
    }
    private func removeObserver() {
        if let foregroundObserver = foregroundObserver {
            NotificationCenter.default.removeObserver(foregroundObserver)
        }
        if let backgroundObserver = backgroundObserver {
            NotificationCenter.default.removeObserver(backgroundObserver)
        }
    }
    private func autoPause(_ autoPause: Bool) {
        if autoPause {
            foregroundObserver = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: OperationQueue.main) { [weak self] (_) in
                if autoPause {
                    self?.resume()
                }
            }
            backgroundObserver = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: OperationQueue.main) { [weak self] (_) in
                if autoPause {
                    self?.pause()
                }
            }
        } else {
            removeObserver()
        }
    }
    func pause() {
        if !isPause {
            pauseTime = timer.fireDate.timeIntervalSinceNow
            timer.fireDate = Date.distantFuture
            isPause = true
        }
    }
    func resume() {
        if isPause {
            if timer.isValid {
                timer.fireDate = Date().addingTimeInterval(pauseTime)
            }
            isPause = false
        }
    }
    func invalidate() {
        timer.invalidate()
    }
}
