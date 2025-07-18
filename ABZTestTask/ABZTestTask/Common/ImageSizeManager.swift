//
//  ImageResize.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 18.06.2025.
//

import Foundation
import UIKit

enum SizeConstants {
    static let kb: Float = 1024
    static let mb: Float = 1024 * 1024
}

protocol ImageSizeManagerProtocol {
    associatedtype DimentionSizeType: RawRepresentable
    associatedtype MemorySizeType: RawRepresentable
    func isValidImageSize(_ image: UIImage, targetSize: Float) -> Bool
    func resizeImage(image: UIImage, to size: DimentionSizeType) -> UIImage
    func compressImage(image: UIImage, to size: MemorySizeType) -> Data?
}

struct ImageSizeManager {
    enum DomentionSize {
        case small(size: CGSize), original
    }
    
    enum MemorySize {
        case small(size: Float), original
    }
    
    typealias DimentionSizeType = DomentionSize
    typealias MemorySizeType = MemorySize
    private let additionParamsSize: Float = 0.05
    
    func resizeImage(image: UIImage, to size: DimentionSizeType) -> UIImage {
        switch size {
        case .small(let size):
            return resizeImage(targetSize: size, image: image)
        case .original:
            return image
        }
    }
    
    func crop(image: UIImage, to rect: CGRect) -> UIImage? {
        let scaledRect = CGRectMake(rect.origin.x * image.scale,
                                    rect.origin.y * image.scale,
                                    rect.size.width * image.scale,
                                    rect.size.height * image.scale);
        guard let cgImage = image.cgImage,
              let imageRef = cgImage.cropping(to: scaledRect)
        else { return nil }
        
        let result = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        return result
    }
    
    func isValidImageSize(_ image: UIImage, targetSize: Float) -> Bool {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return false
        }
        return Float(imageData.count) < targetSize * SizeConstants.mb
    }
    
    
    func compressImage(image: UIImage, to size: MemorySizeType) -> Data? {
        var data: Data?
        switch size {
        case .small(let val):
            data = compress(image, to: val)
        case .original:
            data = image.jpegData(compressionQuality: 1.0)
        }
        
        return data
    }
    
    private func compress(_ image: UIImage, to size: Float) -> Data? {
        if let data = image.jpegData(compressionQuality: 1.0) {
            let minSize = SizeConstants.mb * size
            if Float(data.count) > minSize {
                let compression = Float(minSize / Float(data.count)) - additionParamsSize
                let compressedData = image.jpegData(compressionQuality: CGFloat(compression))
                return compressedData
            }
            return data
        }
        return nil
    }
    
    private func resizeImage(targetSize: CGSize = CGSize(width: 400, height: 400),
                             image: UIImage) -> UIImage
    {
        let imgSize = image.size
        let widthRatio = targetSize.width / imgSize.width
        let heightRatio = targetSize.height / imgSize.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: imgSize.width * heightRatio,
                             height: imgSize.height * heightRatio)
        } else {
            newSize = CGSize(width: imgSize.width * widthRatio,
                             height: imgSize.height * widthRatio)
        }
        
        let renderFormat = UIGraphicsImageRendererFormat.default()
        let renderer = UIGraphicsImageRenderer(size: newSize, format: renderFormat)
        let resut = renderer.image { _ in
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        }
        
        return resut
    }
}
