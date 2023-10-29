//
//  ContentView.swift
//  BMCR
//
//  Created by Nich on 10/13/23.
//

//import SwiftUI
//
//struct ContentView: View {
//    @State private var terminalOutput: [String] = []
//    @State private var connectedDeviceType: String? = nil
//    let taskAuto = TaskAuto()
//
//    func addToTerminalOutput(_ message: String) {
//        terminalOutput.append(message)
//    }
//
//    func connectToDevice(deviceType: String) {
//        addToTerminalOutput("Connecting \(deviceType)...")
//        connectedDeviceType = deviceType
//    }
//
//    var body: some View {
//        ZStack {
//            Color.gray.edgesIgnoringSafeArea(.all)
//
//            VStack {
//
//                Spacer()
//                Text("Bluetooth Macro Sender")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(.gray)
//                    .padding(10)
//                    .background(Color.white)
//                    .cornerRadius(10)
//                    .padding(.bottom, 10)
//
//                VStack(spacing: 20) {
//
//                    Button(action: {
//                        addToTerminalOutput("Connecting Device...")
//                    }) {
//                        Text("Connect Device")
//                            .padding()
//                            .cornerRadius(10)
//                    }
//
//                    if let connectedDeviceType = connectedDeviceType {
//                        Text("Connected Device Type: \(connectedDeviceType)")
//                    }
//
//                    Button(action: {
//                        addToTerminalOutput("Loading script...")
//                        taskAuto.executeInstructionsFromFile(filePath: "script.txt")
//                    }) {
//                        Text("Load Script")
//                            .padding()
//                            .cornerRadius(10)
//                    }
//
//                    Button(action: {
//                        addToTerminalOutput("Starting macro...")
//                    }) {
//                        Text("Start Macro")
//                            .padding()
//                            .cornerRadius(10)
//                    }
//                }
//                .padding()
//
//                VStack(alignment: .leading) {
//                    Text("Status")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding(.bottom, 5)
//
//                    List(terminalOutput, id: \.self) { message in
//                        Text(message)
//                    }
//                    .frame(minWidth: 200, maxWidth: 300, minHeight: 100, maxHeight: 100)
//                    .background(Color.gray)
//                    .cornerRadius(10)
//                }
//                .padding()
//
//                Spacer()
//            }
//            .padding()
//        }
//        .frame(minWidth: 450, minHeight: 600)
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var bluetoothViewModel = BluetoothModel()
    let centralManager = CentralManager()

    @State private var isPeripheralListVisible = false
    @State private var terminalOutput: [String] = []
    @State private var connectedDeviceType: String? = nil
    @State private var isDeviceConnected = false
    @State private var isScriptLoaded = false
    @State private var isMacroStarted = false
    
    let statusManager = StatusManager()

    var taskAuto: TaskAuto?

    init() {
        self.taskAuto = TaskAuto(statusManager: statusManager)
    }

    
    func addToTerminalOutput(_ message: String) {
        terminalOutput.append(message)
    }
    
    func connectToDevice(deviceType: String) {
        addToTerminalOutput("Connecting \(deviceType)...")
        connectedDeviceType = deviceType
        isDeviceConnected = true
    }
    
    func startMacro() {
        isMacroStarted = true
        centralManager.startMacroExecution()
    }
    
    func executeMacroScript() {
        if isMacroStarted {
            addToTerminalOutput("Executing Macro...")
            taskAuto?.executeInstructionsFromFile(filePath: "script.txt")
        }
    }
    
//    var centralManager: CentralManager?
    
    var body: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Text("Bluetooth Macro Sender")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.bottom, 10)
                
                VStack(spacing: 20) {
                    
                    Button(action: {
                        // Toggle the visibility of the peripheral list
                        isPeripheralListVisible.toggle()

                        // Toggle the isDeviceConnected state if needed
                        if !isPeripheralListVisible {
                            isDeviceConnected = false
                        }
                    }) {
                        Text("Connect Device")
                            .padding()
                            .cornerRadius(10)
                            .disabled(isDeviceConnected)
                    }
                    
                    if let connectedDeviceType = connectedDeviceType {
                        Text("Connected Device Type: \(connectedDeviceType)")
                    }

                    if isPeripheralListVisible {
                        BluetoothViewModel()
                    }
                    
//                    BluetoothViewModel()

//                    Button(action: {
//                        addToTerminalOutput("Loading script...")
//                        taskAuto.executeInstructionsFromFile(filePath: "script.txt")
//                        isScriptLoaded = true
//                    }) {
//                        Text("Load Script")
//                            .padding()
//                            .cornerRadius(10)
//                            .disabled(isScriptLoaded)
//                    }
                    
                    Button(action: {
//                        addToTerminalOutput("Starting macro...")
                        isMacroStarted = true
                        centralManager.startMacroExecution()

                        // Call the executeMacroScript function
                        executeMacroScript()
                    }) {
                        Text("Start Macro")
                            .padding()
                            .cornerRadius(10)
                            .disabled(!isScriptLoaded || isMacroStarted)
                    }
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Status")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    
                    //                    List(terminalOutput, id: \.self) { message in
                    //                        Text(message)
                    //                    }
                        List(terminalOutput, id: \.self) { message in
                            Text(message)
                                .id(UUID())
                        }
                        .frame(minWidth: 200, maxWidth: 300, minHeight: 100, maxHeight: 100)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                .padding()
                Spacer()
            }
            .padding()
        }
        .frame(minWidth: 450, minHeight: 600)
        .onChange(of: isMacroStarted) { newValue in
            if newValue {
                taskAuto?.executeInstructionsFromFile(filePath: "script.txt")
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
