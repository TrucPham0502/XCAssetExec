//
//  UIImageGenerator.swift
//  XCAssetExec
//
//  Created by TrucPham on 07/10/2022.
//

import Foundation
class UIImageGenerator {
    
    let imageNames:[String]
    
    init(imageNames:[String]) {
        self.imageNames = imageNames
    }
    
    lazy var moduleName:String = {
        return ".designConstants"
    }()
    
    func imageConstantDeclaration(for imageName:String)->String {
        return "\tstatic let tp\(imageName.swiftyStaticVariableName):UIImage = UIImage(named:\"\(imageName)\", in:\(moduleName), compatibleWith:nil)!"
    }
    
    
    func imageSwiftUIConstantDeclaration(for imageName:String)->String {
        return "\tstatic let tp\(imageName.swiftyStaticVariableName):Image = Image(\"\(imageName)\", bundle:\(moduleName))"
    }
    
   
    
    func generateUIKitFile()->String {
        return "@available(iOS 11.0, *)\nextension UIImage {\n"
        + imageNames
            .map({ imageConstantDeclaration(for:$0) })
            .joined(separator: "\n")
        + "\n}\n"
    }
    
    func generateSwiftUIFile()->String {
        return "@available(iOS 13.0, *)\nextension Image {\n"
        + imageNames
            .map({ imageSwiftUIConstantDeclaration(for:$0) })
            .joined(separator: "\n")
        + "\n}\n"
    }
}
