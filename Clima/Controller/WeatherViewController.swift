//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
   
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
}

//MARK: -UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate{
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
       }
       
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        
        return true
    }
    func textFieldShouldEndEditing(_ searchTextField: UITextField) -> Bool {
        if searchTextField.text != ""{
            return true
        } else {
            searchTextField.placeholder = "Type something"
            return false
        }
        
    }
    func textFieldDidEndEditing(_ searchTextField: UITextField) {
        
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
            
        }
        //        print(searchTextField.text!)
        
        searchTextField.text = ""
        
        
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate{
    
      func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
          DispatchQueue.main.async {
              self.temperatureLabel.text = weather.temperatureStr
              self.conditionImageView.image = UIImage(systemName: weather.conditionName)
              self.cityLabel.text = weather.cityName
          }
      }
      func didFailWithError(error: Error) {
          print(error)
      }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
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
