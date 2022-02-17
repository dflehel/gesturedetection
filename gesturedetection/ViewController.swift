//
//  ViewController.swift
//  gesturedetection
//
//  Created by Lehel Dénes-Fazakas on 2022. 02. 15..
//

import UIKit
import WatchConnectivity//1

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var filename: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func savebuttonpressed(_ sender: Any) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
      //  print(filename.text!)
        delegate.updatethefile(filename: filename.text!)
        self.view.endEditing(true)
    }
    
}

