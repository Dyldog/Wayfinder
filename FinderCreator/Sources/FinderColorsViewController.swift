//
//  FinderColorsViewController.swift
//  FinderCreator
//
//  Created by Dylan Elliott on 5/4/20.
//

import UIKit
import ChromaColorPicker
import Alamofire

enum ColorType {
    case toolbar
    case background
    case h1
    case h2
}

struct FinderConfiguration: Codable {
    struct Colors: Codable {
        let background: String
        let toolbar: String
        let h1: String
        let h2: String
        
        static func fromStaticValues() -> Colors {
            return Colors(
                background: UIColor.background.hexString,
                toolbar: UIColor.toolbar.hexString,
                h1: UIColor.h1.hexString,
                h2: UIColor.h2.hexString
            )
        }
    }
    
    let colors: Colors
    let placeType: GooglePlace.PlaceType
    let title: String
    let image: String // base64 encoded
    
    init(colors: Colors = .fromStaticValues(), placeType: GooglePlace.PlaceType, title: String, image: String) {
        self.colors = colors
        self.placeType = placeType
        self.title = title
        self.image = image
    }
}

class FinderColorsViewController: SinglePlaceHeadingViewController {
    
    @IBOutlet weak var colorPickerView: UIView!
    var currentType: ColorType?
    var selectedPlaceType: GooglePlace.PlaceType! {
        didSet {
            placeManager.placesType = selectedPlaceType.rawValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select Colors"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        
        func addGestureRecogniser(to views: [UIView], action: Selector) {
            views.forEach {
                $0.addGestureRecognizer(UITapGestureRecognizer(
                    target: self, action: action
                ))
            }
        }
        
        addGestureRecogniser(
            to: [destinationView, bottomView],
            action: #selector(toolbarViewTapped)
        )
        
        addGestureRecogniser(
            to: [destinationTitleLabel, distanceTitleLabel],
            action: #selector(titleLabelTapped)
        )
        
        addGestureRecogniser(
            to: [destinationLabel, distanceLabel],
            action: #selector(valueLabelTapped)
        )
        
        addGestureRecogniser(
            to: [view],
            action: #selector(backgroundTapped)
        )
        
        makeColorPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func toolbarViewTapped() {
        currentType = .toolbar
        showColorPicker(true)
    }
    
    @objc func titleLabelTapped() {
        currentType = .h1
        showColorPicker(true)
    }
    
    @objc func valueLabelTapped() {
        currentType = .h2
        showColorPicker(true)
    }
    
    @objc func backgroundTapped() {
        currentType = .background
        showColorPicker(true)
    }
    
    func setColor(_ color: UIColor) {
        switch currentType {
        case .toolbar: UIColor.toolbar = color
        case .background: UIColor.background = color
        case .h1: UIColor.h1 = color
        case .h2: UIColor.h2 = color
        case .none:
            fallthrough
        default:
            break
        }
        
        let navigationBar = navigationController!.navigationBar
        navigationBar.barTintColor = .toolbar
        navigationBar.tintColor = .h1
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.h2]
        
        updateColors()
    }

    @objc func pickerDidValueChange(_ slider: ChromaColorPicker) {
        setColor(slider.handles.first!.color)
    }
    
    @objc func sliderDidValueChange(_ slider: ChromaBrightnessSlider) {
        setColor(slider.currentColor)
    }
    
    @objc func doneButtonTapped() {
        func showNameAlert() {
            let alert = UIAlertController(title: "App Subject", message: "What kind of finder is it?", preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "Title"
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Go", style: .default, handler: { _ in
                guard let title = alert.textFields?.first?.text, title.isEmpty == false else {
                    let alert = UIAlertController(title: "Empty Title", message: "Subject can't be blank", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        showNameAlert()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                self.done(with: title)
            }))
            present(alert, animated: true, completion: nil)
        }
        
        showNameAlert()
    }
    
    func done(with title: String) {
        let config = FinderConfiguration(
            placeType: selectedPlaceType,
            title: title,
            image: headingImage!.pngData()!.base64EncodedString()
        )
        
        let configData = try! JSONEncoder().encode(config)
        
        var request = URLRequest(url: URL(string: "http://192.168.0.16:5000/create")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = configData
        
        AF.request(request).responseString { response in
            switch response.result {
            case .success(let response): print(response)
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
}

extension FinderColorsViewController {
    
    func showColorPicker(_ show: Bool) {
        colorPickerView.isHidden = !show
    }
    
    func makeColorPicker() {
        let colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        colorPicker.addHandle()
        colorPicker.addTarget(self, action: #selector(pickerDidValueChange(_:)), for: .valueChanged)
        
        let brightnessSlider = ChromaBrightnessSlider(frame: CGRect(x: 0, y: 320, width: 300, height: 32))
        brightnessSlider.addTarget(
            self, action: #selector(sliderDidValueChange(_:)), for: .valueChanged)
        colorPicker.connect(brightnessSlider)
        
        let pickerContainer = UIView()
        pickerContainer.addSubview(colorPicker)
        pickerContainer.addSubview(brightnessSlider)
        
        brightnessSlider.snp.makeConstraints { make in
            make.top.equalTo(brightnessSlider.frame.origin.y)
            make.height.equalTo(brightnessSlider.frame.height)
        }
        
        pickerContainer.snp.makeConstraints { make in
            make.left.right.top.equalTo(colorPicker)
            make.left.right.bottom.equalTo(brightnessSlider)
        }
        
        let pickerView = UIView()
        pickerView.addSubview(pickerContainer)
        view.addSubview(pickerView)
        
        pickerView.snp.makeConstraints { make in
            make.center.equalTo(pickerContainer)
            make.edges.equalTo(view)
        }
        
        pickerView.isHidden = true
        
        pickerView.addGestureRecognizer(UITapGestureRecognizer(target: pickerView, action: #selector(UIView.hide)))
        
        colorPickerView = pickerView
    }
}

extension String: ParameterEncoding {

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }

}
