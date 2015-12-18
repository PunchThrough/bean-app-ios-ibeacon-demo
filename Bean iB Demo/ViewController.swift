//
//  ViewController.swift
//  Bean iB Demo
//
//  Created by Matthew Lewis on 12/18/15.
//  Copyright © 2015 Punch Through Design. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BeaconInfoDelegate {

    @IBOutlet var container: UIView!
    @IBOutlet weak var insideRegionLabel: UILabel!
    @IBOutlet weak var beaconCountLabel: UILabel!
    @IBOutlet weak var beaconsFoundLabel: UILabel!
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.delegate = self
    }
    
    func foundBeacons(num: Int) {
        beaconCountLabel.text = "\(num)"
        if (num == 1) {
            beaconsFoundLabel.text = "iBeacon found"
        } else {
            beaconsFoundLabel.text = "iBeacons found"
        }
    }
    
    func enteredRegion() {
        insideRegionLabel.text = "Inside region"
    }
    
    func exitedRegion() {
        insideRegionLabel.text = "Outside region"
    }

}

