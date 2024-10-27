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

protocol SearchViewControllerDelegate: AnyObject {
  func searchViewController(
    _ viewController: SearchViewController,
    didSelectCellItem item: City)
}

final class SearchViewController: UIViewController {
	
	enum Section {
		case main
	}
  
  enum Metric {
    enum DismissButton {
      static let side: CGFloat = 36
      static let centerYOffset: CGFloat = 4
      static let trailing: CGFloat = 16
    }
  }
  
  lazy var backgroundBlurView: UIVisualEffectView = {
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
  
	var cityListCollectionView: UICollectionView!
	
	var dataSource: UICollectionViewDiffableDataSource<Section, City>!
  
  let viewModel = SearchViewModel()
  
  let disposeBag = DisposeBag()
  
  weak var delegate: SearchViewControllerDelegate?
  
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
			.observe(on: MainScheduler())
			.bind { cities in
				var snapShot = NSDiffableDataSourceSnapshot<Section, City>()
				snapShot.appendSections([.main])
				snapShot.appendItems(cities)
				self.dataSource.apply(snapShot)
			}
			.disposed(by: disposeBag)
    
    searchBarView
      .searchTextField
      .rx
      .text
      .orEmpty
      .bind(onNext: viewModel.searchKeyword.accept(_:))
      .disposed(by: disposeBag)
  }
	
	private func configureCityListCollectionViewDataSource() {
		let cellRegistration = UICollectionView.CellRegistration<SearchCityCell, City> { cell, indexPath, itemIdentifier in
			cell.update(city: itemIdentifier)
		}
		
		dataSource = UICollectionViewDiffableDataSource<Section, City>(
			collectionView: cityListCollectionView,
			cellProvider: { collectionView, indexPath, itemIdentifier in
				return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
			})
	}
  
}

extension SearchViewController {
  private func configure() {
		configureCityListCollectionView()
		configureCityListCollectionViewDataSource()
    layout()
  }
	
	private func createLayout() -> UICollectionViewLayout {
		var config = UICollectionLayoutListConfiguration(appearance: .plain)
		config.backgroundColor = .clear
		return UICollectionViewCompositionalLayout.list(using: config)
	}
	
	private func configureCityListCollectionView() {
		let cityListCollectionViewLayout = createLayout()
		cityListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: cityListCollectionViewLayout)
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
      $0.centerY.equalTo(searchBarView).offset(Metric.DismissButton.centerYOffset)
      $0.leading.equalTo(searchBarView.snp.trailing)
      $0.trailing.equalToSuperview().inset(Metric.DismissButton.trailing)
      $0.width.height.equalTo(Metric.DismissButton.side)
    }
    view.addSubview(cityListCollectionView)
    cityListCollectionView.snp.makeConstraints {
      $0.top.equalTo(searchBarView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
}
