//
//  main.swift
//  XCAssetExec
//
//  Created by TrucPham on 07/10/2022.
//

import Foundation


print("Hello, World!")

let arguments = ProcessInfo.processInfo.arguments
guard arguments.count > 2 else {
    fatalError("arguments.count = \(arguments.count), should be at least 3")
}

let inputFilePath = arguments[1]
let outputFilePath = arguments[2]
let xctype = arguments[3]
let iOSTarget = arguments[4]
let isXcodeProject : Bool = arguments.contains("--xcodeproject")


try XCAssetAnalyzer(urlToXCAsset: URL(string: inputFilePath)!, xctype: xctype.split(separator: ",").map{ XCAssetType(rawValue: String($0))! }, iOSTarget: Double(iOSTarget) ?? 11.0)
    .fileContents().write(to: URL(fileURLWithPath: outputFilePath))
