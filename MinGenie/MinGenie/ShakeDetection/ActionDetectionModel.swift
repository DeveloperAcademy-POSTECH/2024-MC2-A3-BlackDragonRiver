//
//  ShakeDetectionModel.swift
//  MinGenie
//
//  Created by zaehorang on 5/18/24.
//

import CoreMotion

final class ShakeDetectionModel: ObservableObject {
    private let motionManager = CMMotionManager()
    private let motionTimeInterval: TimeInterval = 0.1
    
    // 상태 감지를 위한 임계값 수치
    private let minRollThreshold = 3.1
    private let minXYAccelerationThreshold = 0.6
    private let maxZAccelerationThreshold = 1.1
    private let minZAccelerationThreshold = 0.9
    
    private var isScreenDown = false
    private var isDetectingShake = false // Shake 감지 중인지 여부 확인
    private var isChangingMusicByShake = false  // 흔들기로 인해 음악이 바뀌는 중인지 여부 확인
    
    @Published var shakeDetected = false // 흔들림 감지 여부를 알리는 퍼블리시드 프로퍼티
    @Published var shakeFailed = false // 흔들림 감지 실패 여부 알리는 프로퍼티
    
    
    func startDetection() {
        startDeviceMotion()
    }
    
    func stopDetection() {
        stopShakeDetection()
        stopFaceDownDetection()
    }
    
    /// Shake 감지 후, 뷰에서 특정 동작을 완료한 수 호출하는 메서드
    func markActionCompleted() {
        self.shakeDetected = false
        
        // 다시 엎어진 상태라면 가속도계 다시 시작
        if self.isScreenDown {
            self.startAccelerometer()
        }
    }
    
    private func startDeviceMotion() {
        print("DeviceMotion Start")
        
        guard motionManager.isDeviceMotionAvailable else { return }
        
        motionManager.deviceMotionUpdateInterval = motionTimeInterval
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] motionData, error in
            if let error {
                print("Error: \(error.localizedDescription)")
                return
            } 
            
            guard let self = self, let motionData else { return }
            self.detectFaceDown(motionData)
        }
    }
    
    private func detectFaceDown(_ motionData: CMDeviceMotion) {
        let roll = abs(motionData.attitude.roll)
        
        // 디바이스가 엎어진 상태를 roll 값으로 확인
        if roll > minRollThreshold {
            if !isScreenDown { // 다른 상태에 있다가 엎어질 때
                self.isScreenDown = true
                self.startAccelerometer()
            }
        } else {
            if isScreenDown {  // 엎어져 있다가 상태가 변경될 떄
                self.isScreenDown = false
                self.stopShakeDetection()
            }
        }
    }
    
    private func startAccelerometer() {
        guard !isDetectingShake, motionManager.isAccelerometerAvailable else { return }
        
        isDetectingShake = true
        print("Accelerometer Start")
        
        motionManager.accelerometerUpdateInterval = motionTimeInterval
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (accelerationData, error) in
            if let error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let self = self, let accelerationData else { return }
            
            self.detectShake(accelerationData)
        }
    }
    
    private func detectShake(_ accelerationData: CMAccelerometerData) {
        let acceleration = accelerationData.acceleration
        
        let accXY = sqrt(pow(acceleration.x,2)) + sqrt(pow(acceleration.y,2))
        let accZ = abs(acceleration.z)
        
        if accXY > minXYAccelerationThreshold
            && accZ < maxZAccelerationThreshold
            && accZ > minZAccelerationThreshold {
            print("🐯 Device was shaken while face down")
            
            print("problem❗️❗️❗️: \(shakeDetected)")
            self.shakeDetected = true // 흔들림 감지 여부 업데이트
            self.shakeFailed = false
            
            self.stopShakeDetection()
        } else {
            print("❌ Shake detection failed")
            self.shakeFailed = true
        }
    }
    

    private func stopShakeDetection() {
        isDetectingShake = false
        motionManager.stopAccelerometerUpdates() // 흔들기 측정 멈추기
        print("❌ Accelerometer Stop")
    }

    private func stopFaceDownDetection() {
        motionManager.stopDeviceMotionUpdates()
    }
}
