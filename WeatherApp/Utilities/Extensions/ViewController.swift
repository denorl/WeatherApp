//
//  ViewController.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 30/3/26.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String = "OK", errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: title, style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
