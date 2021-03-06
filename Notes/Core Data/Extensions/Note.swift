//
//  Note.swift
//  Notes
//
//  Created by Abdul Basit on 25/06/20.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation

extension Note {
    var alphabetizedTags: [Tag]? {
        guard let tags = tags as? Set<Tag> else {
            return nil
        }
        
        return tags.sorted(by: {
            guard let tag0 = $0.name else { return true }
            guard let tag1 = $1.name else { return true }
            return tag0 < tag1
        })
    }
    
    var alphabetizedTagsAsString: String? {
        guard let tags = alphabetizedTags, tags.count > 0 else {
            return nil
        }
        let names = tags.compactMap { $0.name }
        return names.joined(separator: ", ")
    }
}
