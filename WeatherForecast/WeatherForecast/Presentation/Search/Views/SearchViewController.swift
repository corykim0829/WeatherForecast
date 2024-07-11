//
//  SearchViewController.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/10/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SearchViewController: UIViewController {
  
  let backgroundBlurView: UIVisualEffectView = {
    let effect = UIBlurEffect(style: .light)
    let view = UIVisualEffectView(effect: effect)
    return view
  }()
  
  let searchBarView = SearchSearchBarView()
  
  lazy var dismissButton: UIButton = {
    let button = UIButton()
    let image = UIImage(systemName: "xmark")
    button.setImage(image, for: .normal)
    button.tintColor = .darkGray
    button.addTarget(self, action: #selector(dismissButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  lazy var cityListTableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.register(SearchCityCell.self, forCellReuseIdentifier: String(describing: SearchCityCell.self))
    return tableView
  }()
  
  let viewModel = SearchViewModel()
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .clear
    configure()
    bindViewModel()
  }
  
  @objc
  private func dismissButtonDidTap() {
    dismiss(animated: false)
  }
  
  private func bindViewModel() {
    viewModel
      .cities
      .asDriver()
      .drive(cityListTableView.rx.items(
        cellIdentifier: String(describing: SearchCityCell.self),
        cellType: SearchCityCell.self)) { index, city, cell in
          cell.update(city: city)
        }
        .disposed(by: disposeBag)
  }
  
}

extension SearchViewController {
  private func configure() {
    layout()
  }
  
  private func layout() {
    view.addSubview(backgroundBlurView)
    backgroundBlurView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    view.addSubview(searchBarView)
    searchBarView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.equalToSuperview()
    }
    view.addSubview(dismissButton)
    dismissButton.snp.makeConstraints {
      $0.centerY.equalTo(searchBarView).offset(4)
      $0.leading.equalTo(searchBarView.snp.trailing)
      $0.trailing.equalToSuperview().inset(16)
      $0.width.height.equalTo(36)
    }
    view.addSubview(cityListTableView)
    cityListTableView.snp.makeConstraints {
      $0.top.equalTo(searchBarView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
}
