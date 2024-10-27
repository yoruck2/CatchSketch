//
//  Date+.swift
//  CatchSketch
//
//  Created by dopamint on 9/1/24.
//

import Foundation

extension String {
    static var formatter = ISO8601DateFormatter()
    func toRelativeTimeString() -> String {
        
        String.formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = String.formatter.date(from: self) else {
            return self // 파싱 실패 시 원본 문자열 반환
        }
        
        let relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.unitsStyle = .full
        relativeFormatter.locale = Locale(identifier: "ko_KR")
        
        let now = Date()
        let difference = Calendar.current.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = difference.day, day > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            return dateFormatter.string(from: date)
        } else if let hour = difference.hour, hour > 0 {
            return relativeFormatter.localizedString(for: date, relativeTo: now)
        } else if let minute = difference.minute, minute > 0 {
            return relativeFormatter.localizedString(for: date, relativeTo: now)
        } else {
            return "방금 전"
        }
    }
    
    func toDate() -> Date {
        String.formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        if let date = String.formatter.date(from: self) {
            return date
        }
        return Date()
    }
}
