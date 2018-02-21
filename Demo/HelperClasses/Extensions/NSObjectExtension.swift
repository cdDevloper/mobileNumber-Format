//
//  NSObjectExtension.swift
//

import Foundation

extension NSObject {

    fileprivate func propertiesDictionaryOfMirror(_ mirror: Mirror?) -> [String:AnyObject] {

        var result = [String: AnyObject]()

        var keys = [String]()

        for object in (mirror?.children)! {

            if let name = object.label {

                keys.append(name)
            }
        }

        result = self.dictionaryWithValues(forKeys: keys) as [String : AnyObject]

        if let superMirror = mirror?.superclassMirror {

            let parentResult = self.propertiesDictionaryOfMirror(superMirror)

            result = result.merged(with: parentResult)
        }

        return result
    }

    func propertyDictionary() -> [String: AnyObject] {

        return self.propertiesDictionaryOfMirror(Mirror(reflecting: self))
    }
}

extension Dictionary {

    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }

    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}
