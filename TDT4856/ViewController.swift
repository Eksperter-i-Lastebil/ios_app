import UIKit
import SwiftSocket
import SwiftLocation
import Foundation
import SwiftHTTP
import CoreLocation

class ViewController: UIViewController
{
    @IBOutlet weak var btn_enable: UIButton!
    @IBOutlet weak var modus_txt: UITextField!
    @IBOutlet weak var id_txt: UITextField!

    let interval = 2
    var data = ""
    var prev_long = 0.0
    var prev_lat = 0.0
    var long = 0.0
    var lat = 0.0
    var SwiftTimer = Timer()
    var id = ""
    //var host = "http://10.24.33.107:5000/events"
    //var host = "https://requestb.in/ussk9ous"
    var host = "http://10.22.65.33:5000/events"
    
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
            
            let params = ["type": self.modus_txt.text as Any] as [String : Any]
            
            HTTP.POST("http://10.22.65.33:5000/login", parameters: params)
            { response in
                self.id = response.text!
                self.id_txt.text = self.id
            }
            
            /*
            HTTP.GET("http://10.22.65.33:5000/login") { response in
                if let err = response.error
                {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                self.id = response.text!
                print(self.id)
            }
 */
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
            let params = ["lat": loc.coordinate.latitude, "lng": loc.coordinate.longitude, "time": loc.timestamp.timeIntervalSince1970.rounded(), "type": self.modus_txt.text as Any, "id": self.id as Any] as [String : Any]
     
            if(self.lat == self.prev_lat)
            {
                //print("Duplicate coords!")
            }
            else if(self.long == self.prev_long)
            {
                //print("Duplicate coords!")
            }
            else
            {
                print(params)
                HTTP.POST(self.host, parameters: params)
                { response in
                    //print(response)
                }
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
            self.SwiftTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
                self.get_location()
            })
    }
    
    func stop_timer()
    {
        SwiftTimer.invalidate()
    }
}

