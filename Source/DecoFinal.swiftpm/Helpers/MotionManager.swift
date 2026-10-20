//
//  MotionManager.swift
//  Deco
//
//  Created by Aether on 21/02/2025.
//

import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()

    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    @Published var yaw: Double = 0.0

    private var baselinePitch: Double = 0.0
    private var baselineRoll: Double = 0.0

    private var baselineSet: Bool = false

    var effectivePitch: Double {
        pitch - baselinePitch
    }

    var effectiveRoll: Double {
        roll - baselineRoll
    }

    init() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0

        // start motion updates on the main queue
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] data, error in
            guard let data = data, error == nil, let self = self else { return }
            
            self.pitch = data.attitude.pitch
            self.roll = data.attitude.roll
            self.yaw = data.attitude.yaw

            // capture baseline on the first valid update.
            if !self.baselineSet {
                self.baselinePitch = self.pitch
                self.baselineRoll = self.roll
                self.baselineSet = true
            }
        }
    }

    func recenter() {
        baselinePitch = pitch
        baselineRoll = roll
    }

    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}
