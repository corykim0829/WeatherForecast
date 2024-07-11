//
//  MainWeatherForFiveDaysView.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/10/24.
//

import UIKit
import SnapKit

final class MainWeatherForFiveDaysView: UIView {
  
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
    view.backgroundColor = .clear
    return view
  }()
  
  lazy var backgroundBlurView: UIVisualEffectView = {
    let effect = UIBlurEffect(style: .dark)
    let view = UIVisualEffectView(effect: effect)
    return view
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "5일간의 일기예보"
    label.font = .systemFont(ofSize: 14, weight: .regular)
    label.textColor = .white
    return label
  }()
  
  lazy var separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    return view
  }()
  
  lazy var weathersStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
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
  
  func update(weathersByDay: [WeatherByDay]) {
    removeAllArrangedSubviews()
    let sortedWeathers = weathersByDay.sorted {
      $0.date < $1.date
    }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "E"
    formatter.locale = Locale(identifier: "ko_KR")
    
    sortedWeathers.forEach {
      let itemView = MainWeatherForFiveDaysItemView()
      let day = formatter.string(from: $0.date)
      let currentDay = formatter.string(from: Date())
      let dayString = day == currentDay ? "오늘" : day
      itemView.update(
        day: dayString,
        icon: $0.weatherIcon,
        tempMin: $0.tempMin,
        tempMax: $0.tempMax)
      weathersStackView.addArrangedSubview(itemView)
    }
    
  }
  
  private func removeAllArrangedSubviews() {
    weathersStackView.removeAllArrangedSubviews()
  }
  
}

extension MainWeatherForFiveDaysView {
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
    containerView.addSubview(backgroundBlurView)
    backgroundBlurView.snp.makeConstraints {
      $0.edges.equalToSuperview()
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
    containerView.addSubview(weathersStackView)
    weathersStackView.snp.makeConstraints {
      $0.top.equalTo(separatorView.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview().inset(12)
      $0.bottom.equalToSuperview().inset(12)
    }
    
  }
  
}
