//
//  UIColorGenerator.swift
//  XCAssetExec
//
//  Created by TrucPham on 07/10/2022.
//

import Foundation
class UIColorGenerator {
    lazy var moduleName:String = {
        return ".designConstants"
    }()
    
    let colorNames:[String]
    init(colorNames:[String]) {
        self.colorNames = colorNames
    }
    func generateUIKitFile()->String {
        return "@available(iOS 11.0, *)\nextension UIColor {\n"
        + colorNames
            .map({ uiColorConstantDeclaration(for:$0) })
            .joined(separator: "\n")
        + "\n}\n"
    }
    
    func generateUIColorFileRGB(_ urls: [URL]) -> String {
        return "enum TPUserInterfaceStyle { case dark, light }\nextension UIColor {\n\tstatic var interfaceStyle : TPUserInterfaceStyle = .light\n"
        + urls.compactMap{
            let decoder = JSONDecoder()
            do {
                let jsonData = try Data(contentsOf: $0.appendingPathComponent("Contents.json"))
                let color = try decoder.decode(ColorJSon.self, from: jsonData)
                if let light = color.colors?[0].color?.components, let dark = color.colors?[1].color?.components {
                    return "\tstatic var tp\($0.deletingPathExtension().lastPathComponent) : UIColor {\n\t\tswitch interfaceStyle {\n\t\tcase .dark:\n\t\t\treturn UIColor(red: \(dark.red), green: \(dark.green), blue:  \(dark.blue), alpha: \(dark.alpha))\n\t\tcase .light:\n\t\t\treturn UIColor(red: \(light.red), green: \(light.green), blue:  \(light.blue), alpha: \(light.alpha))\n\t\t}\n\t}"
                }
            } catch {
                print(error.localizedDescription)
            }
            return nil
        }.joined(separator: "\n") + "\n}\n"
    }
    
    func uiColorConstantDeclaration(for colorName:String)->String {
        return "\tstatic let tp\(colorName.swiftyStaticVariableName):UIColor = UIColor(named:\"\(colorName)\", in:\(moduleName), compatibleWith:nil)!"
    }
    
    
    func generateSwiftUIFile()->String {
        return "@available(iOS 13.0, *)\nextension Color {\n"
            + colorNames
                .map({ swiftUIColorConstantDeclaration(for:$0) })
                .joined(separator: "\n")
            + "\n}\n"
    }
    
    func swiftUIColorConstantDeclaration(for colorName:String)->String {
        return "\tstatic let tp\(colorName.swiftyStaticVariableName):Color = Color(\"\(colorName)\", bundle:\(moduleName))"
    }
    
}
