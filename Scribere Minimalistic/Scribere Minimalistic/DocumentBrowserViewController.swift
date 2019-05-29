//
//  DocumentBrowserViewController.swift
//  Scribere Minimalistic
//
//  Created by Roy Akash on 13/05/19.
//  Copyright © 2019 The Roy Akash Software, Company. All rights reserved.
//

import UIKit

class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate, UIViewControllerTransitioningDelegate {
    
    var transitionController: UIDocumentBrowserTransitionController?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        whatsNewIfNeeded()
    }
    // Work Need Here:
    func whatsNewIfNeeded(){
        let items = [WhatsNew.Item(
            title: "All Week Weather",
            subtitle: "You can See full Weeks of accurate Weather",
            image: UIImage(named: "sevenDayWeather")
            ),
                     // 1st New Feature
                     WhatsNew.Item(
                        title: "It's Open Source", subtitle: "Contributions to make the app better are very welcome 👨‍💻", image: UIImage(named: "openSource")),
                     // 2nd New Feature
                     WhatsNew.Item(title: "All Ad Free", subtitle: "Full Ad free experience & will remain ad free forever", image: UIImage(named: "adFree")),
                     // 3rd New Feature
                     WhatsNew.Item(title: "No Subscription Fee", subtitle: "No Recurring Subscription Fee at all", image: UIImage(named: "subs"))
        ]
        
        let theme = WhatsNewViewController.Theme {configuration in
            configuration.apply(animation: .slideUp)
            configuration.apply(theme: .darkRed)
        }
        
        let config = WhatsNewViewController.Configuration(theme: theme)
        let keyValueVersionStore = KeyValueWhatsNewVersionStore(keyValueable: UserDefaults.standard)
        let whatsnew = WhatsNew(title: "What Is New", items: items)
        let whatsNewVC = WhatsNewViewController(whatsNew: whatsnew, configuration: config, versionStore: keyValueVersionStore)
        
        if let vc = whatsNewVC{
            self.present(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        // Update the style of the UIDocumentBrowserViewController
        browserUserInterfaceStyle = .dark
        view.tintColor = .white
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        // baseDirectory = Basic Place Where Our Things Going To be
        let baseDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        let filename = baseDirectory.appendingPathComponent("Untitled.txt")
        
        let document = Document(fileURL: filename)
        document.save(to: filename, for: .forCreating) { success in
            document.close{ success in
                importHandler(filename, .move)
            }
        }
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let documentViewController = storyBoard.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
        documentViewController.document = Document(fileURL: documentURL)
        
        let navController = UINavigationController(rootViewController: documentViewController)
        navController.transitioningDelegate = self
        
        transitionController = transitionController(forDocumentAt: documentURL)
        transitionController?.targetView = documentViewController.textView
        
        present(navController, animated: true, completion: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionController
    }
}

