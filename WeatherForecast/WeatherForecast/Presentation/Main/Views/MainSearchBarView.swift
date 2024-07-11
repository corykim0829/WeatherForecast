//
//  MainSearchBarView.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/10/24.
//

import UIKit
import SnapKit

protocol MainSearchBarViewDelegate: AnyObject {
  func searchBarButtonDidTap()
}

final class MainSearchBarView: UIView {
  
  enum Metric {
    enum SearchBarView {
      static let top: CGFloat = 12
      static let leadingTrailing: CGFloat = 12
      static let bottom: CGFloat = 8
      static let height: CGFloat = 36
    }
    enum MagnifyingGlassIconImageView {
      static let leading: CGFloat = 8
      static let side: CGFloat = 20
    }
    enum PlaceHolderLabel {
      static let leading: CGFloat = 24
    }
  }
  
  lazy var searchBarView: UIView = {
    let view = UIView()
    view.backgroundColor = .white.withAlphaComponent(0.4)
    view.layer.cornerRadius = 12
    return view
  }()
  
  lazy var magnifyingGlassIconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "magnifyingglass")
    imageView.tintColor = .darkGray
    return imageView
  }()
  
  lazy var placeholderLabel: UILabel = {
    let label = UILabel()
    label.text = "Search"
    label.textColor = .darkGray
    label.font = .systemFont(ofSize: 16, weight: .regular)
    return label
  }()
  
  lazy var searchBarButton: UIButton = {
    let button = UIButton()
    button.addTarget(self, action: #selector(searchBarButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  weak var delegate: MainSearchBarViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  @objc
  private func searchBarButtonDidTap() {
    delegate?.searchBarButtonDidTap()
  }
  
}

extension MainSearchBarView {
  private func configure() {
    layout()
  }
  
  private func layout() {
    addSubview(searchBarView)
    searchBarView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(Metric.SearchBarView.top)
      $0.leading.trailing.equalToSuperview().inset(Metric.SearchBarView.leadingTrailing)
      $0.bottom.equalToSuperview().inset(Metric.SearchBarView.bottom)
      $0.height.equalTo(Metric.SearchBarView.height)
    }
    searchBarView.addSubview(magnifyingGlassIconImageView)
    magnifyingGlassIconImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(Metric.MagnifyingGlassIconImageView.leading)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(Metric.MagnifyingGlassIconImageView.side)
    }
    searchBarView.addSubview(placeholderLabel)
    placeholderLabel.snp.makeConstraints {
      $0.leading.equalTo(magnifyingGlassIconImageView.snp.trailing).offset(Metric.PlaceHolderLabel.leading)
      $0.centerY.equalToSuperview()
    }
    searchBarView.addSubview(searchBarButton)
    searchBarButton.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
}
