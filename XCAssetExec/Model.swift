//
//  Model.swift
//  XCAssetExec
//
//  Created by TrucPham on 07/10/2022.
//

import Foundation
// MARK: - ColorJSon
struct ColorJSon: Codable {
    let colors: [ColorElement]?
    let info: Info?
    
    // MARK: - ColorElement
    struct ColorElement: Codable {
        let color: ColorColor?
        let idiom: String?
        let appearances: [Appearance]?
    }
    
    // MARK: - Appearance
    struct Appearance: Codable {
        let appearance, value: String?
    }
    
    // MARK: - ColorColor
    struct ColorColor: Codable {
        let colorSpace: String?
        let components: Components?

        enum CodingKeys: String, CodingKey {
            case colorSpace = "color-space"
            case components
        }
    }

    // MARK: - Components
    struct Components: Codable {
        let alpha, blue, green, red: String
    }

    // MARK: - Info
    struct Info: Codable {
        let author: String?
        let version: Int?
    }
}





