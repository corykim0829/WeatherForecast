//
//  WeatherByHoursItemView.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/9/24.
//

import UIKit
import SnapKit

final class WeatherByHoursItemView: UIView {
  
  enum Metric {
    static let width: CGFloat = 60
    static let iconWidth: CGFloat = 48
  }
  
  lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    return stackView
  }()
  
  lazy var timeLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 14, weight: .regular)
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
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 16, weight: .semibold)
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
  
  func update(time: String, iconImage: String?, temperature: String) {
    timeLabel.text = time
    if let iconImage = iconImage {
      weatherIconImageView.image = UIImage(named: iconImage)
    }
    temperatureLabel.text = temperature
  }
  
}

extension WeatherByHoursItemView {
  private func configure() {
    layout()
  }
  
  private func layout() {
    addSubview(stackView)
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    [
      timeLabel,
      weatherIconImageView,
      temperatureLabel
    ].forEach {
      stackView.addArrangedSubview($0)
    }
    
    weatherIconImageView.snp.makeConstraints {
      $0.height.equalTo(Metric.iconWidth)
    }
    
    snp.makeConstraints {
      $0.width.equalTo(Metric.width)
    }
  }
  
}
