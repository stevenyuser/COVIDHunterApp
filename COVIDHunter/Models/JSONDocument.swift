//
//  JSONDocument.swift
//  COVIDHunter
//
//  Created by Steven Yu on 7/27/22.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI

struct JSONDocument: FileDocument {
    
    var json: String = ""
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            json = String(decoding: data, as: UTF8.self)
        }
    }
    
    init(results: ResultModel) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(results)
        json = String(data: data, encoding: .utf8)!
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(json.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
    
    static var readableContentTypes = [UTType.json]
}
