//
//  Data+PrettyPrint.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 06/12/2024.
//

import Foundation

extension Data {
    func prettyPrintJSON() {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: self, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            if let prettyString = String(data: prettyData, encoding: .utf8) {
                print(prettyString)
            } else {
                print("Unable to decode JSON as String")
            }
        } catch {
            print("Failed to pretty print JSON: \(error)")
        }
    }
}
