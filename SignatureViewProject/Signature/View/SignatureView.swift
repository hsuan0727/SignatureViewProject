//
//  SignatureView.swift
//  SignatureViewProject
//
//  Created by PENG HSUAN JUNG on 2023/7/11.
//

import Foundation
import RxSwift
import RxCocoa

class SignatureView: UIView {
    var isCompeleteClick = BehaviorRelay<Bool>.init(value: false)
    var compeleteBackGroundColor = BehaviorRelay<UIColor>.init(value: #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1))
    private var path: UIBezierPath?
    private var pathArray: [UIBezierPath] = []
    
    
    private lazy var pleaseSignLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "請在此簽名"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupSubviews() {
        self.addSubview(pleaseSignLabel)
        pleaseSignLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
            self.addGestureRecognizer(panGestureRecognizer)

        }

    @objc func panGestureRecognizerAction(_ sender: UIPanGestureRecognizer) {
            // 獲取當前點
            let currentPoint = sender.location(in: self)
            if sender.state == .began {
                self.path = UIBezierPath()
                path?.lineWidth = 2
                path?.move(to: currentPoint)
                pathArray.append(path ?? UIBezierPath())
                pleaseSignLabel.isHidden = true
                isCompeleteClick.accept(true)
                compeleteBackGroundColor.accept(.blue)
            }else if sender.state == .changed {
                path?.addLine(to: currentPoint)
                
            }
            self.setNeedsDisplay()
        }

        /*根據 UIBezierPath 重新繪製*/
        override func draw(_ rect: CGRect) {
            for path in pathArray {
                UIColor.black.set() //簽名顏色
                path.stroke()
            }
        }

    /*清空*/
    func clearSign() {
            pathArray.removeAll()
            pleaseSignLabel.isHidden = false
            isCompeleteClick.accept(false)
            compeleteBackGroundColor.accept(#colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1))
            self.setNeedsDisplay()
        }
    /*簽名轉為圖片*/
    func saveSignToImage() -> UIImage? {
           UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
           guard let context = UIGraphicsGetCurrentContext() else {
               return nil
           }
           self.layer.render(in: context)
           let image = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return image
       }

}

