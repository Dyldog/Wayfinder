//
//  LogDetailViewController.swift
//  FinderCreator
//
//  Created by Dylan Elliott on 5/4/20.
//

import UIKit
import Alamofire

class LogDetailViewController: UIViewController {
    
    let log: LogFile
    let app: FinderApp
    let textView = UITextView()
    
    init(app: FinderApp, log: LogFile) {
        self.app = app
        self.log = log
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = log.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.isEditable = false
        textView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: .primaryActionTriggered)
        textView.refreshControl = refreshControl
        
        reloadData()
    }
    
    @objc func reloadData() {
        showLoading(true)
        onBG {
            self.refreshData { result in
                onMain {
                    switch result {
                    case .success(let text): self.textView.text = text
                    case .failure(let error): self.showError(error)
                    }
                    
                    self.textView.refreshControl?.endRefreshing()
                    self.showLoading(false)
                }
            }
        }
    }
    
    func refreshData(completion: @escaping (Swift.Result<String, Error>) -> Void) {
        AF.request("http://192.168.0.16:5000/log/\(app.name)/\(log.name)").responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    guard let text = String(data: data, encoding: .utf8) else {
                        completion(.failure("Invalid response data"))
                        return
                    }
                    completion(.success(text))
                    return
                } catch {
                    completion(.failure(error))
                    return
                }
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}

extension String: Error {}
