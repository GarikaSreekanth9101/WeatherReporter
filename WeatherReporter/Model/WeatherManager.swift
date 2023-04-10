//
//  WeatherManager.swift
//  WeatherReporter
//
//  Created by 7KINGSCODE on 4/10/23.
//


import Foundation
//MARK: - WeatherManagerDelegate protocol
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
//MARK: - WeatherManager struture
struct WeatherManager
{
    var delegate: WeatherManagerDelegate?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=685a82f54ea0392a3223fb9fbde3fb81&units=metric"
    
    func fetchWeather(cityName: String)
    {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(cityName: String, countryCode: String)
    {
        let urlString = "\(weatherURL)&q=\(cityName),\(countryCode)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(cityName: String, stateCode: String, countryCode: String)
    {
        let urlString = "\(weatherURL)&q=\(cityName),\(stateCode),\(countryCode)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: Double,longitude: Double)
    {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    //getting json data from server
    func performRequest(with urlString: String)
    {
        //1. Create a URL
        if let url = URL(string: urlString)
        {
            //2.Create a URLSession
            let session = URLSession(configuration: .default)
            //3.Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil
                {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data
                {
                    if let weather = self.parseJSON(safeData) {
                        
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4.Start the task
            task.resume()
        }
    }
    //decoding json format to swift format
    func parseJSON(_ weatherData: Data) -> WeatherModel?
    {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let cityName = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditonId: id, cityName: cityName, temprature: temp)
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

