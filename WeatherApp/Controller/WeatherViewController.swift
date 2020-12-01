//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Кириченко on 18.11.2020.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var conditionImageView: UIImageView!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var appearentTemperatureLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var searchTextField: UITextField!
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    private let primaryColor = UIColor(red: 210/255, green: 109/255, blue: 128/255, alpha: 1)
    private let secondaryColor = UIColor(red: 107/255, green: 148/255, blue: 230/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
       
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        addVerticalGradientLayer(topColor: primaryColor, buttomColor: secondaryColor)
        toggleActivityIndicator(on: true)
    }
    
    @IBAction func locationPredded(_ sender: UIButton) {
        locationManager.requestLocation()
        toggleActivityIndicator(on: true)
    }
    
    func toggleActivityIndicator(on: Bool) {
      if on {
        activityIndicator.startAnimating()
      } else {
        activityIndicator.stopAnimating()
      }
    }
}


//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cytyName: city)
        }
        searchTextField.text = ""
    }
}


//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.toggleActivityIndicator(on: false)
            self.temperatureLabel.text = "\(weather.temperatureString)˚C"
            self.conditionImageView.image = UIImage(named: weather.conditionName)
            self.locationLabel.text = weather.cityName
            self.pressureLabel.text = "\(weather.pressureString) mm"
            self.humidityLabel.text = "\(weather.humidityString) %"
            self.appearentTemperatureLabel.text = "Feels like \(weather.apparentTemperatureString)˚C"
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


// MARK: - Set background color
extension WeatherViewController {
    func addVerticalGradientLayer(topColor: UIColor, buttomColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [topColor.cgColor, buttomColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(gradient, at: 0)
    }
}


