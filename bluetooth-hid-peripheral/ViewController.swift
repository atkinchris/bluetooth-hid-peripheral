import Cocoa
import CoreBluetooth

class ViewController: NSViewController {
    @IBOutlet weak var status: NSTextField!    
    
    var peripheralManager = CBPeripheralManager()
    let uuid:CBUUID = CBUUID(string: "DCEF54A2-31EB-467F-AF8E-350FB641C97B")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        status.isEditable = false
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
}

extension ViewController : CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if (peripheral.state == .poweredOn && !peripheralManager.isAdvertising) {
            status.stringValue = "Ready!"
            peripheralManager.startAdvertising([
                CBAdvertisementDataLocalNameKey:"BLE Keyboard",
                CBAdvertisementDataServiceUUIDsKey: uuid,
            ])
        }
        
        if (peripheral.state == .poweredOff && peripheralManager.isAdvertising) {
            peripheralManager.stopAdvertising()
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("started advertising")
    }
}
