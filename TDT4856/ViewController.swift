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
    
    let port = 80
    let interval = 2
    var data = ""
    var SwiftTimer = Timer()
    //var host = "http://10.22.73.85:5000/events"
    //var host = "https://requestb.in/zs4kvtzs"
    var host = "http://10.22.78.203:80"
    
    struct Response: Codable
    {
        let status: String?
        let error: String?
    }
    
    override func viewDidLoad()
    {
        btn_enable.backgroundColor = UIColor.FlatColor.Blue.Mariner
        super.viewDidLoad()
        get_location()
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
    
    func get_location()
    {
        //Locator.requestAuthorizationIfNeeded(.always)
        self.modus_txt.text = "test"
        //let params = ["Lat": "hello world"] as [String : Any]
        //HTTP.POST(self.host, parameters: params)
        //{ response in
        //}

        Locator.currentPosition(accuracy: .room, onSuccess: { loc in
            //print("Find location \(loc)")
            self.data = ("\(loc.coordinate.latitude),\(loc.coordinate.longitude),\(Int32(loc.timestamp.timeIntervalSince1970.rounded())) \n")
       
            let params = ["Lat": loc.coordinate.latitude, "Long": loc.coordinate.longitude, "time": loc.timestamp.timeIntervalSince1970.rounded(), "type": self.modus_txt.text as Any, "id": self.id_txt.text as Any] as [String : Any]
            
            //HTTP.POST(self.host, parameters: params)
            //{ response in
             //   print(response)
            //}
        }) { err, _ in
            print("\(err)")
            self.modus_txt.text = "\(err)"
        }
        print(data)
    }
    
    func start_timer()
    {
        //SwiftTimer = Timer.scheduledTimer(timeInterval: Double(interval), target:self, selector: #selector(get_location), userInfo: nil, repeats: true)
            self.SwiftTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
                self.get_location()
            })
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

