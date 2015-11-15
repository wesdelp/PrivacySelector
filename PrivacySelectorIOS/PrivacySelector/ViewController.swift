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
    }
}

class RadialCell : UITableViewCell {
    @IBOutlet weak var radialLabel: UILabel!
    
    func loadItem(title: String) {
        radialLabel.text = title
    }
    
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [(String, Bool)] = [
        ("Data1", true),
        ("Data2", false),
        ("Data3", false),
        ("Data4", false),
        ("Data5", true)
    ]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let (title,isRadialCell) = items[indexPath.row]
        
        if isRadialCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("RadialTableViewCell", forIndexPath: indexPath) as! RadialCell
            cell.loadItem(title)
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
        print(titleString.0)
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

