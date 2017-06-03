//
//  BlocksTypeTableViewController.swift
//  BlocksForAll
//
//  Created by Lauren Milne on 3/4/17.
//  Copyright © 2017 Lauren Milne. All rights reserved.
//

import UIKit

class BlocksTypeTableViewController: UITableViewController {
    
    var blockTypes = NSArray()
    
    //used to pass on delegate to selectedBlockViewController
    var delegate: BlockSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Toolbox"
        self.accessibilityLabel = "Toolbox Menu"
        self.accessibilityHint = "Double tap from menu to select block type"
        
        blockTypes = NSArray(contentsOfFile: Bundle.main.path(forResource: "BlocksMenu", ofType: "plist")!)!

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockTypes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier
        
        let cellIdentifier = "BlockTypeTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        // Configure the cell...
       if let blockType = blockTypes.object(at: indexPath.row) as? NSDictionary{
            let name = blockType.object(forKey: "type") as? String

            cell.textLabel?.text = name
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.textAlignment = .center
            if let colorString = blockType.object(forKey: "color") as? String{
                cell.backgroundColor = UIColor.colorFrom(hexString: colorString)
            }
            cell.accessibilityLabel = name! + " category"
            cell.accessibilityHint = "Double tap to explore blocks in this category"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.bounds.height/CGFloat(blockTypes.count)
        return height
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // Letting destination controller know which blocks type was picked
        if let myDestination = segue.destination as? BlockTableViewController{
            //if let blockCell = sender as?
            myDestination.typeIndex = tableView.indexPathForSelectedRow?.row
            myDestination.delegate = self.delegate
        }
    }

}

extension UIColor{
    static func colorFrom(hexString:String, alpha:CGFloat = 1.0)->UIColor{
        var rgbValue:UInt32 = 0
        let scanner = Scanner(string: hexString)
        scanner.scanLocation = 1 // bypass # character
        scanner.scanHexInt32(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8)/255.0
        let blue = CGFloat((rgbValue & 0x0000FF))/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
