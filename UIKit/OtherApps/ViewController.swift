//
//  ViewController.swift
//  OtherApps
//
//  Created by MH on 2024/03/07.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Other Apps"
        let button = UIButton(configuration: configuration, primaryAction: UIAction { _ in
            self.showOtherApps()
        })
        view.addSubview(button)
        button.frame = CGRect(x: 20, y: 100, width: 100, height: 50)
    }
    
    func showOtherApps() {
        let otherApps = OtherAppsViewController()
        present(otherApps, animated: true)
    }
}
