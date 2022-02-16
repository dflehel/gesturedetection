//
//  ExtensionDelegate.swift
//  gesturedetection WatchKit Extension
//
//  Created by Lehel Dénes-Fazakas on 2022. 02. 15..
//

import WatchKit
import CoreMotion
import WatchConnectivity
import HealthKit

class ExtensionDelegate: NSObject, WKExtensionDelegate,WCSessionDelegate  {
    
    
    
    
    
    
   // var session = WCSession.default
    let motion = CMMotionManager()
    let queue = OperationQueue()
    var view: InterfaceController?
    let sessionn = WCSession.default
    var session: HKWorkoutSession?
    let healthStore = HKHealthStore()
    
    
    
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

    
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
     //   print("elindul")
     //   sessionn.delegate = self
     //   sessionn.activate()
      //  self.starCollecting()
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    func applicationDidEnterBackground() {
        print("background")
       // motion.stopDeviceMotionUpdates()
       // healthStore.end(session!)
       // motion.deviceMotionUpdateInterval = 0.1//1.0 / Double(60)
       // motion.startDeviceMotionUpdates(to: .main) { (deviceMotion: CMDeviceMotion?, error: Error?) in
                  //if error != nil {
                   //    print("Encountered error: \(error!)")
                  // }
                   
                 //  if deviceMotion != nil {
                       
                       // let currenTime = self.returnCurrentTime()
                   //    let GyroX = deviceMotion!.rotationRate.x
                   //    let GyroY = deviceMotion!.rotationRate.y
                    //   let GyroZ = deviceMotion!.rotationRate.z
                       
                    //  let AccX = deviceMotion!.userAcceleration.x;
                    //   let AccY =  deviceMotion!.userAcceleration.y;
                    //   let AccZ =  deviceMotion!.userAcceleration.z;
                   //    let GraX = deviceMotion!.gravity.x
                  //     let GraY = deviceMotion!.gravity.y
                  //     let GraZ = deviceMotion!.gravity.z
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
                //       let data: [String: Any] = ["watch": "\(AccX)\n\(AccY)\n\(AccZ)\n\(GyroX)\n\(GyroY)\n\(GyroZ)\n\(GraX)\n\(GraY)\n\(GraZ)\n" as Any] //Create your dictionary as per uses
                 //      self.session.sendMessage(data, replyHandler: nil, errorHandler: nil)
                   //    print(AccX)
                       
               // }
              // }
    }
    
   // func applicationWillTerminate(_ application: UIApplication){
    //    print("terminated")
   // }
    
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
