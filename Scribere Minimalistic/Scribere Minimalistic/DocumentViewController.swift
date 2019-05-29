//
//  DocumentViewController.swift
//  Scribere Minimalistic
//
//  Created by Roy Akash on 13/05/19.
//  Copyright © 2019 The Roy Akash Software, Company. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {
    
    
    
    @IBOutlet weak var textView: UITextView!
    
    var document: Document?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.allowsEditingTextAttributes = true
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissDocumentViewController))
        
        // Access the document
        document?.open(completionHandler: { (success) in
            if success {
                // Display the content of the document:
                self.title = self.document?.fileURL.deletingPathExtension().lastPathComponent
                self.textView.text = self.document?.text ?? ""
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        })
    }

//    deinit {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//    }

    @objc func dismissDocumentViewController() {
        document?.text = textView.text
        textView.allowsEditingTextAttributes = true
        document?.updateChangeCount(.done)
        
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
        }
    }
    
    @objc func shareTapped(sender: UIBarButtonItem){
        guard let url = document?.fileURL else{
            return
        }
        let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        ac.popoverPresentationController?.barButtonItem = sender
        present(ac, animated: true)
    }
    
//    @objc func keyboardWillChange(notification: Notification){
//
//        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
//            return
//        }
//
//        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification{
//            view.frame.origin.y = -keyboardRect.height
//        }else{
//            view.frame.origin.y = 0
//        }
//    }
}
