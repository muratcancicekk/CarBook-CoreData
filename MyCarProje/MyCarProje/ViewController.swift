//
//  ViewController.swift
//  MyCarProje
//
//  Created by Murat on 2.11.2021.
//

import UIKit
import CoreData
var carModelsArrays = [String]()
var carIdArrays = [UUID]()
var selectedCar = ""
var selectedCarId : UUID?

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
  
    
    
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonclicked))
        tableView.delegate=self
        tableView.dataSource=self
        getCoreData()
        
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
           
           NotificationCenter.default.addObserver(self, selector: #selector(getCoreData), name: NSNotification.Name("New Data"), object: nil)
       }
    
    @objc func addButtonclicked(){
           
           selectedCar = ""
           
           performSegue(withIdentifier: "toDetailsVC", sender: nil)
           
       }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
                cell.textLabel?.text = carModelsArrays[indexPath.row]
                return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carModelsArrays.count
    }
    
    @objc func getCoreData(){
            carModelsArrays.removeAll(keepingCapacity: false)
            carIdArrays.removeAll(keepingCapacity: false)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            
            let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "CarsInformations")
            fetchReq.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(fetchReq)
                for result in results as! [NSManagedObject] {
                    if let name =  result.value(forKey: "models") as? String{
                        carModelsArrays.append(name)
                    }
                    if let id = result.value(forKey: "id") as? UUID{
                        carIdArrays.append(id)
                        
                    }
                    self.tableView.reloadData()
                   
                }
                
            }
            catch{
                print("error")
            }
            
            
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Seçim Yapıldıysa Diğer Ekranı Haberdar Etmek
           if segue.identifier == "toDetailsVC" {
               
               let destinationVC = segue.destination as!   DetailsVC
               destinationVC.chosenCar = selectedCar
               destinationVC.chosenCarId = selectedCarId
               
           }
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          // Seçim Algılama
          selectedCar = carModelsArrays[indexPath.row]
          selectedCarId = carIdArrays[indexPath.row]
          performSegue(withIdentifier: "toDetailsVC", sender: nil)
      }
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

         // Core Data ve TableView üzerinden silme işleminin yapılması
         if editingStyle == .delete {
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             let context = appDelegate.persistentContainer.viewContext

             let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CarsInformations")
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


