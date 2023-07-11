//
//  SignatureVC.swift
//  SignatureViewProject
//
//  Created by PENG HSUAN JUNG on 2023/7/10.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class SignatureVC: UIViewController {
    private lazy var leftBackButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle(" 返回", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private lazy var rightCompeleteButton:UIButton = {
        let button: UIButton = UIButton()
        button.layer.cornerRadius = 5
        button.setTitle("完成", for: .normal)
        button.isUserInteractionEnabled = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
        button.addTarget(self, action: #selector(saveToImage), for: .touchDown)
        return button
    }()

    private lazy var signView: SignatureView = {
        let view: SignatureView = SignatureView()
        view.backgroundColor = .white
        view.layer.borderColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1).cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isMultipleTouchEnabled = false //關閉多點觸碰
        view.clipsToBounds = true //裁切超過板子的範圍
        return view
    }()
    
    private lazy var deleteButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("清除", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.adjustsImageWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cleanSign), for: .touchUpInside)
        return button
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView()
        spinner.style = .large
        spinner.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        spinner.setContentHuggingPriority(UILayoutPriority(750), for: .horizontal)
        spinner.setContentHuggingPriority(UILayoutPriority(750), for: .vertical)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private var disposeBag = DisposeBag()
    private var signatureRepository = SignatureRepository(apiManager: ApiManager())
    private lazy var viewModel = SignatureViewModel(signatureRepository: signatureRepository)
    
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindSignView()
        bindViewModel()
        
    }
    
    private func bindSignView() {
        signView.isCompeleteClick.bind(to: rightCompeleteButton.rx.isUserInteractionEnabled).disposed(by: disposeBag)
        signView.compeleteBackGroundColor.bind(to: rightCompeleteButton.rx.backgroundColor).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.output.isLoading.bind { isLoading in
            if isLoading {
                self.spinner.startAnimating()
            }else {
                self.spinner.stopAnimating()
            }
        }.disposed(by: disposeBag)
        
        viewModel.output.showAlertText.bind { text in
            self.showAlert(text: text)
        }.disposed(by: disposeBag)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        view.addSubview(leftBackButton)
        leftBackButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(88)
            make.height.equalTo(40)
        }
        
        view.addSubview(rightCompeleteButton)
        rightCompeleteButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(88)
            make.height.equalTo(40)
        }
        
        view.addSubview(signView)
        signView.snp.makeConstraints { (make) in
            make.top.equalTo(leftBackButton.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        view.addSubview(spinner)
        spinner.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(signView.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    private func showAlert(text:String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .cancel){ _ in
            self.dismiss(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    @objc private func cleanSign() {
        signView.clearSign()
    }
    
    /*包成給api的物件*/
    @objc private func saveToImage() {
        let image = signView.saveSignToImage()
        let name:String = ""
        var parameter:[String:String] = [:] //可放多種型別
        if let data = try? JSONEncoder().encode(name),
           let userStr = String(data: data, encoding: .utf8) {
            parameter = ["name":userStr]
        }
        viewModel.readSigntureApi(parameter: parameter,image: image ?? UIImage())
    }
 
}


