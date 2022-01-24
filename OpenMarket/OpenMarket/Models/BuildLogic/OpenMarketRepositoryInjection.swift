//
//  OpenMarketRepositoryInjection.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

struct OpenMarketRepositoryInjection {

    private init() {}

    static func injectOpenMarketRepository() -> OpenMarketRepository {
        return OpenMarketRepositoryRemoteDataSourceImpl()
    }
}
