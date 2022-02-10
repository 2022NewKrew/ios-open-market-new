//
//  Constant.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/26.
//

import Foundation

typealias ListConstants = OpenMarketProductListConstants
typealias ManagingConstants = OpenMarektProductManagigConstants
typealias DetailConstnts = OpenMarketProductDetailConstants

enum OpenMarketProductListConstants {
    static let openMarketProcutListCellNibFileName = "OpenMarketProductListCell"
    static let openMarketProductListCellReuseIdentifier = "OpenMarketProductListCell"
    static let openMarketProductGridCellNibFileName = "OpenMarketProductGirdCell"
    static let openMarketProductGridCellReuseIdentifier = "OpenMarketProductGridCell"
    static let openMarketProcutFooterViewFileName = "LoadingFooterView"
    static let openMarketProductFooterViewIdentifier = "LoadingReusableView"
    static let loadingImageName = "loading"
    static let loadingFooterViewHeight = 55.0
    static let itemsPerPage = 20
    static let openMarketPrdouctCellLeadingTrailingInset = 16.0
    static let openMarketPrdouctCellTopBottomInset = 8.0
    static let openMarketProductGridCellMinimumInterItemSpacing = 8.0
    static let openMarketProductGridCellMinimumInterLineSpacing = 8.0
    static let unknwon = "Unknown"
}

enum OpenMarektProductManagigConstants {
    static let productRegisterationTitle = "상품 등록"
    static let productModificationTitle = "상품 수정"
    static let productDescriptionTextViewPlaceholder = "상품에 대한 설명을 작성해주세요."
    static let emptyImageAlertTitle = "이미지를 추가해 주세요."
    static let emptyImageAlertMessage = "상단의 + 버튼을 눌러\n이미지를 추가해 주세요."
    static let okActionTitle = "확인"
    static let updateActionTitle = "수정"
    static let deleteActionTitle = "삭제"
    static let cancelActionTitle = "취소"
    static let fullImageAlertTitle = "더이상 이미지를 추가할 수 없습니다."
    static let manageButtonSystemImageName = "square.and.arrow.up"
    static let modifySegueIdentifier = "modify"
    static let createNewProductNotificationName = "createNewProduct"
    static let updateNewProductNotificationName = "updateNewProduct"
    static let didUpdateProduct = "didUpdateProduct"
}

enum OpenMarketProductDetailConstants {
    static let detailSegueIdentifier = "detail"
}
