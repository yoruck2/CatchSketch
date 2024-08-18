//
//  Phrase.swift
//  CatchSketch
//
//  Created by dopamint on 7/22/24.
//

import Foundation


extension CatchSketch {
    enum Phrase {

        
        enum Alert {
            static let withdrawalTitle = "회원탈퇴"
            static let withdrawalMessage = "저장된 모든 정보가 사라집니다..😭\n탈퇴 하시겠습니까?"
        }
        enum NicknameGuide {
            static let validNickname = "사용할 수 있는 닉네임이에요"
            static let invalidCount = "2글자 이상 10글자 미만으로 설정 해주세요"
            static let containedSpecialCharacter = "닉네임에 @, #, $, % 는 포함할 수 없어요"
            static let containedNumber = "닉네임에 숫자는 포함할 수 없어요"
        }
    }
}
