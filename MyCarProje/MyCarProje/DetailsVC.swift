//
//  DetailsVC.swift
//  MyCarProje
//
//  Created by Murat on 2.11.2021.
//
import CoreData
import UIKit

class DetailsVC: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var carModelsArrays = [String]()
    var carIdArrays = [UUID]()
    var selectedCar = ""
    var selectedCarId : UUID?
    var chosenCar=""
    var chosenCarId:UUID?
    
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
   
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceTextField: UITextField!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        saveButton.isHidden=false
        
  
        
        if chosenCar != ""{
            saveButton.isHidden = true
                  
                    
                    // Core Data ile ekran seçimle açılmışsa verileri çekip filtrelemek
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    
                    let idString = chosenCarId?.uuidString
                    
                    let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "CarsInformations")
                    fetchReq.returnsObjectsAsFaults = false
                    fetchReq.predicate = NSPredicate(format: "id = %@",  idString!)
                    do{
                        let results = try context.fetch(fetchReq)
                        if results.count > 0{
                            
                            
                            for result in results as! [NSManagedObject] {
                                if let model = result.value(forKey: "models") as? String{
                                    modelTextField.text = model
                                }
                                if let year = result.value(forKey: "year") as? Int{
                                    yearTextField.text = String(year)
                                }
                                if let price = result.value(forKey: "price") as? Int{
                                    priceTextField.text = String(price)
                                }
                                
                                if let imageData = result.value(forKey: "image") as? Data{
                                    let image = UIImage(data: imageData)
                                    imageView.image = image
                                }
                            }
                        }
                    } catch{
                        print("error")
                    }
            
                    

      
    }
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageTapRecognizer)
    }
    

      @objc  func saveButtonClicked(_ sender: Any) {
     
   
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     let context = appDelegate.persistentContainer.viewContext
  
     let newCar = NSEntityDescription.insertNewObject(forEntityName: "CarsInformations", into: context)
     newCar.setValue(modelTextField.text, forKey: "models")
  
     if let year = Int(yearTextField.text!){
         newCar.setValue(year, forKey: "year")
  
     }
     if let price = Int(priceTextField.text!){
     newCar.setValue(price, forKey: "price")
  
     }
     newCar.setValue(UUID(), forKey: "id")
  
     let data = imageView.image!.jpegData(compressionQuality: 0.5)
  
     newCar.setValue(data, forKey: "image")
     do {
         try context.save()
         print("success")
     }
         catch{
             print("error")
         }
  
        
            
            NotificationCenter.default.post(name: NSNotification.Name("New Data"), object: nil)
            
            // işlem bitince önceki ekrana gönderme
            self.navigationController?.popViewController(animated: true)
            
            
        }
    
    
        @objc func hideKeyboard(){
            view.endEditing(true)
        }
    
 
        
        @objc func selectImage(){
              let picker = UIImagePickerController()
              picker.delegate = self
              picker.sourceType = .photoLibrary
              picker.allowsEditing = true
              present(picker, animated: true, completion: nil)
              
          }
      
          func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
              imageView.image = info[.editedImage] as? UIImage
              self.dismiss(animated: true, completion: nil)
              
              
       
    }
  
    
    
    
}

