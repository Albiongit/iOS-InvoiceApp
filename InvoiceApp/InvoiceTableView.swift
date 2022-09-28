import UIKit
import CoreData
import Foundation

var invoiceList = [Invoice]()

class InvoiceTableView: UITableViewController
{
	var firstLoad = true
	
	func nonDeletedInvoices() -> [Invoice]
	{
		var noDeleteInvoiceList = [Invoice]()
		for invoice in invoiceList
		{
			if(invoice.deletedDate == nil)
			{
				noDeleteInvoiceList.append(invoice)
			}
		}
		return noDeleteInvoiceList
	}
	
	override func viewDidLoad()
	{
		if(firstLoad)
		{
			firstLoad = false
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
			let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Invoice")
			do {
				let results:NSArray = try context.fetch(request) as NSArray
				for result in results
				{
					let invoice = result as! Invoice
					invoiceList.append(invoice)
				}
			}
			catch
			{
				print("Fetch Failed")
			}
		}
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        
		let invoiceCell = tableView.dequeueReusableCell(withIdentifier: "invoiceCellID", for: indexPath) as! InvoiceCell
		
		let thisInvoice: Invoice!
		thisInvoice = nonDeletedInvoices()[indexPath.row]
		
        invoiceCell.productLabel.text = thisInvoice.product
        invoiceCell.dateLabel.text = dateFormatter.string(from: thisInvoice.date!)
        invoiceCell.priceLabel.text = thisInvoice.price + " euro"
		
		return invoiceCell
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return nonDeletedInvoices().count
	}
	
	override func viewDidAppear(_ animated: Bool)
	{
		tableView.reloadData()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		self.performSegue(withIdentifier: "editInvoice", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if(segue.identifier == "editInvoice")
		{
			let indexPath = tableView.indexPathForSelectedRow!
			
			let invoiceDetail = segue.destination as? InvoiceDetailVC
			
			let selectedInvoice : Invoice!
			selectedInvoice = nonDeletedInvoices()[indexPath.row]
			invoiceDetail!.selectedInvoice = selectedInvoice
			
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}
	
	
}
