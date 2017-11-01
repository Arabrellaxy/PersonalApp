//
//  MenuTableViewController.swift
//  Eat
//
//  Created by 谢艳 on 2017/10/19.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import UIKit
import CoreData

class MenuTableViewController: UITableViewController,NSFetchedResultsControllerDelegate,
                                MenuTableViewCellDelegate,UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate{
    var fetchResultController:NSFetchedResultsController<NSFetchRequestResult>!
    var selectedCell:MenuTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.estimatedRowHeight = 120;
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.initializeFetchedResultsController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initializeFetchedResultsController() {
        let request:NSFetchRequest = Foods.fetchRequest()
        let typeSort = NSSortDescriptor(key: "mealsType", ascending: true)
        let nameSotr = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [typeSort, nameSotr]
        
        let moc = CoreDataManager.shareInstance.persistentContainer.viewContext
        fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<NSFetchRequestResult>
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.fetchResultController.fetchedObjects?.count)!
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        let food:Foods = self.fetchResultController.object(at: indexPath) as! Foods
        cell.showFood(food: food)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food:Foods = self.fetchResultController.object(at: indexPath) as! Foods
//        self.performSegue(withIdentifier: "showFoodDetail", sender: food)
    }
    
    func menuTableViewCell(cell: MenuTableViewCell, uploadImage: Any) {
        self.selectedCell = cell

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let indexPath = self.tableView.indexPath(for: selectedCell!)
        let food:Foods = self.fetchResultController.object(at: indexPath!) as! Foods
        let (success,uniqueId) = FileHelper.shareInstance.saveImageToFile(image: image)
        if success {
            dismiss(animated: true, completion: nil)
            CoreDataManager.shareInstance.saveFoodEntityPropertyValue(uniqueId: food.foodID, propertyName: "imagePath", newValue: uniqueId)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
               break
        case .update:
                self.tableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
                break
        case .delete:
                break
            default:
                break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFoodDetail" {
            let cell:MenuTableViewCell = sender as! MenuTableViewCell
            let indexPath:IndexPath = tableView.indexPath(for: cell)!
            let food:Foods = self.fetchResultController.object(at: indexPath) as! Foods
            if let destinationVC = segue.destination as? FoodDetailTableViewController {
                destinationVC.food = food
            }
        }
    }
}
