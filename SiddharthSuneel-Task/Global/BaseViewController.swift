//
//  BaseViewController.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 18/12/24.
//

import UIKit

class BaseViewController: UIViewController {

    var activityIndicator: UIActivityIndicatorView?

    //MARK: Life Cycle Methods
    override open func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Private Methods
    private func setup() {
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator?.center = self.view.center
        activityIndicator?.color = UIColor.red
        activityIndicator?.hidesWhenStopped = true
        guard let indicator = activityIndicator else {
            return
        }
        UIApplication.shared.keyWindow?.addSubview(indicator)
    }

    //MARK: Public Methods
    open func hideActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator?.stopAnimating()
        }
    }

    open func showActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator?.startAnimating()
            self?.activityIndicator?.isHidden = false
        }
    }
}
