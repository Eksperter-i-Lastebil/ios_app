import UIKit
import SwiftSocket
import SwiftLocation
import Foundation
import SwiftHTTP

class ViewController: UIViewController
{
    @IBOutlet weak var btn_enable: UIButton!
    let host = "10.22.78.203"
    
    let port = 80
    let interval = 2
    var data = ""
    var SwiftTimer = Timer()
    
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
    
    func send_http()
    {
        let params = [data]
         HTTP.POST("https://requestb.in/rsnod6rs:80", parameters: params)
       { response in
            //do things...
       }
        
        //HTTP.POST("http://10.22.70.161:5000", parameters: params)
        //{ response in
       //     //do things...
       // }
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
            start_timer();
        }
        else if btn_enable.backgroundColor == UIColor.FlatColor.Red.Cinnabar
        {
            btn_enable.backgroundColor = UIColor.FlatColor.Blue.Mariner
            btn_enable.setTitle( "Enable GPS" , for: .normal )
            stop_timer()
        }
    }
    
    @objc func get_location()
    {
        Locator.requestAuthorizationIfNeeded(.always)
        Locator.currentPosition(accuracy: .room, onSuccess: { loc in
            //print("Find location \(loc)")
            self.data = ("\(loc.coordinate.latitude),\(loc.coordinate.longitude),\(Int32(loc.timestamp.timeIntervalSince1970.rounded())) \n")
            
            let params = ["Lat": loc.coordinate.latitude, "Long": loc.coordinate.longitude, "time": loc.timestamp.timeIntervalSince1970.rounded(), "type": "ploging", "id": "#53"] as [String : Any]
            HTTP.POST("https://requestb.in/rsnod6rs", parameters: params) { response in
            }
        }) { err, _ in
            print("\(err)")
        }
        print(data)
    }
    
    func start_timer()
    {
        SwiftTimer = Timer.scheduledTimer(timeInterval: Double(interval), target:self, selector: #selector(get_location), userInfo: nil, repeats: true)
    }
    
    func stop_timer()
    {
        SwiftTimer.invalidate()
    }
    
    func send_data()
    {
        //send_http()
        //switch client?.send(string: data) {
        //case .success?:
        //    guard let data = client?.read(1024*10) else { return }
            
        //    if let response = String(bytes: data, encoding: .utf8)
        //    {
        //        //print(response)
        //    }
        //case .failure(let error)?:
        //    print(error)
        //
        //    default: break
        //}
    }
}

