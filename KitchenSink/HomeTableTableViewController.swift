// Copyright 2016 Cisco Systems Inc
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import SparkSDK

class HomeTableTableViewController: UITableViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    private var registerState = "connecting"
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerPhone()
        updateStatusLabel()
    }
    
    // MARK: - Phone register
    
    func registerPhone() {
        Spark.phone.requestMediaAccess(Phone.MediaAccessType.AudioVideo) { granted in
            if !granted {
                Utils.showCameraMicrophoneAccessDeniedAlert(self)
            }
        }
        Spark.phone.register() { success in
            if success {
                self.registerState = "ok"
                self.updateStatusLabel()
            } else {
                self.registerState = "fail"
                self.showPhoneRegisterFailAlert()
            }
        }
    }
    
    // MARK: - UITableViewController
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 4 {
            Spark.deauthorize()
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - UI views
    
    private func updateStatusLabel() {
        statusLabel.text = "Powered by SDK v" + Spark.version
        statusLabel.text = statusLabel.text! + "\nRegistration to Cisco cloud : " + registerState
    }
    
    private func showPhoneRegisterFailAlert() {
        let alert = UIAlertController(title: "Alert", message: "Phone register fail", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}
