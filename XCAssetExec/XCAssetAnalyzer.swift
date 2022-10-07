//
//  XCAssetAnalyzer.swift
//  XCAssetExec
//
//  Created by TrucPham on 07/10/2022.
//

import Foundation
enum XCAssetType : String {
    case color = "color"
    case image = "image"
    var getValue : String {
        return self.rawValue + "set"
    }
}
class XCAssetAnalyzer {
    init(urlToXCAsset:URL, xctype : [XCAssetType], iOSTarget: Double = 11.0) {
        self.iOSTarget = iOSTarget
        self.rootURL = urlToXCAsset
        self.xctype = xctype
    }
    
    private let xctype : [XCAssetType]
    private let iOSTarget : Double
    private let rootURL:URL
    private lazy var fileManager = FileManager()
    
    lazy var allSubUrls:[URL] = {
        func subUrls(_ url : URL) -> [URL]{
            var res : [URL] = [url]
            let suburls = (try? fileManager
                .contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])) ?? []
            guard !suburls.isEmpty else { return res }
            suburls.forEach{
                res.append(contentsOf: subUrls($0))
            }
            return res
        }
        return subUrls(rootURL)
    }()
    
    
    func fileContents()->Data {
        var res = topBoilerPlate()
        if self.xctype.contains(.color){
            if iOSTarget >= 11 {
                res += UIColorGenerator(colorNames: filterNames(.color)).generateUIKitFile()
                res += UIColorGenerator(colorNames: filterNames(.color)).generateSwiftUIFile()
            }
            else {
                let urls = filterFolder(.color)
                res += UIColorGenerator(colorNames: []).generateUIColorFileRGB(urls)
            }
        }
        if self.xctype.contains(.image){
            res += UIImageGenerator(imageNames: filterNames(.image)).generateUIKitFile()
            res += UIImageGenerator(imageNames: filterNames(.image)).generateSwiftUIFile()
        }
        
       
        
        
        res += bottomBoilerPlate()
        return res.data(using: .utf8)!
    }
    
    func filterNames(_ xctype : XCAssetType) -> [String] {
        return filterFolder(xctype)
            .map({ $0.deletingPathExtension() })
            .map({ $0.lastPathComponent })
    }
    func filterFolder(_ xctype : XCAssetType) -> [URL] {
        return allSubUrls
            .filter({ $0.pathExtension == xctype.getValue })
    }
    
    func topBoilerPlate()->String {
        "import UIKit\nimport SwiftUI\n"
    }
    func bottomBoilerPlate()->String {
        return ("""

extension Bundle {
    fileprivate static let designConstants:Bundle = Bundle(for:DesignConstantsAnchor.self)
}
fileprivate class DesignConstantsAnchor { }

""")
    }
}
