
import CoreData

@objc(Invoice)
class Invoice: NSManagedObject
{
	@NSManaged var id: NSNumber!
	@NSManaged var product: String!
	@NSManaged var buyer: String!
	@NSManaged var deletedDate: Date?
    @NSManaged var price: String!
    @NSManaged var date: Date?
}
