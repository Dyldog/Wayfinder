//
//  LogListViewController.swift
//  FinderCreator
//
//  Created by Dylan Elliott on 5/4/20.
//

import UIKit
import Alamofire

struct LogFile: Codable {
    let name: String
}

class LogListViewController: UITableViewController {
    
    let app: FinderApp
    var logs: [LogFile] = []
    
    init(app: FinderApp) {
        self.app = app
        super.init(style: .plain)
        title = self.app.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
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
        AF.request("http://192.168.0.16:5000/logs/\(app.name)").responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    self.logs = try JSONDecoder().decode([LogFile].self, from: data)
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
        logs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        let log = logs[indexPath.row]
        cell.textLabel?.text = log.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let log = logs[indexPath.row]
        let viewController = LogDetailViewController(app: app, log: log)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
