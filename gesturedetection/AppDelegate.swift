//
//  AppDelegate.swift
//  gesturedetection
//
//  Created by Lehel Dénes-Fazakas on 2022. 02. 15..
//

import UIKit
import WatchConnectivity

@main
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var session :WCSession?
    var window: UIWindow?
    var filename:String?
    
    
    func updatethefile(filename:String){
        self.filename = filename
        
        self.savefirst(text: "", toDirectory: self.documentDirectory(), withFileName: "\(self.filename!).csv")
    }
    
    
    
    
    func sessionDidBecomeInactive(_ session: WCSession) {
      }
      
      func sessionDidDeactivate(_ session: WCSession) {
      }
      
      func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
      }
      
      func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
      //  print("received message: \(message)")
          
          let date = Date()

         



          let calendar = Calendar.current


          let components = calendar.dateComponents([.year,.month,.day], from: date)
          if let value = message["watch"] as? String {
              let fileName = "\(components.year!)-\(components.month!)-\(components.day!).csv"

                  self.save(text: value,
                            toDirectory: self.documentDirectory(),
                            withFileName: "\(self.filename!).csv")
              DispatchQueue.main.async { if let viewController = self.window?.rootViewController as? ViewController {
                  viewController.label.text = value
               }
              }
                  //self.read(fromDocumentsWithFileName: fileName)
          }
        //DispatchQueue.main.async { //6
          //if let value = message["watch"] as? String {
          //     }
        //}
      }
    func configureWatchKitSesstion() {
        
        if WCSession.isSupported() {//4.1
          session = WCSession.default//4.2
          session?.delegate = self//4.3
          session?.activate()//4.4
        }
      }
    func applicationWillTerminate(_ application: UIApplication) {
        let date = NSDate()
        let data: [String: Any] = ["watch": "\(date.timeIntervalSince1970)" as Any] //Create your dictionary as per uses
        self.session?.sendMessage(data, replyHandler: nil, errorHandler: nil)
       // self.session.
        print("terminated")
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       // self.prepareForWatchConnectivity()
        //let fileName = "testFile1.txt"

        //    self.save(text: "Some test content to write to the file",
        //              toDirectory: self.documentDirectory(),
        //              withFileName: fileName)
       //     self.read(fromDocumentsWithFileName: fileName)
        
        let date = Date()
        let datee = NSDate()
        let data: [String: Any] = ["watch": "\(datee.timeIntervalSince1970)" as Any] //Create your dictionary as per uses
        self.session?.sendMessage(data, replyHandler: nil, errorHandler: nil)
   
       



        let calendar = Calendar.current


        let components = calendar.dateComponents([.year,.month,.day], from: date)
        let fileName = "\(components.year!)-\(components.month!)-\(components.day!).csv"
        self.savefirst(text: "", toDirectory: self.documentDirectory(), withFileName: fileName)
        self.configureWatchKitSesstion()
      //  print(window)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                    .userDomainMask,
                                                                    true)
        return documentDirectory[0]
    }
    
    private func append(toPath path: String,
                        withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            
            return pathURL.absoluteString
        }
        
        return nil
    }
    
    private func read(fromDocumentsWithFileName fileName: String) {
        guard let filePath = self.append(toPath: self.documentDirectory(),
                                         withPathComponent: fileName) else {
                                            return
        }
        
        do {
            let savedString = try String(contentsOfFile: filePath)
            
            print(savedString)
        } catch {
            print("Error reading saved file")
        }
    }
    
    private func save(text: String,
                      toDirectory directory: String,
                      withFileName fileName: String) {
        guard let filePath = self.append(toPath: directory,
                                         withPathComponent: fileName) else {
            return
        }
        
        
        
        
        do {
            //try text.write(toFile: filePath,
              //             atomically: false,
              //             encoding: .utf8)
            
            let file: FileHandle? = FileHandle(forUpdatingAtPath: filePath)

            if file == nil {
                print("File open failed")
            } else {
                let data = (text as
                                NSString).data(using: String.Encoding.utf8.rawValue)
                try file?.seekToEnd()
                try file?.write(data!)
                try file?.closeFile()
            }
            
        } catch {
            print("Error", error)
            return
        }
        
        
    }
    private func savefirst(text: String,
                      toDirectory directory: String,
                      withFileName fileName: String) {
        guard let filePath = self.append(toPath: directory,
                                         withPathComponent: fileName) else {
            return
        }
        
        
        
        
        do {
            try text.write(toFile: filePath,
                           atomically: false,
                          encoding: .utf8)
            
            
            
        } catch {
            print("Error", error)
            return
        }
        
        
    }


}

