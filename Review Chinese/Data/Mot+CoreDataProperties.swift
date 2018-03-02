import Foundation
import CoreData


extension Mot {
    
    convenience init(index:Int,character: String,pinyin:String,definition:String,score:Int,date:Double,exemple:String, insertInto context: NSManagedObjectContext?) {
        self.init(context: context!)
        self.character=character
        self.definition=definition
        self.pinyin=pinyin
        self.score=Int32(score)
        self.date=date
        self.index=Int32(index)
        self.exemple=exemple
        self.level = {
            switch self.index{
            case let x where x >= 1203:
                return 5
            case let x where x >= 603:
                return 4
            case let x where x >= 303:
                return 3
            case let x where x >= 153:
                return 2
            default:
                return 1
            }
            
            
        }()
        
    }

    

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mot> {
        return NSFetchRequest<Mot>(entityName: "Mot");
    }

    @NSManaged public var character: String!
    @NSManaged public var pinyin: String!
    @NSManaged public var definition: String!
    @NSManaged public var score: Int32
    @NSManaged public var date: Double
    @NSManaged public var index: Int32
    @NSManaged public var exemple: String!
    @NSManaged public var level: Int16
    
}
