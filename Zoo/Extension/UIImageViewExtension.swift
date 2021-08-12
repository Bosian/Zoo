//
//  UIImageViewExtension.swift
//  Zoo
//
//  Created by 劉柏賢 on 2021/8/11.
//

import UIKit
import Kingfisher

extension UIImageView {

    @discardableResult
    public func setImage(with urlString: String?,
                         placeholder: KFCrossPlatformImage? = nil,
                         options: KingfisherOptionsInfo = [.transition(.fade(0.3))],
                         progressBlock: DownloadProgressBlock? = nil,
                         completionHandler: ((Result<Kingfisher.RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {

        let completion: ((Result<Kingfisher.RetrieveImageResult, KingfisherError>) -> Void)?

#if DEBUG

        let start = Date()
//        print("\(start) [Kingfisher] Start: \(urlString ?? "")")

        // Comment out forceRefresh for no cache debugging
//            let options = options + [.forceRefresh]

        completion = { result in

            let end = Date()
            let duration = end.timeIntervalSince(start)
            let imageSize: CGSize

            switch result {
            case .success(let data):
                imageSize = data.image.size

            default:
                imageSize = .zero
            }
            print("Download image end, \(end) [Kingfisher][\(String(format: "%.3f", duration))][\(imageSize)] : \(urlString ?? "")")

            completionHandler?(result)
        }

#else

        completion = completionHandler

#endif
        
        return self.kf.setImage(with: urlString?.url,
                                placeholder: placeholder,
                                options: options,
                                progressBlock: progressBlock,
                                completionHandler: completion)
    }
}
