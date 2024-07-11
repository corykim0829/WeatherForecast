//
//  MainOtherDataItemView.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/11/24.
//

import UIKit
import SnapKit

final class MainOtherDataItemView: UIView {
  
  lazy var backgroundBlurView: UIVisualEffectView = {
    let effect = UIBlurEffect(style: .dark)
    let view = UIVisualEffectView(effect: effect)
    return view
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .regular)
    label.textColor = .white
    return label
  }()
  
  lazy var mainDataLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 30, weight: .semibold)
    label.textColor = .white
    return label
  }()
  
  lazy var subDataLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .regular)
    label.textColor = .white
    return label
  }()
  
  lazy var dataStackView: UIStackView = {
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
  
  func update(title: String, mainData: String, subData: String? = nil) {
    titleLabel.text = title
    mainDataLabel.text = mainData
    if let subData = subData {
      subDataLabel.isHidden = false
      subDataLabel.text = subData
    }
  }
  
}

extension MainOtherDataItemView {
  private func configure() {
    backgroundColor = .clear
    layer.cornerRadius = 12
    clipsToBounds = true
    layout()
  }
  
  private func layout() {
    addSubview(backgroundBlurView)
    backgroundBlurView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview().inset(12)
    }
    
    addSubview(dataStackView)
    dataStackView.snp.makeConstraints {
      $0.leading.bottom.equalToSuperview().inset(12)
    }
    
    dataStackView.addArrangedSubview(mainDataLabel)
    dataStackView.addArrangedSubview(subDataLabel)
    subDataLabel.isHidden = true
  }
  
}
