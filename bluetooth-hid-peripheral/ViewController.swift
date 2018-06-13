import Cocoa
import CoreBluetooth

class ViewController: NSViewController {
    @IBOutlet weak var status: NSTextField!    
    
    var peripheralManager = CBPeripheralManager()
    
    let hidService = CBMutableService(type: Constants.HID_SERVICE_UUID, primary: true)
    let genericAccess = CBMutableService(type: Constants.GENERIC_ACCESS_UUID, primary: true)
    let deviceName = CBMutableCharacteristic(type: Constants.DEVICE_NAME_UUID, properties: .read, value: "BLE Keyboard".data(using: .utf8), permissions: .readable)
    let appearance = CBMutableCharacteristic(type: Constants.APPEARANCE_UUID, properties: .read, value: Data(bytes: [9, 61]), permissions: .readable)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        status.isEditable = false
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
}

extension ViewController : CBPeripheralManagerDelegate {
    func registerServices(_ peripheral: CBPeripheralManager) {
        genericAccess.characteristics = [deviceName, appearance]
        peripheral.add(genericAccess)
        peripheral.add(hidService)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if (peripheral.state == .poweredOn && !peripheral.isAdvertising) {
            status.stringValue = "Ready!"
            registerServices(peripheral)
            peripheral.startAdvertising([
                CBAdvertisementDataLocalNameKey:"BLE Keyboard",
                CBAdvertisementDataServiceUUIDsKey: hidService.uuid,
            ])
        }
        
        if (peripheral.state == .poweredOff && peripheral.isAdvertising) {
            peripheralManager.stopAdvertising()
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("started advertising")
    }
}
