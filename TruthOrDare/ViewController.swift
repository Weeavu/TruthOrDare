//
//  ViewController.swift
//  TruthOrDare
//
//  Created by Vu Nguyen on 2/7/18.
//  Copyright © 2018 Vu Nguyen. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    let addOption : [String] = ["Truth", "Dare"]
    var option : String = "Truth"
    
    var truthArr : [Truth] = [Truth]()
    var dareArr : [Dare] = [Dare]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillTruthArr()
        fillDareArr()
        
        loadData()
    }
    
    func loadData() {
        textLabel.lineBreakMode = .byWordWrapping
    }
    
    func fillTruthArr() {
        let truthDB = Database.database().reference().child("truths")
        truthDB.observeSingleEvent(of: .value) { (snap : DataSnapshot) in
            
            for truths in snap.children.allObjects as! [DataSnapshot] {
                let truthObject = truths.value as? [String : AnyObject]
                let newTruth = Truth()
                newTruth.name = truthObject?["name"] as! String
                
                self.truthArr.append(newTruth)
            }
        }
    }
    
    func fillDareArr() {
        let dareDB = Database.database().reference().child("dares")
        dareDB.observeSingleEvent(of: .value) { (snap : DataSnapshot) in
            
            for dares in snap.children.allObjects as! [DataSnapshot] {
                let dareObject = dares.value as? [String : AnyObject]
                let newDare = Dare()
                newDare.name = dareObject?["name"] as! String
                
                self.dareArr.append(newDare)
            }
        }
    }
    @IBAction func truthTapped(_ sender: UIButton) {
        typeLabel.text = "Truth 🤭"
        if(truthArr.count == 0) {
            fillTruthArr()
            textLabel.text = "We out of truths...Reloading"
            return
        }
        
        let rand = Int(arc4random_uniform(UInt32(truthArr.count)))
        textLabel.text = truthArr[rand].name
        truthArr.remove(at: rand)
    
    }
    
    @IBAction func dareTapped(_ sender: UIButton) {
        typeLabel.text = "Dare 😲"
        if(dareArr.count == 0) {
            fillDareArr()
            textLabel.text = "We out of dares...Reloading"
            return
        }
        
        let rand = Int(arc4random_uniform(UInt32(dareArr.count)))
        textLabel.text = dareArr[rand].name
        dareArr.remove(at: rand)
    }
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Truth/Dare", message: "\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerView = UIPickerView(frame: CGRect(x: 50, y: 0, width: 200, height: 200))
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //Actions
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if self.option == "Truth" {
                let DB = Database.database().reference().child("truths")
                let dictionary = ["name" : textField.text!]
                DB.childByAutoId().setValue(dictionary)
                
            } else {
                let DB = Database.database().reference().child("dares")
                let dictionary = ["name" : textField.text!]
                DB.childByAutoId().setValue(dictionary)
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        //Add TextField
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Make it good"
            textField = alertTextField
        }
        
        //Add Subview
        alert.view.addSubview(pickerView)
        alert.view.addSubview(textField)
        
        //Add Actions
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController :  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return addOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return addOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        option = addOption[row]
        print(option)
    }
    
}

class Truth {
    var name : String = ""
}

class Dare {
    var name : String = ""
}
