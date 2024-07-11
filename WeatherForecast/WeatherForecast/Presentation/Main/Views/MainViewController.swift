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
  let weatherByHourView = MainWeatherByHourView()
  let weatherForFiveDaysView = MainWeatherForFiveDaysView()
  let mapView = MainMapView()
  let otherDatasView = MainOtherDatasView()
  
  lazy var contentStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    return stackView
  }()
  
  let loadingView = MainLoadingView()
  
  let viewModel = MainViewModel()
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configure()
    bindViewModel()
  }
  
  private func bindViewModel() {
    
    viewModel
      .isFetching
      .observe(on: MainScheduler.instance)
      .bind { isFetching in
        self.updateLoadingView(isHidden: !isFetching)
        if isFetching {
          self.updateFetchingState()
        }
      }
      .disposed(by: disposeBag)
    
    viewModel
      .weatherResponse
      .asDriver()
      .drive { response in
        guard let response = response else { return }
        if let backgroundImageName = response.weathers.first?.weatherDatas.first?.main {
          self.backgroundImageView.image = UIImage(named: backgroundImageName.lowercased())
        }
        self.cityWeatherView.update(weatherResponse: response)
        self.mapView.update(city: response.city)
        self.otherDatasView.update(weatherResponse: response)
        self.showSubviews()
      }
      .disposed(by: disposeBag)
    
    viewModel
      .weathersByHour
      .asDriver(onErrorJustReturn: [])
      .drive(onNext: weatherByHourView.update)
      .disposed(by: disposeBag)
    
    viewModel
      .weathersForFiveDays
      .asDriver(onErrorJustReturn: [])
      .drive(onNext: weatherForFiveDaysView.update)
      .disposed(by: disposeBag)
    
    viewModel
      .errorOccurred
      .observe(on: MainScheduler.instance)
      .bind(onNext: self.showErrorAlertController)
      .disposed(by: disposeBag)
  }
  
  private func updateFetchingState() {
    let subviews: [UIView] = [
      cityWeatherView,
      weatherByHourView,
      weatherForFiveDaysView,
      mapView,
      otherDatasView
    ]
    subviews.forEach { subview in
      subview.alpha = 0
    }
  }
  
  private func updateLoadingView(isHidden: Bool) {
    loadingView.isHidden = isHidden
  }
  
  private func showSubviews() {
    let subviews: [UIView] = [
      cityWeatherView,
      weatherByHourView,
      weatherForFiveDaysView,
      mapView,
      otherDatasView
    ]
    subviews.forEach { subview in
      UIView.animate(withDuration: 0.3) {
        subview.alpha = 1
      }
    }
    
  }
  
  private func showErrorAlertController(error: Error) {
    let alertController = UIAlertController(
      title: "에러",
      message: "\(error.localizedDescription)\n잠시 후 다시 시도해주세요",
      preferredStyle: .alert)
    let action = UIAlertAction(title: "확인", style: .default)
    alertController.addAction(action)
    present(alertController, animated: true)
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
    layoutContentStackView()
    layoutLoadingView()
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
  
  private func layoutContentStackView() {
    scrollView.addSubview(contentStackView)
    contentStackView.snp.makeConstraints {
      $0.top.leading.bottom.trailing.centerX.equalToSuperview()
    }
    
    [
      searchBarView,
      cityWeatherView,
      weatherByHourView,
      weatherForFiveDaysView,
      mapView,
      otherDatasView
    ].forEach {
      contentStackView.addArrangedSubview($0)
    }
  }
  
  private func layoutLoadingView() {
    view.addSubview(loadingView)
    loadingView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
}
