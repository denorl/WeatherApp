//
//  ViewController.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 25/3/26.
//

import UIKit
import Alamofire

protocol WeatherViewProtocol: AnyObject {
    func updateUI(with weatherViewModel: WeatherViewModel)
    func toggleActivityIndicator(on: Bool)
}

final class WeatherViewController: UIViewController {
    var presenter: WeatherPresenterProtocol?
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var feelsLikeLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
            
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    //MARK: - IBActions
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        presenter?.updateWeather()
    }
}

//MARK: - WeatherViewProtocol
extension WeatherViewController: WeatherViewProtocol {
    func updateUI(with weatherViewModel: WeatherViewModel) {
        locationLabel.text = weatherViewModel.locality
        temperatureLabel.text = weatherViewModel.temperature
        feelsLikeLabel.text =  "Feels like: \(weatherViewModel.feelsLike)"
        humidityLabel.text = weatherViewModel.humidity
        pressureLabel.text = weatherViewModel.pressure
        
        let imageConfig = UIImage.SymbolConfiguration(paletteColors: [weatherViewModel.weatherIcon.tintColor])
        let image = UIImage(systemName: weatherViewModel.weatherIcon.name, withConfiguration: imageConfig)
        
        if #available(iOS 17.0, *) {
            weatherImage.setSymbolImage(image!, contentTransition: .replace)
        } else {
            weatherImage.image = image
        }
    }
    
    func toggleActivityIndicator(on: Bool) {
        if on {
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
        }
    }
}

//MARK: - Private Methods
private extension WeatherViewController {
    func updateWeatherImage(with icon: WeatherIcon) {
        let imageConfig = UIImage.SymbolConfiguration(paletteColors: [icon.tintColor])
        let image = UIImage(systemName: icon.name, withConfiguration: imageConfig)
        
        if #available(iOS 17.0, *) {
            weatherImage.setSymbolImage(image!, contentTransition: .replace)
        } else {
            weatherImage.image = image
        }
    }
}
