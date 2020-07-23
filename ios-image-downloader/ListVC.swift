//
//  ViewController.swift
//  ios-image-downloader
//
//  Created by omrobbie on 23/07/20.
//  Copyright © 2020 omrobbie. All rights reserved.
//

import UIKit

class ListVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Item \(indexPath.row)"
        return cell
    }
}
