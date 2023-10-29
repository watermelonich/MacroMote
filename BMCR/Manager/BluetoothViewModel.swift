//
//  BluetoothViewModel.swift
//  BMCR
//
//  Created by Nich on 10/27/23.
//


//            List(bluetoothViewModel.peripheralNames, id: \.self) { peripheral in
//                Button(action: {
//                    if let selectedPeripheral = bluetoothViewModel.getPeripherals().first(where: { $0.name == peripheral }) {
//                        bluetoothViewModel.selectedPeripheral = selectedPeripheral
//                    }
//                }) {
//                    Text(peripheral)
//                }
//            }

//struct BluetoothViewModel: View {
//    @ObservedObject private var bluetoothViewModel = BluetoothModel()
//
//    var body: some View {
//        NavigationView {
//            List(bluetoothViewModel.peripheralNames, id: \.self) { peripheral in
//                Text(peripheral)
//            }
//            .frame(width: 300, height: 100)
//        }
//        .frame(width: 300, height: 100)
//    }
//}


import SwiftUI
import CoreBluetooth

class BluetoothModel: NSObject, ObservableObject {
    private var centralManager: CBCentralManager?
    private var peripherals: [CBPeripheral] = []
    @Published var peripheralNames: [String] = []
    @Published var selectedPeripheral: CBPeripheral? = nil

    func selectPeripheral(_ peripheral: CBPeripheral) {
        self.selectedPeripheral = peripheral
    }

    func getPeripherals() -> [CBPeripheral] {
        return peripherals
    }
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
}

extension BluetoothModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            self.peripherals.append(peripheral)
            self.peripheralNames.append(peripheral.name ?? "unnamed device")
        }
    }

}

//struct BluetoothViewModel: View {
//    @ObservedObject private var bluetoothViewModel = BluetoothModel()
//    var centralManager: CentralManager
//
//     init() {
//         centralManager = CentralManager()
//     }
//
//    var body: some View {
//        NavigationView {
//
//
//            List {
//                ForEach(bluetoothViewModel.peripheralNames.indices, id: \.self) { index in
//                    Button(action: {
//                        if let selectedPeripheral = bluetoothViewModel.getPeripherals().first(where: { $0.name == bluetoothViewModel.peripheralNames[index] }) {
//                            bluetoothViewModel.selectedPeripheral = selectedPeripheral
//                        }
//                    }) {
//                        Text(bluetoothViewModel.peripheralNames[index])
//                    }
//                }
//            }
//            .frame(width: 300, height: 100)
//        }
//        .frame(width: 300, height: 100)
//    }
//}

struct BluetoothViewModel: View {
    @ObservedObject private var bluetoothViewModel = BluetoothModel()
    var centralManager: CentralManager

    init() {
        centralManager = CentralManager()
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(bluetoothViewModel.peripheralNames.indices, id: \.self) { index in
                    Button(action: {
                        if let selectedPeripheral = bluetoothViewModel.getPeripherals().first(where: { $0.name == bluetoothViewModel.peripheralNames[index] }) {
                            bluetoothViewModel.selectPeripheral(selectedPeripheral)
                            centralManager.connectToPeripheral(selectedPeripheral)
                        }
                    }) {
                        Text(bluetoothViewModel.peripheralNames[index])
                    }
                }
            }
            .frame(width: 300, height: 100)
        }
        .frame(width: 300, height: 100)
    }
}


struct BluetoothViewModel_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothViewModel()
    }
}
