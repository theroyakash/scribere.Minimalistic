//
//  Document.swift
//  Scribere Minimalistic
//
//  Created by Roy Akash on 13/05/19.
//  Copyright © 2019 The Roy Akash Software, Company. All rights reserved.
//

import UIKit

enum FileError: Error{
    case invalidData
}

class Document: UIDocument {
    
    var text = ""
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        return Data(text.utf8)
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let contents = contents as? Data else{
            throw FileError.invalidData
        }
        
        text = String(decoding: contents, as: UTF8.self)
    }
}
