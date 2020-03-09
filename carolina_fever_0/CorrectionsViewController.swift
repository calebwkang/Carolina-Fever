//
//  CorrectionsViewController.swift
//  carolina_fever_0
//
//  Created by Caleb Kang on 7/29/19.
//  Copyright © 2019 Caleb Kang. All rights reserved.
//

import UIKit
import Parse

class CorrectionsViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    // MARK: Outlets and Fields
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var eventField: UITextField!

    @IBOutlet var otherField: UITextView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var detailsField: UITextView!
    
    @IBOutlet var selectPhotoButton: UIButton!
    var imagePicker: UIImagePickerController!
    @IBOutlet var contentView: UIView!
    
    /*Four buttons for the user to choose
     which kind of concern they have*/
    @IBOutlet var wholePointsButton: UIButton!
    @IBOutlet var halfPointsButton: UIButton!
    @IBOutlet var footballPointsButton: UIButton!
    @IBOutlet var otherPointsButton: UIButton!
    
    var concernedPressed = false
    let DEFAULT_BACKGROUND_COLOR = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
    
    // MARK: View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        let screen_size = UIScreen.main.bounds
        let width = screen_size.width

        let bigger_content = CGSize(width: width, height: 900)
        scrollView.contentSize = bigger_content
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CorrectionsViewController.needToDismissKeyboard))
        tap.cancelsTouchesInView = false
        self.contentView.addGestureRecognizer(tap)
        
        configBorders()
    }
    
    // MARK: Actions
    
    /*allows user to sumbit photo proof of game attendance*/
    @IBAction func selectPhotoPressed(_ sender: UIButton) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    /*called when user is ready to submit corrections form. This method ensures all info is present
     the it will make a corrections object with all information and save to the parse server      */
    @IBAction func submitPressed(_ sender: UIButton) {
        
        if eventField.text == "" || (imageView.image == nil && detailsField!.text == "") {
            /*display alert if there is no event text or no proof*/
            displayAlert(title: "Information Missing", message: "Please Fill Out Entire Form")
        } else if !concernedPressed {
            displayAlert(title: "Information Missing", message: "Select a Concern")
        } else if otherField.backgroundColor == CAROLINA_BLUE && otherField.text! == "" {
            displayAlert(title: "Information Missing", message: "Describe your Concern")
        } else {
        
            /*all information is present*/
            let correction = PFObject(className: "Correction")
            correction["event"] = eventField.text
            
            if imageView.image != nil {
                
                if let data = imageView.image!.jpegData(compressionQuality: 1) {
                    correction["photo"] = PFFileObject(name: "image.jpg" , data: data)
                }
                
            }
            
            correction["details"] = detailsField.text
            correction["otherConcern"] = otherField.text
            
            correction.saveInBackground { (sucess: Bool, error: Error?) in
                if sucess {
                    self.displayAlert(title: "Success", message: "Form Submitted Successfully")
                } else {
                    self.displayAlert(title: "Failed", message: "There was an Error Submitting your Correction")
                }
            }
            
        }
 
    }
    
    /*called when user selected a concern. It changes the color and
     font color of the buttons to indicate the user's choice    **/
    @IBAction func concernPicked(_ sender: UIButton) {
        concernedPressed = true
        
        switch sender.tag {
            case 0: // whole points
                wholePointsButton.backgroundColor = CAROLINA_BLUE
                wholePointsButton.setTitleColor(UIColor.white, for: [])
                
                halfPointsButton.backgroundColor = DEFAULT_BACKGROUND_COLOR
                halfPointsButton.setTitleColor(CAROLINA_BLUE, for: [])
                
                footballPointsButton.backgroundColor = DEFAULT_BACKGROUND_COLOR
                footballPointsButton.setTitleColor(CAROLINA_BLUE, for: [])
                
                otherPointsButton.backgroundColor = DEFAULT_BACKGROUND_COLOR
                otherPointsButton.setTitleColor(CAROLINA_BLUE, for: [])
                
                otherField.alpha = 0
                break
            case 1:
                halfPointsButton.backgroundColor = CAROLINA_BLUE
                halfPointsButton.setTitleColor(UIColor.white, for: [])
                
                wholePointsButton.backgroundColor = DEFAULT_BACKGROUND_COLOR
                wholePointsButton.setTitleColor(CAROLINA_BLUE, for: [])
                
                footballPointsButton.backgroundColor = DEFAULT_BACKGROUND_COLOR
                footballPointsButton.setTitleColor(CAROLINA_BLUE, for: [])
                
                otherPointsButton.backgroundColor = DEFAULT_BACKGROUND_COLOR
                otherPointsButton.setTitleColor(CAROLINA_BLUE, for: [])
                
                otherField.alpha = 0
                break
            case 2:
                footballPointsButton.backgroundColor = CAROLINA_BLUE
                footballPointsButton.setTitleColor(UIColor.white, for: [])
                
                halfPointsButton.backgroundColor = DEFAULT_BACKGROUND_COLOR
                halfPointsButton.setTitleColor(CAROLINA_BLUE, for: [])
                
                wholePointsButton.backgroundColor = DEFAULT_BACKGROUND_COLOR
                wholePointsButton.setTitleColor(CAROLINA_BLUE, for: [])
                
                otherPointsButton.backgroundColor = DEFAULT_BACKGROUND_COLOR
                otherPointsButton.setTitleColor(CAROLINA_BLUE, for: [])
                
                otherField.alpha = 0
                break
            case 3:
                otherPointsButton.backgroundColor = CAROLINA_BLUE
                otherPointsButton.setTitleColor(UIColor.white, for: [])
                
                halfPointsButton.backgroundColor = DEFAULT_BACKGROUND_COLOR
                halfPointsButton.setTitleColor(CAROLINA_BLUE, for: [])
                
                footballPointsButton.backgroundColor = DEFAULT_BACKGROUND_COLOR
                footballPointsButton.setTitleColor(CAROLINA_BLUE, for: [])
                
                wholePointsButton.backgroundColor = DEFAULT_BACKGROUND_COLOR
                wholePointsButton.setTitleColor(CAROLINA_BLUE, for: [])
                
                otherField.alpha = 1
                break
            
            default:
                print("button not supported!")
        }
        
    }
    
    // MARK: Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Text View and Keyboard Methods
    
    /* *****closes text field when user presses return***** */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
       
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
       
    @objc func needToDismissKeyboard() {
        contentView.endEditing(true)
    }
    
    // MARK: Helper Methods
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*make buttons to pick the type of concern*/
    func configBorders() {
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = 5.0
        
        otherField.layer.borderWidth = 1.0
        otherField.layer.borderColor = UIColor.lightGray.cgColor
        otherField.layer.cornerRadius = 5
        otherField.alpha = 0
        
        detailsField.layer.borderWidth = 1.0
        detailsField.layer.borderColor = UIColor.lightGray.cgColor
        detailsField.layer.cornerRadius = 5.0
        
        
        wholePointsButton.layer.borderWidth = 1.0
        wholePointsButton.layer.borderColor = CAROLINA_BLUE.cgColor
        wholePointsButton.layer.cornerRadius = 5.0
        wholePointsButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        halfPointsButton.layer.borderWidth = 1.0
        halfPointsButton.layer.borderColor = CAROLINA_BLUE.cgColor
        halfPointsButton.layer.cornerRadius = 5.0
        halfPointsButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        
        footballPointsButton.layer.borderWidth = 1.0
        footballPointsButton.layer.borderColor = CAROLINA_BLUE.cgColor
        footballPointsButton.layer.cornerRadius = 5.0
        footballPointsButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        otherPointsButton.layer.borderWidth = 1.0
        otherPointsButton.layer.borderColor = CAROLINA_BLUE.cgColor
        otherPointsButton.layer.cornerRadius = 5.0
    }

}
