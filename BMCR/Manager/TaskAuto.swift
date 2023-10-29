//
//  TaskAuto.swift
//  BMCR
//
//  Created by Nich on 10/13/23.
//

import Foundation
import Cocoa

// .txt data file format [character/s to be sent]-[delay in ms],[how many times it will be sent]*

// where:
//
// - => separates [character/s to be sent] and [delay in ms]
// , => separates [delay in ms] and [how many times it will be sent]
// * => End of instruction
//

// Examples:
// a-50,2*
// b-30,3*
// c-100,1*

class StatusManager: ObservableObject {
    @Published var terminalOutput: [String] = []

    func addToTerminalOutput(_ message: String) {
        terminalOutput.append(message)
    }
}

class TaskAuto {
    
    var statusManager: StatusManager?
    
    init(statusManager: StatusManager) {
        self.statusManager = statusManager
    }
    
    func executeInstructionsFromFile(filePath: String) {
        if let content = try? String(contentsOfFile: filePath) {
            let instructions = content.components(separatedBy: "*")
            for instruction in instructions {
                let components = instruction.components(separatedBy: "-")
                if components.count == 2 {
                    let keys = components[0]
                    let params = components[1].components(separatedBy: ",")
                    if params.count == 2,
                       let delay = Double(params[0]),
                       let repeatCount = Int(params[1]) {
                        let message = """
                        Instruction: \(keys)
                        Character to be sent: \(keys)
                        Delay (ms): \(delay)
                        Times to be sent: \(repeatCount)
                        """
                        statusManager?.addToTerminalOutput(message)
                        simulateKeyEvents(keys: keys, delay: delay, repeatCount: repeatCount)
                    }
                }
            }
        } else {
            print("Failed to read file at path: \(filePath)")
        }
    }

    
    //    func runMacroInstruction(instruction: String) {
    //        let components = instruction.components(separatedBy: "-")
    //        if components.count == 2 {
    //            let keys = components[0]
    //            let params = components[1].components(separatedBy: ",")
    //            if params.count == 2,
    //               let delay = Double(params[0]),
    //               let repeatCount = Int(params[1]) {
    //                simulateKeyEvents(keys: keys, delay: delay, repeatCount: repeatCount)
    //            }
    //        }
    //    }
    
//    func runMacroInstruction(instruction: String) {
//        let components = instruction.components(separatedBy: "-")
//        if components.count == 2 {
//            let keys = components[0]
//            let params = components[1].components(separatedBy: ",")
//            if params.count == 2,
//               let delay = Double(params[0]),
//               let repeatCount = Int(params[1]) {
//                let message = """
//                Instruction: \(keys)
//                Character to be sent: \(keys)
//                Delay (ms): \(delay)
//                Times to be sent: \(repeatCount)
//                """
//                statusManager?.addToTerminalOutput(message)
//                simulateKeyEvents(keys: keys, delay: delay, repeatCount: repeatCount)
//            }
//        }
//    }

    func simulateKeyEvents(keys: String, delay: Double, repeatCount: Int) {
        let source = CGEventSource(stateID: .hidSystemState)

        for _ in 0..<repeatCount {
            for key in keys {
                let keyCode = keyCodeForCharacter(String(key))
                let keyDownEvent = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: true)
                let keyUpEvent = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: false)

                keyDownEvent?.post(tap: .cghidEventTap)
                usleep(useconds_t(delay * 1000)) // Delay in microseconds
                keyUpEvent?.post(tap: .cghidEventTap)
            }
        }
    }

    func keyCodeForCharacter(_ character: String) -> CGKeyCode {
        return CGKeyCode(character.lowercased().utf16.first!)
    }
}

// let taskAuto = TaskAuto()
//taskAuto.executeInstructionsFromFile(filePath: "script.txt")

