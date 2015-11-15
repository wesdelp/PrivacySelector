//
//  ViewController.swift
//  PrivacySelector
//
//  Created by Wesley Delp on 11/14/15.
//  Copyright © 2015 wesdelp. All rights reserved.
//

import UIKit

class PrivacyCell : UITableViewCell {
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var radialButton: UIButton!

    func loadItem(title: String) {
        dataLabel.text = title
        if title == "Complete" {
            dataLabel.textColor = UIColor.greenColor()
        }
    }
}

class RadialCell : UITableViewCell {
    @IBOutlet weak var radialLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    //func loadItem(title: String) {
      //  radialLabel.text = title
    //}
    
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var acceptButton: UIButton!
    
    var items: [(String, Bool)] = [
        ("Data1", false),
        ("Data2", false),
        ("Data3", false),
        ("Data4", false),
        ("Data5", false)
    ]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let (title,isRadialCell) = items[indexPath.row]
        
        if isRadialCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("RadialTableViewCell", forIndexPath: indexPath) as! RadialCell
            cell.doneButton.tag = indexPath.row;
            cell.doneButton.addTarget(self, action: "doneAction:", forControlEvents: .TouchUpInside)
            //cell.loadItem(title)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("PrivacyTableViewCell", forIndexPath: indexPath) as! PrivacyCell
            cell.loadItem(title)
            cell.radialButton.tag = indexPath.row;
            cell.radialButton.addTarget(self, action: "radialAction:", forControlEvents: .TouchUpInside)
            return cell
        }
    }
    
    @IBAction func radialAction(sender: UIButton) {
        let titleString = items[sender.tag]
        items[sender.tag] = (titleString.0,true)
        tableView.reloadData()
    }
    
    @IBAction func doneAction(sender: UIButton) {
        items[sender.tag] = ("Complete",false)
        tableView.reloadData()
        
        for item in items {
            if item.0 != "Complete" {
                return
            }
        }; acceptButton.enabled = true
        return
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "RadialTableViewCell", bundle: nil), forCellReuseIdentifier: "RadialTableViewCell")
        tableView.registerNib(UINib(nibName: "PrivacyTableViewCell", bundle: nil), forCellReuseIdentifier: "PrivacyTableViewCell")
    }
}

