import Cocoa
import CoreBluetooth

class ViewController: NSViewController {
    @IBOutlet var label: NSView!
    
    var peripheralManager:CBPeripheralManager?
    let uuid:CBUUID = CBUUID(string: "DCEF54A2-31EB-467F-AF8E-350FB641C97B")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
}

extension ViewController : CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if (peripheral.state == .unsupported) {
            print("unsupported")
        }
        
        if (peripheral.state == .poweredOn) {
            label.insertText("self.peripheralManager powered on.")
            print("POWER ON")
            peripheralManager?.startAdvertising([CBAdvertisementDataLocalNameKey:"my-peripheral", CBAdvertisementDataServiceUUIDsKey: uuid])
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("started advertising")
        print(peripheral)
    }
}
