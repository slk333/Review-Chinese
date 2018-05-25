//
//  Mot+CoreDataProperties.swift
//  Review Chinese
//
//  Created by Antoine Weber on 02/03/2018.
//  Copyright © 2018 antoine weber. All rights reserved.
//
//

import Foundation
import CoreData


extension Mot {

    convenience init(index:Int,character: String,pinyin:String,definition:String,exemple:String,insertInto context: NSManagedObjectContext?) {
        self.init(context: context!)
        self.themeScore = 0
        self.versionScore = 0
        self.themeExpiration = 1000000000
        self.versionExpiration = 1000000000
        self.character = character
        self.definition = definition
        self.exemple = exemple
        self.pinyin = pinyin
        self.index = Int32(index)
        self.listName = {
            switch self.index{
            case let x where x >= 1203:
                return "HSK 5"
            case let x where x >= 603:
                return "HSK 4"
            case let x where x >= 303:
                return "HSK 3"
            case let x where x >= 153:
                return "HSK 2"
            default:
                return "HSK 1"
            }
            
            
        }()
        
    }
    
    
      @nonobjc public class func fetchRequest() -> NSFetchRequest<Mot> {
        return NSFetchRequest<Mot>(entityName: "Mot")
    }
    @NSManaged public var exemple: String?
    @NSManaged public var character: String?
    @NSManaged public var themeExpiration: Int64
    @NSManaged public var definition: String?
    @NSManaged public var index: Int32
    @NSManaged public var listName: String?
    @NSManaged public var pinyin: String?
    @NSManaged public var versionScore: Int16
    @NSManaged public var versionExpiration: Int64
    @NSManaged public var themeScore: Int16

}
