//
//  MainWeatherByHourView.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/9/24.
//

import UIKit
import SnapKit

final class MainWeatherByHourView: UIView {
  
  enum Metric {
    enum ContainerView {
      static let topBottom: CGFloat = 8
      static let leadingTrailing: CGFloat = 16
    }
    enum TitleLabel {
      static let top: CGFloat = 12
      static let leading: CGFloat = 12
    }
    enum SeparatorView {
      static let top: CGFloat = 8
      static let leadingTrailing: CGFloat = 12
      static let height: CGFloat = 1
    }
    enum WeatherScrollView {
      static let top: CGFloat = 8
      static let bottom: CGFloat = 12
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
  
  func update(weathers: [Weather]) {
    removeAllArrangedSubview()
    weathers
      .forEach {
        let itemView = MainWeatherByHoursItemView()
        itemView.update(
          time: dateFormatter.string(from: $0.date),
          iconImage: $0.weatherDatas.first?.icon,
          temperature: "\(Int(round($0.mainData.temp)))º")
        weathersStackView.addArrangedSubview(itemView)
      }
  }
  
  private func removeAllArrangedSubview() {
    weathersStackView.removeAllArrangedSubviews()
  }
  
}

extension MainWeatherByHourView {
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
      $0.top.equalToSuperview().inset(Metric.TitleLabel.top)
      $0.leading.equalToSuperview().inset(Metric.TitleLabel.leading)
    }
    containerView.addSubview(separatorView)
    separatorView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(Metric.SeparatorView.top)
      $0.leading.trailing.equalToSuperview().inset(Metric.SeparatorView.leadingTrailing)
      $0.height.equalTo(Metric.SeparatorView.height)
    }
    containerView.addSubview(weathersScrollView)
    weathersScrollView.snp.makeConstraints {
      $0.top.equalTo(separatorView.snp.bottom).offset(Metric.WeatherScrollView.top)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().inset(Metric.WeatherScrollView.bottom)
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

