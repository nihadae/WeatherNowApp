//
//  ViewController.swift
//  WheatherNow
//
//  Created by Nihad Alakbarzade on 14.08.22.
//

import UIKit
import CoreLocation

class WheatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate, CLLocationManagerDelegate{
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageLayer: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var roundedRectangle: UIImageView!
    @IBOutlet weak var humLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var current: UIButton!
    
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        current.layer.cornerRadius = 20
        current.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        let today = Date(timeInterval: 0, since: Date())
        let weekDay = Calendar.current.component(.weekday, from: today)
        let Month = Calendar.current.component(.month, from: today)
        let day = Calendar.current.component(.day, from: today)
        searchTextField.layer.cornerRadius = 20
        searchTextField.clipsToBounds = true
        
        timeLabel.fadeTransition(0.4)
        timeLabel.text = "\(Calendar.current.weekdaySymbols[weekDay-1]), \(day) \(Calendar.current.monthSymbols[Month-1])"
        
        gradientLayer.colors = [UIColor(red: 71/255, green: 191/255, blue: 223/255, alpha: 1).cgColor, UIColor(red: 54/255, green: 131/255, blue: 252/255, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        roundedRectangle.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).cgColor
        roundedRectangle.layer.cornerRadius = 20
        roundedRectangle.layer.borderWidth = 1
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManager.delegate = self
        
        searchTextField.delegate = self
        
        temperatureLabel.layer.shadowOffset = .zero
        temperatureLabel.layer.shadowRadius = 2.0
        temperatureLabel.layer.shadowOpacity = 0.5
        temperatureLabel.layer.masksToBounds = false
        temperatureLabel.layer.shouldRasterize = true
        temperatureLabel.layer.shadowColor = UIColor.white.cgColor
        
        descriptionLabel.layer.shadowOffset = .zero
        descriptionLabel.layer.shadowRadius = 2.0
        descriptionLabel.layer.shadowOpacity = 0.5
        descriptionLabel.layer.masksToBounds = false
        descriptionLabel.layer.shouldRasterize = true
        descriptionLabel.layer.shadowColor = UIColor.white.cgColor
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search a city", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray.withAlphaComponent(0.9)])
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.endEditing(true)
    }
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text{
            print(city)
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        
        DispatchQueue.main.async{
            self.cityName.fadeTransition(0.4)
            self.cityName.text = weather.cityName
            self.temperatureLabel.fadeTransition(0.4)
            self.temperatureLabel.text = "\(weather.temperatureString)°C"
            self.descriptionLabel.fadeTransition(0.4)
            self.descriptionLabel.text = weather.description
            self.feelsLikeLabel.fadeTransition(0.4)
            self.feelsLikeLabel.text = "\(weather.feelsLikeString)°C"
            self.humLabel.fadeTransition(0.4)
            self.humLabel.text = "\(weather.humidityLabel)%"
            self.windLabel.fadeTransition(0.4)
            self.windLabel.text = "\(weather.WindLabel)m/s"
            let toImage = UIImage(named: weather.conditionName)
            
            UIView.transition(with: self.imageLayer,
                              duration:0.4,
                              options: .transitionCrossDissolve,
                              animations: { self.imageLayer.image = toImage },
                              completion: nil)
        }
        
    }
    
    func didFailWithError(error: Error){
        print(error)
        let alert = UIAlertController(title: "Something is not right!", message: "No city found.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            @unknown default:
                fatalError()
            }
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(error)
    }
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

