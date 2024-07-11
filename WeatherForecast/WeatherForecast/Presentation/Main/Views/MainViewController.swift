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
  
  let searchBarView = MainSearchBarView()
  let cityWeatherView = MainCityWeatherView()
  let weatherByHoursView = MainWeatherByHoursView()
  let weatherForFiveDaysView = MainWeatherForFiveDaysView()
  let mapView = MainMapView()
  
  let viewModel = MainViewModel()
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configure()
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
        self.mapView.update(city: response.city)
      }
      .disposed(by: disposeBag)
    
    viewModel
      .weathersForFiveDays
      .asDriver(onErrorJustReturn: [])
      .drive(onNext: weatherForFiveDaysView.update)
      .disposed(by: disposeBag)
  }

}

// MARK: - MainSearchBarViewDelegate

extension MainViewController: MainSearchBarViewDelegate {
  func searchBarButtonDidTap() {
    let searchViewController = SearchViewController()
    searchViewController.modalPresentationStyle = .overCurrentContext
    searchViewController.delegate = self
    present(searchViewController, animated: false)
  }
  
}

// MARK: - SearchViewControllerDelegate

extension MainViewController: SearchViewControllerDelegate {
  func searchViewController(_ viewController: SearchViewController, didSelectCellItem item: City) {
    viewModel.fetchWeather(city: item)
  }
}

// MARK: - Configuration

extension MainViewController {
  
  private func configure() {
    view.backgroundColor = .white
    configureDelegate()
    layout()
  }
  
  private func configureDelegate() {
    searchBarView.delegate = self
  }
  
  private func layout() {
    layoutBackgroundImageView()
    layoutScrollView()
    layoutSearchBarView()
    layoutCityWeatherView()
    layoutWeatherByHoursView()
    layoutWeatherForFiveDaysView()
    layoutMapView()
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
  
  private func layoutSearchBarView() {
    scrollView.addSubview(searchBarView)
    searchBarView.snp.makeConstraints {
      $0.top.leading.trailing.centerX.equalToSuperview()
    }
  }
  
  private func layoutCityWeatherView() {
    scrollView.addSubview(cityWeatherView)
    cityWeatherView.snp.makeConstraints {
      $0.top.equalTo(searchBarView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
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
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  private func layoutMapView() {
    scrollView.addSubview(mapView)
    mapView.snp.makeConstraints {
      $0.top.equalTo(weatherForFiveDaysView.snp.bottom)
      $0.leading.bottom.trailing.equalToSuperview()
    }
  }
  
}
