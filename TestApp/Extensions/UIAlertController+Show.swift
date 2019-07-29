//
//  UIAlertController+Show.swift
//  TestApp
//
//  Created by Shahriar Mahmud on 26/7/19.
//  Copyright © 2019 Shahriar Mahmud. All rights reserved.
//

import UIKit


extension UIAlertController {
    
    func show() {
        if let visibleViewController = UIApplication.shared.keyWindow?.visibleViewController() {
            DispatchQueue.main.async(execute: {
                visibleViewController.present(self, animated: true, completion: nil)
            })
        } else {
            print("Can not show AlertController As there is no visibleViewController")
        }
    }
    
}
