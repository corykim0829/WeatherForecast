//
//  MainViewController.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/9/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxRelay

final class MainViewController: UIViewController {

  let scrollView = UIScrollView()
  
  lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.image = UIImage(named: "sunny")
    return imageView
  }()
  let cityWeatherView = MainCityWeatherView()
  let weatherByHoursView = WeatherByHoursView()
  
  lazy var weatherForFiveDaysView: UIView = {
    let view = UIView()
    view.backgroundColor = .red
    return view
  }()
  
  let viewModel = MainViewModel()
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    layout()
    bindViewModel()
  }
  
  private func bindViewModel() {
    
    viewModel
      .weatherResponse
      .asDriver()
      .drive { response in
        guard let response = response else { return }
        if let backgroundImageName = response.weathers.first?.weatherDatas.first?.main {
          self.backgroundImageView.image = UIImage(named: backgroundImageName.lowercased())
        }
        self.cityWeatherView.update(weatherResponse: response)
        self.weatherByHoursView.update(weatherResponse: response)
      }
      .disposed(by: disposeBag)
  }

}

extension MainViewController {
  
  private func layout() {
    layoutBackgroundImageView()
    layoutScrollView()
    layoutCityWeatherView()
    layoutWeatherByHoursView()
    layoutWeatherForFiveDaysView()
  }
  
  private func layoutBackgroundImageView() {
    view.addSubview(backgroundImageView)
    backgroundImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func layoutScrollView() {
    view.addSubview(scrollView)
    scrollView.alwaysBounceVertical = true
    scrollView.alwaysBounceHorizontal = false
    scrollView.backgroundColor = .clear
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
