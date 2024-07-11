//
//  SearchSearchBarView.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/10/24.
//

import UIKit
import SnapKit

final class SearchSearchBarView: UIView {
  
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
    enum SearchTextField {
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
  
  lazy var searchTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Search"
    textField.font = .systemFont(ofSize: 16, weight: .regular)
    return textField
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
}

extension SearchSearchBarView {
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
    searchBarView.addSubview(searchTextField)
    searchTextField.snp.makeConstraints {
      $0.leading.equalTo(magnifyingGlassIconImageView.snp.trailing).offset(Metric.SearchTextField.leading)
      $0.centerY.equalToSuperview()
    }
  }
  
}
