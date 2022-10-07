//
//  String+Extension.swift
//  XCAssetExec
//
//  Created by TrucPham on 07/10/2022.
//

import Foundation
extension String {
    mutating func replaceCharacters(from set:CharacterSet, with string:String) {
        var targetIndex = endIndex
        while targetIndex > startIndex {
            guard let range = rangeOfCharacter(from: set, options: [.backwards], range: startIndex..<targetIndex) else { break }
            replaceSubrange(range, with: string)
            targetIndex = range.lowerBound
        }
    }
    func replacingCharacters(from set:CharacterSet, with string:String)->String {
        var newString = self
        newString.replaceCharacters(from: set, with: string)
        return newString
    }
    var swiftyStaticVariableName:String {
        //quick cheap implementation
        return self.replacingCharacters(from: .alphanumerics.inverted, with: "_")
    }
}
