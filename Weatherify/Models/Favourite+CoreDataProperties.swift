//
//  Favourite+CoreDataProperties.swift
//  Weatherify
//
//  Created by Emre Çakır on 3.03.2024.
//
//

import Foundation
import CoreData

extension Favourite {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<Favourite> {
        return NSFetchRequest<Favourite>(entityName: "Favourite")
    }

    @NSManaged public var id: Int64
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var addedDate: Date?
}

extension Favourite: Identifiable {}
