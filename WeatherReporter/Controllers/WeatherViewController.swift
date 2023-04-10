//
//  WeatherViewController.swift
//  WeatherReporter
//
//  Created by 7KINGSCODE on 4/10/23.
//  Copyright © 2023 Garika Sreekanth. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController
{
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func currentLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate
{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""
        {
            return true
        }else
        {
            textField.text = "Type Something"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        if let text = searchTextField.text
        {
            let textArr = text.split(separator: ",")

            if textArr.count == 1 {
                let city = textArr[0]
                weatherManager.fetchWeather(cityName: "\(city)")
            }else if textArr.count > 1 {
                let city = textArr[0]
                let countryCode = textArr[1].trimmingCharacters(in: .whitespaces)
                weatherManager.fetchWeather(cityName: "\(city)", countryCode: "\(countryCode)")
            }else if textArr.count > 2 {
                let city = textArr[0]
                let stateCode = textArr[1].trimmingCharacters(in: .whitespaces)
                let countryCode = textArr[2].trimmingCharacters(in: .whitespaces)
                
                weatherManager.fetchWeather(cityName: "\(city)", stateCode: "\(stateCode)", countryCode: "\(countryCode)")
            }
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate
{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempratureInString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    func didFailWithError(error: Error) {
        showToast(message: "\(error)")
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showToast(message: "\(error)")
    }
}
