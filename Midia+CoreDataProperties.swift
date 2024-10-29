//
//  Midia+CoreDataProperties.swift
//  memory-app
//
//  Created by Leticia Bezerra on 08/10/24.
//
//

import Foundation
import CoreData


extension Midia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Midia> {
        return NSFetchRequest<Midia>(entityName: "Midia")
    }

    @NSManaged public var arquivo: Data?
    @NSManaged public var tipo: String?
    @NSManaged public var memory: Memory?

}

extension Midia : Identifiable {

}
