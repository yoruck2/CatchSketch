# 🎨 CatchSketch
재치있는 넌센스 그림문제를 내고 맞출 수 있는 커뮤니티형 게임앱

>개발환경
![Static Badge](https://img.shields.io/badge/Xcode-15.4-blue) ![Static Badge](https://img.shields.io/badge/Swift-5.10-orange) ![Static Badge](https://img.shields.io/badge/iOS-16.0%2B-pink)
기간: 2024.09.10 ~ 2024.10.02 (약 4주)
인원: 1명
## 📷 ScreenShot


|메인피드|문제상세|문제내기|그림그리기|
|:-:|:-:|:-:|:-:|
|<img src="" width="150"/>|<img src="" width="150"/>|<img src="" width="150"/>|<img src="" width="150"/>|


## 📌 주요기능
- 그림문제 조회
    - 그림문제 좋아요
- 그림문제 맞추기(댓글 기능)
    - 그림문제 힌트주기 (작성자)
    - 그림문제 힌트보기 (도전자)
- 그림문제 올리기
    - 그림 그리기
- 문제를 맞출수록 오르는 레벨 시스템
- 힌트를 볼 수 있는 재화 시스템
- 프로필 조회하기 (예정)
    - 맞춘 문제 조회
    - 내가 낸 문제 조회
- 순위 조회 (예정)

## 🧰 기술스택
| 분야               | 기술 스택                                  |
|--------------------|-------------------------------------------|
| 🏛️ 아키텍쳐    | `MVVM`<br>`+ Input & Output 패턴`         |
| ♻️ 비동기 프레임워크   | `RxSwift`                                 |
| 📡 네트워킹          | `Alamofire`<br>`+ Router 패턴`            |
| 📦 데이터베이스       | `RealmSwift`<br>`+ Repository 패턴`        |
| ✏️   드로잉 | `PencilKit`
| 🎨 UI               | `UIKit`<br>`SnapKit`<br>`Kingfisher`
| 🎸 기타             | `Then`<br>`IQKeyboardManager`<br>`Toast`                      |

## 🛠️ 주요 기술 상세

- `MVVM` + `Inout` 패턴
View와 ViewModel 간의 결합도를 낮추고 코드의 가독성과 유지보수성을 향상
- `RxSwift`
    - 
- Networking
    - Alamofire의 URLRequestConvertible를 채택한 TargetType으로 라우터 추상화
    - TargetType을 채택한 라우터 패턴으로 구조적이고 유연한 라우터 구성
    - 제네릭을 사용한 네트워크 추상화 및 재사용성 향상
- PencilKit
    - PKCanvas를 통해 그림을 그리고, delgate 패턴과 RxSwift를 활용해 그림을 저장할 때 저장할 PKDrawing을 전달
    - PKDrawing.image 로 특정한 사이즈로 그림을 이미지로 저장
