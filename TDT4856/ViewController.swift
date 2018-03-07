import UIKit
import SwiftSocket
import SwiftLocation
import Foundation
import SwiftHTTP
import CoreLocation

class ViewController: UIViewController
{
    @IBOutlet weak var btn_enable: UIButton!
    
    @IBOutlet weak var stro_switch: UISwitch!
    @IBOutlet weak var broyt_switch: UISwitch!
    @IBOutlet weak var salt_switch: UISwitch!
    @IBOutlet weak var fresing_switch: UISwitch!
    @IBOutlet weak var skraping_switch: UISwitch!
    
    let interval = 2
    var data = ""
    var prev_long = 0.0
    var prev_lat = 0.0
    var long = 0.0
    var lat = 0.0
    var SwiftTimer = Timer()
    var id = ""
    //var host = "http://10.24.34.11:5000/events"
    //var host = "https://requestb.in/ussk9ous"
    var host = "http://10.24.34.11:5000/events"
    
    var posList = [[String: Any]]()
    
    //let params = ["lat": loc.coordinate.latitude, "lng": loc.coordinate.longitude, "time": //loc.timestamp.timeIntervalSince1970.rounded(), "type": types as Any, "id": self.id as Any] as [String : Any]
    
    var count=0;
    var listSize = 1
    
    struct Response: Codable
    {
        let status: String?
        let error: String?
    }
    
    override func viewDidLoad()
    {
        btn_enable.backgroundColor = UIColor.FlatColor.Blue.Mariner
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func action_enable(_ sender: Any)
    {
        if btn_enable.backgroundColor == UIColor.FlatColor.Blue.Mariner
        {
            btn_enable.backgroundColor = UIColor.FlatColor.Red.Cinnabar
            btn_enable.setTitle( "Disable GPS" , for: .normal )
            
            var types = ""
            
            if(self.salt_switch.isOn)
            {
                types = ", Salting"
            }
            if(self.stro_switch.isOn)
            {
                types += ", Stroying"
            }
            if(self.broyt_switch.isOn)
            {
                types += ", Broyting"
            }
            if(self.fresing_switch.isOn)
            {
                types += ", Fresing"
            }
            if(self.skraping_switch.isOn)
            {
                types += ", Skraping"
            }
            
            let params = ["type": types as Any] as [String : Any]
            
            HTTP.POST("http://10.24.34.11:5000/login", parameters: params)
            { response in
                self.id = response.text!
            }
            start_timer();
        }
        else if btn_enable.backgroundColor == UIColor.FlatColor.Red.Cinnabar
        {
            btn_enable.backgroundColor = UIColor.FlatColor.Blue.Mariner
            btn_enable.setTitle( "Enable GPS" , for: .normal )
            stop_timer()
        }
    }
    
    func get_location()
    {
        Locator.currentPosition(accuracy: .room, onSuccess: { loc in
            self.data = ("\(loc.coordinate.latitude),\(loc.coordinate.longitude),\(Int32(loc.timestamp.timeIntervalSince1970.rounded())) \n")
            self.lat = loc.coordinate.latitude
            self.long = loc.coordinate.longitude
            
            var types = ""
            
            if(self.salt_switch.isOn)
            {
                types = ", Salting"
            }
            if(self.stro_switch.isOn)
            {
                types += ", Stroying"
            }
            if(self.broyt_switch.isOn)
            {
                types += ", Broyting"
            }
            if(self.fresing_switch.isOn)
            {
                types += ", Fresing"
            }
            if(self.skraping_switch.isOn)
            {
                types += ", Skraping"
            }
            
            let params = ["lat": loc.coordinate.latitude, "lng": loc.coordinate.longitude, "time": loc.timestamp.timeIntervalSince1970.rounded(), "type": types as Any, "id": self.id as Any] as [String : Any]
     
            
            if(self.lat == self.prev_lat)
            {
                print("Duplicate coords!")
            }
            else if(self.long == self.prev_long)
            {
                print("Duplicate coords!")
            }
            else
            {
                self.posList.append(params);
                self.count += 1;
                
                if(self.count > self.listSize)
                {
                    print(self.posList)
                    HTTP.POST(self.host, parameters: self.posList)
                    { response in
                        //print(response)
                        if let error = response.error {
                            print("got an error: \(error)")
                            return
                        }
                    }
                    self.count=0;
                    self.posList.removeAll();
                }
                //print(params)
            }
        }) { err, _ in
            //print("\(err)")
        }
        self.prev_long = long
        self.prev_lat = lat
    }
    
    func check_duplicate()
    {
        
    }
    
    func start_timer()
    {
            self.SwiftTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
                self.get_location()
            })
    }
    
    func stop_timer()
    {
        SwiftTimer.invalidate()
    }
}

