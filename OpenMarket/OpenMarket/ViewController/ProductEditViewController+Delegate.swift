//
//  ProductEditViewController+Delegate.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/10.
//

import UIKit

extension ProductEditViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mode?.imageCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == images.count && images.count < 5, let _ = mode as? AddMode {
            let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "LastImageCell", for: indexPath)
            return cell
        } else {
            let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as! ProductImageCell
            cell.setImage(images[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mode?.didSelectItem(index: indexPath.row)
    }
}

extension ProductEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let newImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
              let selectedImageIdx = selectedImageIdx
            else {
                picker.dismiss(animated: true, completion: nil)
                return
            }
        if images.count > selectedImageIdx {
            images[selectedImageIdx] = newImage
        } else {
            images.append(newImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProductEditViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: view)
        return !imageCollectionView.frame.contains(touchPoint)
    }
}
