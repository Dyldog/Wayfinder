//
//  LogListViewController.swift
//  FinderCreator
//
//  Created by Dylan Elliott on 5/4/20.
//

import UIKit
import Alamofire

struct LogFile: Codable {
    enum Status: String, Codable {
        case success
        case failure
        case running
        case noBuild
        
        var color: UIColor {
            switch self {
            case .success: return .init(hex: "#2ecc71")
            case .failure: return .init(hex: "#e74c3c")
            case .running: return .init(hex: "#f1c40f")
            case .noBuild: return .init(hex: "#95a5a6")
            }
        }
    }
    
    enum LastStep: String, Codable {
        case noStep = "no_step"
        case tuist = "tuist"
        case createAppOnline = "create_app_online"
        case getProvisioningProfile = "get_provisioning_profile"
        case buildApp = "build_app"
        case snapshot = "snapshot"
        case uploadToAppStore = "upload_to_app_store"
        
        var title: String {
            return self.rawValue.components(separatedBy: "_").map { $0.capitalized }.joined(separator: " ")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case status = "status"
        case lastStep = "last_step"
    }
    
    let name: String
    let status: Status
    let lastStep: LastStep
}

class LogCell: UITableViewCell {
    let label: UILabel
    let subtitleLabel: UILabel
    let statusView: UIView
    
    init(reuseIdentifier: String?) {
        label = UILabel()
        subtitleLabel = UILabel()
        statusView = UIView()
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        let labelStackView = UIStackView(arrangedSubviews: [label, subtitleLabel])
        labelStackView.axis = .vertical
        
        contentView.addSubview(labelStackView)
        contentView.addSubview(statusView)
        
        statusView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(12)
            make.centerY.equalTo(contentView)
            make.width.equalTo(statusView.snp.height)
            make.width.equalTo(14)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalTo(contentView).inset(12)
            make.leading.equalTo(statusView.snp.trailing).offset(12)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        statusView.cornerRadius = statusView.frame.width / 2.0
    }
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Build",
            style: .plain,
            target: self,
            action: #selector(buildButtonTapped)
        )
        
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
        AF.request("http://192.168.100.144:5000/logs/\(app.name)").responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    self.logs = try JSONDecoder().decode([LogFile].self, from: data).sorted(by: {
                        $0.name > $1.name
                    })
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
    
    func makeBuild(completion: @escaping (Result<Error>) -> Void) {
        AF.request("http://192.168.100.144:5000/build/\(app.name)").responseData { response in
            switch response.result {
            case .success:
                completion(.success)
                return
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
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellID) as? LogCell) ?? LogCell(reuseIdentifier: cellID)
        let log = logs[indexPath.row]
        cell.label.text = log.name
        cell.subtitleLabel.text = log.lastStep.title
        cell.statusView.backgroundColor = log.status.color
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let log = logs[indexPath.row]
        let viewController = LogDetailViewController(app: app, log: log)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func buildButtonTapped() {
        showLoading(true)
        onBG {
            self.makeBuild { makeResult in
                if case let .faiure(error) = makeResult {
                    onMain { self.showLoading(false); self.showError(error) }
                    return
                }
                
                self.refreshData { result in
                    onMain {
                        switch result {
                        case .success: self.tableView.reloadData()
                        case .faiure(let error): self.showError(error)
                        }
                        
                        self.showLoading(false)
                    }
                }
            }
        }
    }
    
    @objc override func showLoading(_ show: Bool) {
        super.showLoading(show)
        self.tableView.refreshControl?.endRefreshing()
    }
}
