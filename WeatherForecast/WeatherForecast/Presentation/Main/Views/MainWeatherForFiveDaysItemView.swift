//
//  MainWeatherForFiveDaysItemView.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/10/24.
//

import UIKit
import SnapKit

final class MainWeatherForFiveDaysItemView: UIView {
  
  lazy var dayLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .semibold)
    label.textColor = .white
    return label
  }()
  
  lazy var weatherIconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  lazy var temperatureLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.textAlignment = .right
    label.font = .systemFont(ofSize: 14, weight: .semibold)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  func update(day: String, icon: String, tempMin: Double, tempMax: Double) {
    dayLabel.text = day
    weatherIconImageView.image = UIImage(named: icon)
    temperatureLabel.text = "최소: \(Int(round(tempMin)))º  최대: \(Int(round(tempMax)))º"
  }
  
}

extension MainWeatherForFiveDaysItemView {
  private func configure() {
    layout()
  }
  
  private func layout() {
    addSubview(dayLabel)
    dayLabel.snp.makeConstraints {
      $0.leading.centerY.equalToSuperview()
    }
    
    addSubview(weatherIconImageView)
    weatherIconImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(80)
      $0.top.bottom.equalToSuperview()
      $0.width.height.equalTo(36)
    }
    
    addSubview(temperatureLabel)
    temperatureLabel.snp.makeConstraints {
      $0.trailing.centerY.equalToSuperview()
    }
  }
  
}
