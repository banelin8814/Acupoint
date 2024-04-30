import UIKit

class PromptVC: UIViewController {

    lazy var promptImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "intro")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var promptNameLbl: UILabel = {
        let label = UILabel()
        label.configureHeadingOneLabel(withText: "穴位名稱")
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var promptPostionLbl: UILabel = {
        let label = UILabel()
        label.configureTextOneLabel(withText: "")
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(promptImageView)
        view.addSubview(promptNameLbl)
        view.addSubview(promptPostionLbl)

        setupUI()
    }
    
    func setupUI() {
        
        NSLayoutConstraint.activate([
            promptImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promptImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            promptImageView.widthAnchor.constraint(equalToConstant: 200),
            promptImageView.heightAnchor.constraint(equalToConstant: 200),
            promptNameLbl.heightAnchor.constraint(equalToConstant: 40),
            promptNameLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promptNameLbl.topAnchor.constraint(equalTo: promptImageView.bottomAnchor, constant: 20),
            promptPostionLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promptPostionLbl.topAnchor.constraint(equalTo: promptNameLbl.bottomAnchor, constant: 20),
            promptPostionLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            promptPostionLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}
