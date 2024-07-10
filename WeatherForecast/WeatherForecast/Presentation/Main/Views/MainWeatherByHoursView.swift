//
//  MainWeatherByHoursView.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/9/24.
//

import UIKit
import SnapKit

final class MainWeatherByHoursView: UIView {
  
  enum Metric {
    enum ContainerView {
      static let topBottom: CGFloat = 8
      static let leadingTrailing: CGFloat = 16
    }
  }
  
  lazy var containerView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 12
    view.clipsToBounds = true
    view.backgroundColor = .darkGray
    return view
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "이틀간의 일기예보"
    label.font = .systemFont(ofSize: 14, weight: .regular)
    label.textColor = .white
    return label
  }()
  
  lazy var separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    return view
  }()
  
  lazy var weathersScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.alwaysBounceVertical = false
    scrollView.alwaysBounceHorizontal = true
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.contentInset = .init(top: 0, left: 12, bottom: 0, right: 12)
    return scrollView
  }()
  
  lazy var weathersStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 4
    return stackView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  func update(weatherResponse: WeatherResponse) {
    weatherResponse
      .weathers
      .filter {
        $0.date <= Date().addingTimeInterval(60 * 60 * 48)
      }
      .forEach {
        let itemView = MainWeatherByHoursItemView()
        itemView.update(
          time: dateFormatter.string(from: $0.date),
          iconImage: $0.weatherDatas.first?.icon,
          temperature: "\(Int(round($0.mainData.temp)))º")
        weathersStackView.addArrangedSubview(itemView)
      }
  }
  
}

extension MainWeatherByHoursView {
  private func configure() {
    backgroundColor = .clear
    layout()
  }
  
  private func layout() {
    addSubview(containerView)
    containerView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(Metric.ContainerView.topBottom)
      $0.leading.trailing.equalToSuperview().inset(Metric.ContainerView.leadingTrailing)
    }
    containerView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(12)
      $0.leading.equalToSuperview().inset(12)
    }
    containerView.addSubview(separatorView)
    separatorView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview().inset(12)
      $0.height.equalTo(1)
    }
    containerView.addSubview(weathersScrollView)
    weathersScrollView.snp.makeConstraints {
      $0.top.equalTo(separatorView.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().inset(12)
    }
    
    weathersScrollView.addSubview(weathersStackView)
    weathersStackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
    
  }
  
}

private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "a h시"
  formatter.calendar = Calendar(identifier: .iso8601)
  formatter.locale = Locale(identifier: "ko_KR")
  return formatter
}()

