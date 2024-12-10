//
//  FlipDetectionManager.swift
//  MinGenie
//
//  Created by 김하준 on 9/6/24.
//

import CoreMotion
import Combine

final class FlipDetectionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private let motionTimeInterval: TimeInterval = 0.1

    private let flatThreshold = 0.3
    private let stationaryThreshold = 0.02
    private var previousGravityZ: Double = 0.0

    @Published var flipDetected = false
    @Published var flipFailed = false

    func startDetection() {
        flipDetected = false
        flipFailed = false
        previousGravityZ = 0.0
        startDeviceMotion()
    }

    func stopDetection() {
        stopFlipDetection()
    }

    /// Flip 감지 후, 뷰에서 특정 동작을 완료한 수 호출하는 메서드
    func markActionCompleted() {
        self.flipDetected = false
    }

    private func startDeviceMotion() {
        print("📲 DeviceMotion Start")

        guard motionManager.isDeviceMotionAvailable else { return }

        motionManager.deviceMotionUpdateInterval = motionTimeInterval
        motionManager.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] motionData, error in
            guard let self = self, let motionData = motionData else {
                return
            }

            self.detectDeviceStationary(motionData: motionData)
        }
    }

    private func detectDeviceStationary(motionData: CMDeviceMotion) {
        let totalAcceleration = calculateTotalAcceleration(userAcceleration: motionData.userAcceleration)

        if totalAcceleration < stationaryThreshold {
            print("🛑 Device is stationary. Starting flip detection.")
            detectFlipMotion(motionData: motionData)
        }
    }

    private func detectFlipMotion(motionData: CMDeviceMotion) {
        let gravity = motionData.gravity

        print("🔍 Gravity Z: \(gravity.z), Previous Gravity Z: \(previousGravityZ)")

        if (previousGravityZ < -0.9 && gravity.z > 0.9) || (previousGravityZ > 0.9 && gravity.z < -0.9) {
            print("🔄 Flip detected")
            DispatchQueue.main.async {
                self.flipDetected = true
                print("🔔 Flip detected - Console confirmed")
            }
        }

        previousGravityZ = gravity.z
    }

    private func calculateTotalAcceleration(userAcceleration: CMAcceleration) -> Double {
        return sqrt(pow(userAcceleration.x, 2) + pow(userAcceleration.y, 2) + pow(userAcceleration.z, 2))
    }

    private func stopFlipDetection() {
        motionManager.stopDeviceMotionUpdates()
        print("🛑 Stopped flip detection")
    }
}
