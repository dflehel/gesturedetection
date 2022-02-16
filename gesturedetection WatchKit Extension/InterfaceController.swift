//
//  InterfaceController.swift
//  gesturedetection WatchKit Extension
//
//  Created by Lehel Dénes-Fazakas on 2022. 02. 15..
//

import WatchKit
import Foundation
import CoreMotion
import WatchConnectivity
import HealthKit


class InterfaceController: WKInterfaceController,WCSessionDelegate {

    
    let motion = CMMotionManager()
    let queue = OperationQueue()
    var view: InterfaceController?
    let sessionn = WCSession.default
    var session: HKWorkoutSession?
    let healthStore = HKHealthStore()
    

    
    @IBOutlet weak var jelzo: WKInterfaceButton!
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("comlite")
      }
    func sessionReachabilityDidChange(_ session: WCSession) {
        if (session.isReachable == false) {
            print("vege")
            motion.stopDeviceMotionUpdates()
            healthStore.end(self.session!)
        }
    }

    
      func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        print("received data: \(message)")
        if let value = message["iPhone"] as? String {//**7.1
         // self.label.setText(value)
            print("terminated")
            motion.stopDeviceMotionUpdates()
            healthStore.end(self.session!)
            
        }
      }
    
    @IBAction func stop() {
        motion.stopDeviceMotionUpdates()
        healthStore.end(self.session!)
        self.jelzo.setBackgroundColor(UIColor.red)
    }
    
    @IBAction func start() {
        self.starCollecting()
        self.jelzo.setBackgroundColor(UIColor.green)
    }
    
    
    
    func prepareForWatchConnectivity() {
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self //requires `WCSessionDelegate` protocol, so implement the required delegates as well
            session.activate()
      //      self.session = session
        }
    }
    
    
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
   
        //Application
        //self.prepareForWatchConnectivity()
     //   let delegatem = shared.delegate as! ExtensionDelegate
      //  delegatem.view = self
        print("elindul")
        sessionn.delegate = self
        sessionn.activate()
      //  self.starCollecting()
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
       // motion.deviceMotionUpdateInterval = 0.2//1.0 / Double(60)
         //      motion.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
           //        if error != nil {
             //          print("Encountered error: \(error!)")
               //    }
                   
                 //  if deviceMotion != nil {
                       
                        //let currenTime = self.returnCurrentTime()
                   //    let GyroX = deviceMotion!.rotationRate.x
                    //   let GyroY = deviceMotion!.rotationRate.y
                    //   let GyroZ = deviceMotion!.rotationRate.z
                       
                 
                    //   let AccX = deviceMotion!.gravity.x + deviceMotion!.userAcceleration.x;
                    //   let AccY = deviceMotion!.gravity.y + deviceMotion!.userAcceleration.y;
                     //  let AccZ = deviceMotion!.gravity.z + deviceMotion!.userAcceleration.z;
                       
                       // print ( "Gyro: \(currenTime) \(GyroX), \(GyroY), \(GyroZ)")
                       // print ( "Acc : \(currenTime) \(AccX), \(AccY), \(AccZ)")
                       
                       
                       //let sensorOutput = SensorOutput()
                       
                     //  sensorOutput.timeStamp = Date()
                     //  sensorOutput.gyroX = GyroX
                     //  sensorOutput.gyroY = GyroY
                     //  sensorOutput.gyroZ = GyroZ
                     //  sensorOutput.accX = AccX
                      // sensorOutput.accY = AccY
                     //  sensorOutput.accZ = AccZ
                      // print(GyroX)
                     //  print(AccX)
                      // self.sensorOutputs.append(sensorOutput)
                      // self.display.setText("\(AccX)")
                 //  }
              // }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    func starCollecting(){
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .walking
        workoutConfiguration.locationType = .outdoor
        
        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
        } catch {
            fatalError("Unable to create the workout session!")
       }
        
        // Start the workout session and device motion updates.
        healthStore.start(session!)
        if !motion.isDeviceMotionAvailable {
            print("Device Motion is not available.")
            return
        }
        
         motion.deviceMotionUpdateInterval = 1.0 / Double(50)
         motion.startDeviceMotionUpdates(to: .main) { (deviceMotion: CMDeviceMotion?, error: Error?) in
                   if error != nil {
                        print("Encountered error: \(error!)")
                    }
                    
                    if deviceMotion != nil {
                        
                        // let currenTime = self.returnCurrentTime()
                        let GyroX = deviceMotion!.rotationRate.x
                       let GyroY = deviceMotion!.rotationRate.y
                        let GyroZ = deviceMotion!.rotationRate.z
                        
                       let AccX = deviceMotion!.userAcceleration.x;
                        let AccY =  deviceMotion!.userAcceleration.y;
                        let AccZ =  deviceMotion!.userAcceleration.z;
                       let GraX = deviceMotion!.gravity.x
                        let GraY = deviceMotion!.gravity.y
                        let GraZ = deviceMotion!.gravity.z
                        // print ( "Gyro: \(currenTime) \(GyroX), \(GyroY), \(GyroZ)")
                        // print ( "Acc : \(currenTime) \(AccX), \(AccY), \(AccZ)")
                        
                        
                        //let sensorOutput = SensorOutput()
                        
                      //  sensorOutput.timeStamp = Date()
                      //  sensorOutput.gyroX = GyroX
                      //  sensorOutput.gyroY = GyroY
                      //  sensorOutput.gyroZ = GyroZ
                      //  sensorOutput.accX = AccX
                       // sensorOutput.accY = AccY
                      //  sensorOutput.accZ = AccZ
                      //  print(GyroX)
                        //print(AccX)
                       // self.sensorOutputs.append(sensorOutput)
                        let date = NSDate()
                        let data: [String: Any] = ["watch": "\(date.timeIntervalSince1970),\(AccX),\(AccY),\(AccZ),\(GyroX),\(GyroY),\(GyroZ),\(GraX),\(GraY),\(GraZ)\n" as Any] //Create your dictionary as per uses
                       self.sessionn.sendMessage(data, replyHandler: nil, errorHandler: nil)
                    //    print(AccX)
                        
                 }
                }
    
    }
}
