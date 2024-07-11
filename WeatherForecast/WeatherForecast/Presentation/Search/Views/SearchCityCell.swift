//
//  SearchCityCell.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/11/24.
//

import UIKit
import SnapKit

final class SearchCityCell: UITableViewCell {
  
  enum Metric {
    enum StackView {
      static let topBottom: CGFloat = 8
      static let leading: CGFloat = 12
    }
  }
  
  lazy var cityLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .semibold)
    label.textColor = .white
    return label
  }()
  
  lazy var countryLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .regular)
    label.textColor = .white
    return label
  }()
  
  lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 4
    return stackView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  func update(city: City) {
    cityLabel.text = city.name
    countryLabel.text = city.country
  }
  
}

extension SearchCityCell {
  private func configure() {
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    layout()
  }
  
  private func layout() {
    contentView.addSubview(stackView)
    stackView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(Metric.StackView.topBottom)
      $0.leading.equalToSuperview().inset(Metric.StackView.leading)
    }
    stackView.addArrangedSubview(cityLabel)
    stackView.addArrangedSubview(countryLabel)
  }
  
}
