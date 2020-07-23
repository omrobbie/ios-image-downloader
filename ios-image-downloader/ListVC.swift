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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! Cell
        cell.item = data[indexPath.row]
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
                let filterData = decodeData.filter {$0.contains(".jpg")}
                DispatchQueue.main.async {
                    completion(filterData)
                }
            } catch {
                print("Error", error.localizedDescription)
            }
        }.resume()
    }

    func fetchImage(path: String, completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: BASE_URL + "/" + path) else {return}

        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {return}
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}

// MARK: - TableViewCell
class Cell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!

    var task: URLSessionDataTask!

    var item: String! {
        didSet {
            imgView.image = nil
            if task != nil {task.cancel()}
            guard let url = URL(string: "https://random.dog/" + item) else {return}

            task = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, _) in
                guard let data = data else {return}
                DispatchQueue.main.async {
                    self.imgView.image = UIImage(data: data)
                }
            })

            task.resume()
        }
    }
}
