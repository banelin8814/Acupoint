//
//  DetailVC.swift
//  Acupoint
//
//  Created by 林佑淳 on 2024/4/26.
//

import UIKit

// DetailViewController.swift
class DetailVC: UIViewController {
    
    var acupoint: FaceAcupointModel?
    
     let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
     let acupointNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
     let introTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.isEditable = false
        return textView
    }()
    
    private let closeButton: UIButton = {
          let button = UIButton(type: .system)
          button.setTitle("Close", for: .normal)
          button.translatesAutoresizingMaskIntoConstraints = false
          return button
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blurView)
        view.addSubview(acupointNameLabel)
        view.addSubview(introTextView)
        view.addSubview(closeButton)

        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            acupointNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            acupointNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            acupointNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            introTextView.topAnchor.constraint(equalTo: acupointNameLabel.bottomAnchor, constant: 20),
            introTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            introTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            introTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        if let acupoint = acupoint {
            acupointNameLabel.text = acupoint.name
            introTextView.text = "手法：\(acupoint.method)"
        }
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

    }
    
    @objc private func closeButtonTapped() {
          dismiss(animated: true, completion: nil)
      }
}

