//
//  CommonUtils.swift
//  SiddharthSuneel-Task
//
//  Created by Siddharth Suneel on 18/12/24.
//

import Foundation
import UIKit

class CommonUtils {
    //MARK: Alert Methods

    /*
     Used to show alert message with the title & message string
     - Parameter title: title String
     - Parameter message: message String
     */
    class func showOkAlertWithTitle(_ title: String,
                                    message: String,
                                    actionHandler: @escaping (UIAlertAction.Style) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.default,
                                      handler: { action in
                                        actionHandler(action.style)
        }))
        self.showAlert(alert)
    }

    /*
     Common function to show alert
     - Parameter alert: UIAlertController object to show
     */
    class func showAlert(_ alert: UIAlertController) {
        if let alertViewController = self.visibleViewController() {
            alertViewController.present(alert, animated: true, completion: nil)
        }
    }

    /*
     Used to get the current visible controller
     - return UIViewController
     */
    class func visibleViewController() -> UIViewController? {
        let scene = UIApplication.shared.connectedScenes.first
        if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate),
            let rootVC = sd.window?.rootViewController {
            return self.findVisibleViewController(vc: rootVC)
        }
        return nil
    }

    /*
     Used to find current visible controller on the window
     - Paramter UIViewController: view controller
     - returns UIViewController
     */
    class func findVisibleViewController(vc : UIViewController) -> UIViewController {

        if (vc.presentedViewController != nil) {
            return self.findVisibleViewController(vc: vc.presentedViewController!)
        } else if vc.isKind(of: UISplitViewController.self) {
            let svc = vc as! UISplitViewController
            if svc.viewControllers.count>0 {
                return self.findVisibleViewController(vc: svc.viewControllers.last!)
            } else {
                return vc
            }
        } else if vc.isKind(of: UINavigationController.self) {
            let nvc = vc as! UINavigationController
            if nvc.viewControllers.count>0 {
                return self.findVisibleViewController(vc: nvc.topViewController!)
            } else {
                return vc
            }
        } else if vc.isKind(of: UITabBarController.self) {
            let tvc = vc as! UITabBarController
            if (tvc.viewControllers?.count)!>0 {
                return self.findVisibleViewController(vc: tvc.selectedViewController!)
            } else {
                return vc
            }
        } else {
            return vc
        }
    }
}
