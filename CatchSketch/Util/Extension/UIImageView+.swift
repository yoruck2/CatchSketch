//
//  UIImageView+.swift
//  CatchSketch
//
//  Created by dopamint on 8/30/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImageWithToken(urlString: String, placeholder: UIImage? = nil) {
        
        let urlString = APIAuth.catchSketchAPI.baseURL + "/v1/" + urlString
        guard let url = URL(string: urlString) else {
            return
        }
        
        let modifier = AnyModifier { request in
            var request = request
            request.setValue(APIAuth.catchSketchAPI.key, forHTTPHeaderField: Header.sesacKey.rawValue)
            request.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: Header.authorization.rawValue)
            return request
        }
        
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.requestModifier(modifier)]
        )
    }
}
