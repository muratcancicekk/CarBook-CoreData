//
//  DataRemoveInformations.swift
//  MyCarProje
//
//  Created by Murat on 3.11.2021.
//

import Foundation
import UIKit
import CoreData


struct RemoveData{
    func tableView(_ tableView: UITableView,self:ViewController,entityName:String, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            // Core Data ve TableView üzerinden silme işleminin yapılması
            if editingStyle == .delete {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let idString = carIdArrays[indexPath.row].uuidString
                fetchrequest.predicate = NSPredicate(format: "id = %@", idString)
                fetchrequest.returnsObjectsAsFaults = false
                do{
                let results = try context.fetch(fetchrequest)
                    if results.count > 0 {
                        for result in results as! [NSManagedObject]{
                            if let id = result.value(forKey: "id") as? UUID  {
                                if id == carIdArrays[indexPath.row]{
                                    context.delete(result)
                                    carModelsArrays.remove(at: indexPath.row)
                                    carIdArrays.remove(at: indexPath.row)
                                    self.tableView.reloadData()
                                    do
                                    {
                                     try context.save()
                                    }
                                    catch
                                    {
                                    print("error")
                                    }
                                    break
                            }
                            }
                        }
                    }
                }
                catch{
                    print("error")
                }
                 
                
            }
        }




}

