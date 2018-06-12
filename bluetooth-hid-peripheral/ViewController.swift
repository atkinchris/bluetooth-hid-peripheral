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
    func registerServices(_ peripheral: CBPeripheralManager) {
        let genericAccess = CBMutableService(type: Constants.GENERIC_ACCESS_UUID, primary: true)
        let deviceName = CBMutableCharacteristic(
            type: Constants.DEVICE_NAME_UUID,
            properties: CBCharacteristicProperties.read,
            value: "BLE Keyboard".data(using: .utf8),
            permissions: CBAttributePermissions.readable
        )
        let appearance = CBMutableCharacteristic(
            type: Constants.APPEARANCE_UUID,
            properties: CBCharacteristicProperties.read,
            value: Data(bytes: [9, 61]),
            permissions: CBAttributePermissions.readable
        )
        genericAccess.characteristics = [deviceName, appearance]
        peripheral.add(genericAccess)
        
        let hidService = CBMutableService(type: Constants.HID_SERVICE_UUID, primary: true)
        peripheral.add(hidService)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if (peripheral.state == .poweredOn && !peripheralManager.isAdvertising) {
            status.stringValue = "Ready!"
            registerServices(peripheral)
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
