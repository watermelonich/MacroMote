//
//  MConnect.swift
//  BMCR
//
//  Created by Nich on 10/27/23.
//

import Foundation
import CoreBluetooth

//class CentralManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
//    var centralManager: CBCentralManager!
//    var characteristic: CBCharacteristic?
//    var selectedPeripheral: CBPeripheral?
//    let taskAuto = TaskAuto()
//
//    override init() {
//        super.init()
//        centralManager = CBCentralManager(delegate: self, queue: nil)
//    }
//
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if central.state == .poweredOn {
//            // Central is powered on and ready to use
//
//            // Start scanning for any nearby peripherals
//            centralManager.scanForPeripherals(withServices: nil, options: nil)
//        } else if central.state == .poweredOff {
//            // Central is powered off
//            // You might want to handle this case
//        }
//    }
//
//    // Function to connect to a selected peripheral
//    func connectToPeripheral(_ peripheral: CBPeripheral) {
//        selectedPeripheral = peripheral
//        centralManager.connect(peripheral, options: nil)
//    }
//
//    // Handling discovered services
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        if let services = peripheral.services {
//            for service in services {
//                // You can check the service UUID to identify the service you want.
//                if service.uuid == CBUUID(string: "3BBD0390-6585-467A-9524-5B36724F8891") {
//                    peripheral.discoverCharacteristics(nil, for: service)
//                }
//            }
//        }
//    }
//
//    // Handling discovered characteristics
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        if let characteristics = service.characteristics {
//            for characteristic in characteristics {
//                // You can check the characteristic UUID to identify the characteristic you want.
//                if characteristic.uuid == CBUUID(string: "D9B3F4A1-674A-4B0F-8C2D-935DC3969701") {
//                    self.characteristic = characteristic
//                }
//            }
//        }
//    }
//
//    // Function to handle received data from peripheral
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        if let data = characteristic.value {
//            // Assuming data is a string containing the file path of script.txt
//            if let filePath = String(data: data, encoding: .utf8) {
//                taskAuto.executeInstructionsFromFile(filePath: filePath)
//            }
//        }
//    }
//}

//func centralManagerDidUpdateState(_ central: CBCentralManager) {
//    if central.state == .poweredOn {
//        centralManager?.scanForPeripherals(withServices: [CBUUID(string: "SERVICE-ID")], options: nil)
//    }
//}
//
//func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//    if peripheral.name?.contains("iPhone") ?? false {
//        centralManager?.connect(peripheral, options: nil)
//    }
//}
//
//
//func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//    peripheral.discoverServices([CBUUID(string: "SERVICE-ID-STRING")])
//}
//
//func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//    guard let services = peripheral.services else { return }
//    for service in services {
//        let charId = CBUUID(string: "CHARACTERISTIC-ID")
//        peripheral.discoverCharacteristics([charId], for: service)
//    }
//}

class CentralManager: NSObject, CBCentralManagerDelegate {
    var centralManager: CBCentralManager!
    var selectedPeripheral: CBPeripheral?
    var taskAuto: TaskAuto?
    var statusManager = StatusManager()
    
    init(statusManager: StatusManager) {
        super.init()
        self.statusManager = statusManager
        self.taskAuto = TaskAuto(statusManager: statusManager)
    }
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager?.scanForPeripherals(withServices: nil, options: nil) // Scan for all devices
        } else if central.state == .poweredOff {
            // Handle powered off state
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Check if this is the selected peripheral
        if let selectedPeripheral = self.selectedPeripheral, peripheral == selectedPeripheral {
            centralManager?.connect(peripheral, options: nil)
        }
    }
    
    // Function to connect to a selected peripheral
    func connectToPeripheral(_ peripheral: CBPeripheral) {
        selectedPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // Handle the connected device
    }

    // Function to start macro execution
    func startMacroExecution() {
        taskAuto?.executeInstructionsFromFile(filePath: "script.txt")
    }
    
}

