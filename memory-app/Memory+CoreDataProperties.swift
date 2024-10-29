//
//  Memory+CoreDataProperties.swift
//  memory-app
//
//  Created by Leticia Bezerra on 08/10/24.
//
//

import Foundation
import CoreData


extension Memory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memory> {
        return NSFetchRequest<Memory>(entityName: "Memory")
    }

    @NSManaged public var data: Date?
    @NSManaged public var descricao: String?
    @NSManaged public var idmemory: UUID?
    @NSManaged public var titulo: String?
    @NSManaged public var redessociais: URL?
    @NSManaged public var midia: Set<Midia>

}

// MARK: Generated accessors for midia
extension Memory {

    @objc(addMidiaObject:)
    @NSManaged public func addToMidia(_ value: Midia)

    @objc(removeMidiaObject:)
    @NSManaged public func removeFromMidia(_ value: Midia)

    @objc(addMidia:)
    @NSManaged public func addToMidia(_ values: NSSet)

    @objc(removeMidia:)
    @NSManaged public func removeFromMidia(_ values: NSSet)

}

extension Memory : Identifiable {

}
