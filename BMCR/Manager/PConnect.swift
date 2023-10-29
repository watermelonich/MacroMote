//
//  PConnect.swift
//  BMCR
//
//  Created by Nich on 10/13/23.
//

//import Foundation
//import CoreBluetooth
//
//class PConnect: NSObject, CBPeripheralManagerDelegate {
//    var peripheralManager: CBPeripheralManager!
//    var characteristic: CBMutableCharacteristic?
//
//    override init() {
//        super.init()
//        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
//    }
//
//    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//        if peripheral.state == .poweredOn {
//            // Peripheral is powered on and ready to use
//
//            // Define your custom UUID as a CBUUID object
//            let serviceUUID = CBUUID(string: "3BBD0390-6585-467A-9524-5B36724F8891")
//
//            // Create a CBMutableService using the custom UUID
//            let service = CBMutableService(type: serviceUUID, primary: true)
//
//            // Create the characteristic
//            let characteristicUUID = CBUUID(string: "D9B3F4A1-674A-4B0F-8C2D-935DC3969701")
//            characteristic = CBMutableCharacteristic(type: characteristicUUID,
//                                                     properties: [.read, .write],
//                                                     value: nil,
//                                                     permissions: [.readable, .writeable])
//
//            // Add the characteristic to the service
//            service.characteristics = [characteristic!]
//
//            // Add the service to the peripheral manager
//            peripheralManager.add(service)
//
//            // Set up advertising data
//            let advertisingData: [String: Any] = [
//                CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
//                // Add other advertising data as needed
//            ]
//
//            // Start advertising
//            peripheralManager.startAdvertising(advertisingData)
//        } else if peripheral.state == .poweredOff {
//            // Peripheral is powered off
//            // You might want to handle this case
//        }
//    }
//
//    // Handle central connections
//    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
//        // Prepare the data you want to send
//        let dataToSend = "Welcome, central!".data(using: .utf8)!
//
//        // Send the initial data to the central
//        peripheralManager.updateValue(dataToSend, for: characteristic as! CBMutableCharacteristic, onSubscribedCentrals: [central])
//    }
//
//    // Send and receive data
//    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
//        // Send data to subscribed centrals
//        let dataToSend = "Hello, central!".data(using: .utf8)!
//        peripheralManager.updateValue(dataToSend, for: characteristic!, onSubscribedCentrals: nil)
//    }
//}
//
//
//extension PConnect {
//    // Function to send data to connected central
//    func sendDataToCentral(_ data: Data) {
//        peripheralManager.updateValue(data, for: characteristic!, onSubscribedCentrals: nil)
//    }
//}
