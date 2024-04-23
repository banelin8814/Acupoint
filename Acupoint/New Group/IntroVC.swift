import UIKit

class IntroVC: UIViewController {

    lazy var introImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "intro")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var introNameLbl: UILabel = {
        let label = UILabel()
        label.text = "穴位名稱"
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var introPostionLbl: UILabel = {
        let label = UILabel()
        label.text = "穴位位置"
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(introImageView)
        view.addSubview(introNameLbl)
        view.addSubview(introPostionLbl)

        setupUI()
    }
    
    func setupUI() {
        
        NSLayoutConstraint.activate([
            introImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            introImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            introImageView.widthAnchor.constraint(equalToConstant: 200),
            introImageView.heightAnchor.constraint(equalToConstant: 200),
            introNameLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            introNameLbl.topAnchor.constraint(equalTo: introImageView.bottomAnchor, constant: 20),
            introPostionLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            introPostionLbl.topAnchor.constraint(equalTo: introNameLbl.bottomAnchor, constant: 20),
        ])
    }
}
