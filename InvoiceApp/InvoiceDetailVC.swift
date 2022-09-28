import UIKit
import CoreData

class InvoiceDetailVC: UIViewController
{
	@IBOutlet weak var productTF: UITextField!
	@IBOutlet weak var buyerTV: UITextView!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var delButton: UIButton!
	
	var selectedInvoice: Invoice? = nil
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		if(selectedInvoice != nil)
		{
			productTF.text = selectedInvoice?.product
			buyerTV.text = selectedInvoice?.buyer
            priceTF.text = selectedInvoice?.price
		}
        else{
            delButton.isHidden = true
        }
	}


	@IBAction func saveAction(_ sender: Any)
	{
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
		if(selectedInvoice == nil)
		{
			let entity = NSEntityDescription.entity(forEntityName: "Invoice", in: context)
			let newInvoice = Invoice(entity: entity!, insertInto: context)
            newInvoice.id = invoiceList.count as NSNumber
            newInvoice.product = productTF.text
            newInvoice.buyer = buyerTV.text
            newInvoice.price = priceTF.text
            newInvoice.date = Date()
			do
			{
				try context.save()
				invoiceList.append(newInvoice)
				navigationController?.popViewController(animated: true)
			}
			catch
			{
				print("context save error")
			}
		}
		else //edit invoice
		{
			let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Invoice")
			do {
				let results:NSArray = try context.fetch(request) as NSArray
				for result in results
				{
					let invoice = result as! Invoice
					if(invoice == selectedInvoice)
					{
                        invoice.product = productTF.text
                        invoice.buyer = buyerTV.text
                        invoice.price = priceTF.text
						try context.save()
						navigationController?.popViewController(animated: true)
					}
				}
			}
			catch
			{
				print("Fetch Failed")
			}
		}
	}
	
	@IBAction func DeleteInvoice(_ sender: Any)
	{
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Invoice")
    
		do {
			let results:NSArray = try context.fetch(request) as NSArray
			for result in results
			{
				let invoice = result as! Invoice
				if(invoice == selectedInvoice)
				{
                    invoice.deletedDate = Date()
					try context.save()
                    let alertController = UIAlertController(
                           title: "Te dhenat jane fshire!", message: "Kjo fature u fshi me sukses!", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(
                           title: "Ne rregull", style: .default, handler: { (action: UIAlertAction!) in
                            self.navigationController?.popViewController(animated: true)
                           });
                    
                    alertController.addAction(defaultAction)
                    
                    present(alertController, animated: true, completion: nil)
                    
				}
			}
		}
		catch
		{
			print("Fetch Failed")
		}
	}
	
}

