//
//  ViewController.swift
//  Core Data Persistence
//
//  Created by Admin on 18.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var lineFields: [UITextField]!
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var lines: [Line]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request: NSFetchRequest<Line> = Line.fetchRequest()
        
        do {
            let lines = try context.fetch(request)
            for line in lines {
                let textField = lineFields[Int(line.lineNumber)]
                textField.text = line.lineText
            }
            let app = UIApplication.shared
            NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: app)
        } catch  {
            print("There was an error in executeFetchRequest(): \(error.localizedDescription)")
        }
    }
    
    @objc func applicationWillResignActive(_ notification: Notification) {
        lines = []
        for i in 0..<lineFields.count {
            let text = lineFields[i].text ?? ""
            //let request: NSFetchRequest<Line> = Line.fetchRequest()
            //request.predicate = NSPredicate(format: "lineNumber == %@", String(i))
            do {
                //let line = try context.fetch(request)
                //if line.first == nil {
                    let newLine = Line(context: context)
                    //lines = []
                    newLine.lineNumber = Int16(i)
                    newLine.lineText = text
                    lines.append(newLine)
                    try context.save()
                //}
            } catch  {
                print("There was an error in executeFetchRequest(): \(error.localizedDescription)")
            }
        }
        lines = []
    }
}

