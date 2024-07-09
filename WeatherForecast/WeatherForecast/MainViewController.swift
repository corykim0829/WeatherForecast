//
//  MainViewController.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/9/24.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {

  let scrollView = UIScrollView()
  
  let cityWeatherView = MainCityWeatherView()
  
  lazy var weatherByHoursView: UIView = {
    let view = UIView()
    view.backgroundColor = .blue
    return view
  }()
  
  lazy var weatherForFiveDaysView: UIView = {
    let view = UIView()
    view.backgroundColor = .red
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    layout()
    
    // temp
    cityWeatherView.update(cityTitle: "Seoul", currentTemperature: 24.8, weather: "Rain", minTemp: 20.3, maxTemp: 27)
  }

}

extension MainViewController {
  
  private func layout() {
    layoutScrollView()
    layoutCityWeatherView()
    layoutWeatherByHoursView()
    layoutWeatherForFiveDaysView()
  }
  
  private func layoutScrollView() {
    view.addSubview(scrollView)
    scrollView.alwaysBounceVertical = true
    scrollView.alwaysBounceHorizontal = false
    scrollView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.bottom.equalTo(view)
    }
    
  }
  
  private func layoutCityWeatherView() {
    scrollView.addSubview(cityWeatherView)
    cityWeatherView.snp.makeConstraints {
      $0.top.leading.trailing.centerX.equalToSuperview()
    }
  }
  
  private func layoutWeatherByHoursView() {
    scrollView.addSubview(weatherByHoursView)
    weatherByHoursView.snp.makeConstraints {
      $0.top.equalTo(cityWeatherView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(160)
    }
  }
  
  private func layoutWeatherForFiveDaysView() {
    scrollView.addSubview(weatherForFiveDaysView)
    weatherForFiveDaysView.snp.makeConstraints {
      $0.top.equalTo(weatherByHoursView.snp.bottom)
      $0.leading.bottom.trailing.equalToSuperview()
      $0.height.equalTo(500)
    }
  }
  
}
