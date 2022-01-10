import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func show(_ sender: Any) {
        LoadingWindow.sharedInstance.showWindow(time: 9)
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            LoadingWindow.sharedInstance.hideWindow()
        }
    }
}

public class LoadingWindow {
    
    public static let sharedInstance = LoadingWindow()
    
    let backgroundView = UIView()
    let blackView = UIView()
    let textLabel = UILabel()
    let loading = UIActivityIndicatorView()
    let stackView = UIStackView()
    var time = 5
    private init() {
        backgroundView.frame = UIScreen.main.bounds
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.alpha = 0
        blackView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        blackView.translatesAutoresizingMaskIntoConstraints = false
        blackView.layer.cornerRadius = 10
        textLabel.textColor = .white
        textLabel.text  = "Loading"
        textLabel.textAlignment = .center
        textLabel.center = backgroundView.center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.autoresizesSubviews = false
        
        loading.startAnimating()
        loading.color = UIColor.white
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.fillProportionally
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 8.0
        stackView.addArrangedSubview(loading)
        stackView.addArrangedSubview(textLabel)
        self.backgroundView.addSubview(self.blackView)
        self.blackView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.backgroundView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            self.backgroundView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height),
        ])
        NSLayoutConstraint.activate([
            self.blackView.centerXAnchor.constraint(equalTo: self.backgroundView.centerXAnchor),
            self.blackView.centerYAnchor.constraint(equalTo: self.backgroundView.centerYAnchor),
            self.blackView.widthAnchor.constraint(equalToConstant: 100),
            self.blackView.heightAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            self.stackView.centerXAnchor.constraint(equalTo: self.blackView.centerXAnchor),
            self.stackView.centerYAnchor.constraint(equalTo: self.blackView.centerYAnchor),
        ])
    }
    
    func showWindow(time:Int = -1){
        UIApplication.shared.keyWindow?.addSubview(self.backgroundView)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
            self.backgroundView.alpha = 1
            self.time = time
        }
        if time > -1 {
            self.textLabel.text = "Loading \(self.time)"
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.time >= 0 {
                self.textLabel.text = "Loading \(self.time)"
                self.time -= 1
            } else {
                self.textLabel.text = "Loading"
                timer.invalidate()
            }
        }
    }
    
    func hideWindow(){
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
            self.backgroundView.alpha = 0
        } completion: { _ in
            self.backgroundView.removeFromSuperview()
        }

    }
}
