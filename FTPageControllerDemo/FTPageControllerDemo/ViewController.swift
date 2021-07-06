//
//  ViewController.swift
//  FTPageControllerDemo
//
//  Created by LiuFengting on 2021/7/6.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray = ["Defalult", "Attributed", "TableView section Header"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
            
    //    MARK: - UITableViewDelegate, UITableViewDataSource -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIDs", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.handleCellTapAt(indexPath: indexPath)
    }
    
    func handleCellTapAt(indexPath: IndexPath)  {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "SegueToDetail", sender: nil)
        case 1:
            self.performSegue(withIdentifier: "SegueToAttributed", sender: nil)
        case 2:
            self.performSegue(withIdentifier: "SegueToTableVC", sender: nil)
        default:
            break
        }
    }
    
}

//MARK: - extension for UIScreen -

public extension UIScreen {
    
    static func ft_width() -> CGFloat {
        return self.main.bounds.size.width
    }
    
    static func ft_height() -> CGFloat {
        return self.main.bounds.size.height
    }
    
}
