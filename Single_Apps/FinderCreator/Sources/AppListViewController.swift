//
//  AppListViewController.swift
//  FinderCreator
//
//  Created by Dylan Elliott on 5/4/20.
//

import UIKit
import Alamofire

struct FinderApp: Codable {
    let name: String
    let subject: String
}

extension UIViewController {
    @objc func showLoading(_ show: Bool) { }
}

extension UIViewController {
    func showError(_ error: Error) {
        onMain {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

class AppListViewController: UITableViewController {
    
    var apps: [FinderApp] = []
    
    override func viewDidLoad() {
        navigationItem.title = "Apps"
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: .primaryActionTriggered)
        tableView.refreshControl = refreshControl
        
        reloadData()
    }
    
    @objc func reloadData() {
        showLoading(true)
        onBG {
            self.refreshData { result in
                onMain {
                    switch result {
                    case .success: self.tableView.reloadData()
                    case .faiure(let error): self.showError(error)
                    }
                    
                    self.tableView.refreshControl?.endRefreshing()
                    self.showLoading(false)
                }
            }
        }
    }
    
    func refreshData(completion: @escaping (Result<Error>) -> Void) {
        AF.request("http://192.168.0.16:5000/apps").responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    self.apps = try JSONDecoder().decode([FinderApp].self, from: data)
                    completion(.success)
                    return
                } catch {
                    completion(.faiure(error))
                    return
                }
            case .failure(let error):
                completion(.faiure(error))
                return
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        apps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        let app = apps[indexPath.row]
        
        cell.backgroundColor = .background
        cell.textLabel?.textColor = .h2
        cell.detailTextLabel?.textColor = .h1
        
        cell.textLabel?.text = app.name
        cell.detailTextLabel?.text = app.subject
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = apps[indexPath.row]
        let viewController = LogListViewController(app: app)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
