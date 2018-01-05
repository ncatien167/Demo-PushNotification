//
//  ViewController.swift
//  Demo_PushNotification
//
//  Created by Apple on 1/5/18.
//  Copyright © 2018 ncatien167@gmail.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var remaningTime: UILabel!
    @IBOutlet weak var scheduleBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var repeatSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scheduleBtn.layer.cornerRadius = 20
        self.cancelBtn.layer.cornerRadius = 20
        
        self.datePicker.minimumDate = Date()
        self.datePicker.date = Date().addingTimeInterval(60)
    }
    
    //Button pressed to start schedule notifications
    @IBAction func schedule(_ sender: Any) {
        let nextDate = NotificationManager.shared.schdule(date: self.datePicker.date, repeats: self.repeatSwitch.isOn)
        if nextDate != nil {
            self.remaningTime.text = nextDate!.timeIntervalSinceNow.formattedTime
        }
    }
    
    //Button pressed to cancel all notifications and setting remaning time
    @IBAction func cancelAllNotifcations(_ sender: Any) {
        self.remaningTime.text = "0h 0m 0s"
        NotificationManager.shared.cancelAllNotifcations()
    }
    
}

extension TimeInterval {

    var formattedTime:String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.allowedUnits = [.hour,.minute,.second]
        formatter.calendar = Calendar.current
        return formatter.string(from: self) ?? ""
    }

}

extension Date {
    
    var formattedDate:String {
        let format = DateFormatter()
        format.timeZone = TimeZone.current
        format.timeStyle = .medium
        format.dateStyle = .medium
        return format.string(from: self)
    }
    
}











