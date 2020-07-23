//
//  ViewController.swift
//  ios-image-downloader
//
//  Created by omrobbie on 23/07/20.
//  Copyright © 2020 omrobbie. All rights reserved.
//

import UIKit

class ListVC: UITableViewController {

    private var data = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let item = data[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }

    private func fetchData() {
        NetworkManager.shared.fetchDogList { (data) in
            self.data = data
            self.tableView.reloadData()
        }
    }
}

// MARK: - Networking
class NetworkManager {

    static let shared = NetworkManager()

    private let BASE_URL = "https://random.dog"
    private let DOGGOS = "/doggos"

    func fetchDogList(completion: @escaping ([String]) -> ()) {
        guard let url = URL(string: BASE_URL + DOGGOS) else {return}

        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {return}
            do {
                let decodeData = try JSONDecoder().decode([String].self, from: data)
                DispatchQueue.main.async {
                    completion(decodeData)
                }
            } catch {
                print("Error", error.localizedDescription)
            }
        }.resume()
    }
}
