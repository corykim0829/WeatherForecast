//
//  SearchViewModel.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/11/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class SearchViewModel {
  
  let fetchCityListUseCase: FetchCityListUseCase
  
  var cities = BehaviorRelay<[City]>(value: [])
  private var parsedCities: [City] = []
  
  var searchKeyword = BehaviorRelay<String>(value: "")
  
  let disposeBag = DisposeBag()
  
  init(fetchCityListUseCase: FetchCityListUseCase = FetchCityListUseCase()) {
    self.fetchCityListUseCase = fetchCityListUseCase
    
    let cities = self.fetchCityListUseCase.fetchCityList()
    parsedCities = cities
    self.cities.accept(cities)
    
    searchKeyword
      .skip(1)
      .debounce(.milliseconds(700), scheduler: MainScheduler.instance)
      .bind { keyword in
        if keyword == "" {
          self.cities.accept(self.parsedCities)
        } else {
          let filteredCities = self.parsedCities.filter {
            $0.name.range(of: keyword, options: .caseInsensitive) != nil
          }
          self.cities.accept(filteredCities)
        }
      }
      .disposed(by: disposeBag)

  }
  
}
