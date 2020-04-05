import UIKit
import SwiftyDraw
import ChromaColorPicker
import SnapKit

extension DrawViewController: SwiftyDrawViewDelegate {
    func swiftyDraw(shouldBeginDrawingIn drawingView: SwiftyDrawView, using touch: UITouch) -> Bool { return true }
    func swiftyDraw(didBeginDrawingIn    drawingView: SwiftyDrawView, using touch: UITouch) { updateHistoryButtons() }
    func swiftyDraw(isDrawingIn          drawingView: SwiftyDrawView, using touch: UITouch) {  }
    func swiftyDraw(didFinishDrawingIn   drawingView: SwiftyDrawView, using touch: UITouch) {  }
    func swiftyDraw(didCancelDrawingIn   drawingView: SwiftyDrawView, using touch: UITouch) {  }
}

class DrawViewController: UIViewController {
    
    @IBOutlet weak var drawView: SwiftyDrawView!
    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var straightLineButton: UIButton!
    
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var colorPickerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeColorPicker()
        updateHistoryButtons()
        
        drawView.delegate = self
        drawView.brush.width = 7
        
        if #available(iOS 9.1, *) {
            drawView.allowedTouchTypes = [.finger, .pencil]
        }
    }
    
    @IBAction func selectedColor(_ button: UIButton) {
        showColorPicker(true)
    }
    
    func showColorPicker(_ show: Bool) {
        colorPickerView.isHidden = !show
    }
    
    func makeColorPicker() {
        let colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        colorPicker.addHandle(at: colorButton.backgroundColor)
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
    
    func setColor(_ color: UIColor) {
        drawView.brush.color = Color(color)
        colorButton.backgroundColor = color
    }

    @objc func pickerDidValueChange(_ slider: ChromaColorPicker) {
        setColor(slider.handles.first!.color)
    }
    
    @objc func sliderDidValueChange(_ slider: ChromaBrightnessSlider) {
        setColor(slider.currentColor)
    }
    
    @IBAction func undo() {
        drawView.undo()
        updateHistoryButtons()
    }
    
    @IBAction func redo() {
        drawView.redo()
        updateHistoryButtons()
    }
    
    func updateHistoryButtons() {
        undoButton.isEnabled = drawView.canUndo
        redoButton.isEnabled = drawView.canRedo
    }
    
    @IBAction func toggleEraser() {
        if drawView.brush.blendMode == .normal {
            //Switch to clear
            drawView.brush.blendMode = .clear
            eraserButton.tintColor = .red
        } else {
            //Switch to normal
            drawView.brush.blendMode = .normal
            eraserButton.tintColor = self.view.tintColor
        }
    }
    
    @IBAction func clearCanvas() {
        drawView.clear()
        drawView.brush.blendMode = .normal
    }
    
    @IBAction func toggleStraightLine() {
        drawView.shouldDrawStraight = !drawView.shouldDrawStraight
        if drawView.shouldDrawStraight {
            straightLineButton.tintColor = .red
        } else {
            straightLineButton.tintColor = self.view.tintColor
        }
    }
    
    @IBAction func changedWidth(_ slider: UISlider) {
        drawView.brush.width = CGFloat(slider.value)
    }
    
    @IBAction func changedOpacity(_ slider: UISlider) {
        drawView.brush.opacity = CGFloat(slider.value)
        drawView.brush.blendMode = .normal
    }
}


extension UIView {
    @objc func hide() {
        self.isHidden = true
    }
}
