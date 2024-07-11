//
//  MainOtherDatasView.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/11/24.
//

import UIKit
import SnapKit

final class MainOtherDatasView: UIView {
  
  enum Metric {
    static let top: CGFloat = 8
    static let leadingTrailing: CGFloat = 16
    static let containerInterSpacing: CGFloat = 16
    static let bottom: CGFloat = 16
  }
  
  lazy var humidityContainerView = MainOtherDataItemView()
  lazy var cloudContainerView = MainOtherDataItemView()
  lazy var windContainerView = MainOtherDataItemView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  func update(weatherResponse: WeatherResponse) {
    guard let weather = weatherResponse.weathers.first else {
      return
    }
    humidityContainerView.update(title: "습도", mainData: "\(weather.mainData.humidity)%")
    cloudContainerView.update(title: "구름", mainData: "\(weather.clouds.all)%")
    windContainerView.update(
      title: "바람 속도",
      mainData: "\(weather.wind.speed)m/s",
      subData: "강풍: \(weather.wind.gust)m/s")
  }
  
}

extension MainOtherDatasView {
  private func configure() {
    layout()
  }
  
  private func layout() {
    addSubview(humidityContainerView)
    humidityContainerView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(Metric.top)
      $0.leading.equalToSuperview().inset(Metric.leadingTrailing)
      $0.height.equalTo(humidityContainerView.snp.width)
    }
    addSubview(cloudContainerView)
    cloudContainerView.snp.makeConstraints {
      $0.top.equalTo(humidityContainerView)
      $0.leading.equalTo(humidityContainerView.snp.trailing).offset(Metric.containerInterSpacing)
      $0.trailing.equalToSuperview().inset(Metric.leadingTrailing)
      $0.width.equalTo(humidityContainerView.snp.width)
      $0.height.equalTo(cloudContainerView.snp.width)
    }
    addSubview(windContainerView)
    windContainerView.snp.makeConstraints {
      $0.top.equalTo(humidityContainerView.snp.bottom).offset(Metric.containerInterSpacing)
      $0.leading.trailing.equalTo(humidityContainerView)
      $0.bottom.equalToSuperview().inset(Metric.bottom)
      $0.height.equalTo(windContainerView.snp.width)
    }
  }
  
}
