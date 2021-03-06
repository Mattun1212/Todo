//
//  AddTodoViewController.swift
//  Todo
//
//  Created by Koutaro Matsushita on 2021/09/16.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddTodoViewController: UIViewController{
    let currentUser = Auth.auth().currentUser
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var datePicker: UIDatePicker = UIDatePicker()
    let alert: Alert = Alert()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        detailTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        detailTextView.layer.borderWidth = 1.0
        detailTextView.layer.cornerRadius = 1.0
        detailTextView.layer.masksToBounds = true
        
        saveButton.isEnabled = false
        
        titleTextField.delegate = self
        detailTextView.delegate = self
        dateTextField.delegate = self

        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        dateTextField.inputView = datePicker

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 45))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDate))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
    }
    
    @objc func changeDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = "\(formatter.string(from: datePicker.date))"
    }

    
    @objc func doneDate() {
        dateTextField.endEditing(true)
        // ???????????????????????????
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = "\(formatter.string(from: datePicker.date))"
        
        textFieldDidChangeSelection(dateTextField)
        
    }
    
    @IBAction func save(_ sender: Any) {
        
        if let titleText = titleTextField.text,
           let detailText = detailTextView.text,
           let dateText = dateTextField.text {
            db.collection("users").document(currentUser!.uid).collection("todos").document().setData(["title": titleText, "detail": detailText, "timelimit": dateText, "done": false], merge: true)
        
        self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension AddTodoViewController: UITextFieldDelegate {
    
    // textField?????????????????????????????????????????????????????????????????????
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // textField????????????????????????????????????????????????(Bool???)?????????
        let titleIsEmpty = titleTextField.text?.isEmpty ?? true
        let detailIsEmpty = detailTextView.text?.isEmpty ?? true
        let dateIsEmpty = dateTextField.text?.isEmpty ?? true
        // ?????????textField?????????????????????????????????
        if titleIsEmpty || detailIsEmpty || dateIsEmpty {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }

    // textField????????????????????????????????????????????????????????????
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension AddTodoViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        // textField????????????????????????????????????????????????(Bool???)?????????
        let titleIsEmpty = titleTextField.text?.isEmpty ?? true
        let detailIsEmpty = detailTextView.text?.isEmpty ?? true
        let dateIsEmpty = dateTextField.text?.isEmpty ?? true
        // ?????????textField?????????????????????????????????
        if titleIsEmpty || detailIsEmpty || dateIsEmpty {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
   
}
