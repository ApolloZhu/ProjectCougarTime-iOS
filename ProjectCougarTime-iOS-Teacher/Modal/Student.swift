//
//  Student.swift
//  ProjectCougarTime-iOS-Teacher
//
//  Created by Apollo Zhu on 11/7/17.
//  Copyright © 2017 Oakton High School. All rights reserved.
//

import Foundation

public struct Student {
    public let id: Int
    public let name: String?
    public let imageData: Data?
    init(id: Int, name: String? = nil, imageData: Data? = nil) {
        self.id = id
        self.name = name
        self.imageData = imageData
    }
}

extension Student: Equatable, Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
    
    public static func ==(lhs: Student, rhs: Student) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Student {
    func checkIn(at location: String) {
        print("#\(id) is at \(location)")
    }
}

#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit
    extension Student {
        public var image: UIImage? {
            if let data = imageData {
                return UIImage(data: data)
            }
            return nil
        }
        
        init(id: Int,
             name: String? = nil,
             image: UIImage) {
            let data = UIImagePNGRepresentation(image)
            self.init(id: id, name: name,
                      imageData: data)
        }
    }
#endif
