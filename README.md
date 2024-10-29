# 🎨 CatchSketch
재치있는 넌센스 그림문제를 내고 맞출 수 있는 커뮤니티형 게임앱

>개발환경<br><br>
![Static Badge](https://img.shields.io/badge/Xcode-15.4-blue) ![Static Badge](https://img.shields.io/badge/Swift-5.10-orange) ![Static Badge](https://img.shields.io/badge/iOS-16.0%2B-pink)
><br>
기간: 2024.09.10 ~ 2024.10.02 (약 4주)
><br>
인원: 1명
## 📷 ScreenShot

|로그인 및 회원가입|메인피드|문제상세|문제내기|그림그리기|
|:-:|:-:|:-:|:-:|:-:|
|<img src="https://github.com/user-attachments/assets/d956565f-e368-4017-b8ee-24c913532ef1" width="150"/>|<img src="https://github.com/user-attachments/assets/43e7abcf-cb20-4657-a009-e51ec2906937" width="150"/>|<img src="https://github.com/user-attachments/assets/78e0cbd0-4084-47f6-af34-d16bbcdad597" width="150"/>|<img src="https://github.com/user-attachments/assets/97af9c7e-d36d-4ac4-9fd4-dcc59c56e1b4" width="150"/>|<img src="https://github.com/user-attachments/assets/17525d3d-2109-4d53-b0d2-a05b812c022c" width="150"/>|


## 📌 주요기능
- **로그인 및 회원가입**: 앱을 사용하기 위해 새 계정을 만들고, 로그인 할 수 있습니다.
- **그림문제 조회**: 나와 다른사람들이 낸 문제를 조회할 수 있습니다.
- **그림문제 맞추기**: 게시글에 댓글로 정답을 제시할 수 있습니다. 문제가 어렵다면 코인을 소모해서 힌트를 볼 수 있습니다. 문제 작성자는 정답을 공개하거나 문제를 지울 수 있습니다.
- **그림문제 올리기**: 그림을 직접 그리고 문제를 게시할 수 있습니다.
- **레벨 & 재화 시스템**: 문제를 맞출 수록 경험치에 따른 레벨이 증가하고, 힌트를 보기 위해 '코인'을 소모할 수 있습니다
- **프로필 조회하기** (예정): 다른 사람들의 프로필을 조회하고 나의 프로필을 수정할 수 있습니다. 프로필에는 맞춘 문제와 사용자가 낸 문제를 한눈에 조회할 수 있습니다.
- **순위 조회** (예정): 문제를 많이 맞춘 사람들의 랭킹을 확인할 수 있습니다.

## 🧰 기술스택
| 분야               | 기술 스택                                  |
|--------------------|-------------------------------------------|
| 🏛️ 아키텍쳐    | `MVVM`<br>`+ Input & Output 패턴`         |
| ♻️ 반응형 프로그래밍    | `RxSwift`                                 |
| 📡 네트워킹          | `Alamofire`<br>`+ Router 패턴`            |
| 📦 데이터베이스       | `RealmSwift`<br>`+ Repository 패턴`        |
| ✏️   드로잉 | `PencilKit`
| 🎨 UI               | `UIKit`<br>`SnapKit`<br>`Kingfisher`
| 🎸 기타             | `Then`<br>`IQKeyboardManager`<br>`Toast`   |

## 🛠️ 주요 기술 상세

- `RxSwift` +`MVVM` + `Inout` 패턴
    - Observable과 Subject를 활용한 반응형 프로그래밍으로 UI업데이트를 자동화 및 데이터 상태 관리 구현
    - View와 ViewModel 간의 결합도를 낮추고 코드의 가독성과 유지보수성을 향상
- `Networking`
    - Alamofire의 URLRequestConvertible를 채택한 TargetType으로 라우터 추상화
    - TargetType을 채택한 라우터 패턴으로 구조적이고 유연한 네트워크 계층 구성
    - 제네릭을 사용한 네트워크 추상화 및 재사용성 향상
- `PencilKit`
    - PKCanvas를 통한 드로잉 구현, delegate 패턴과 RxSwift를 활용해 PKDrawing 데이터 전달
    - PKDrawing.image 로 특정한 사이즈로 그림을 이미지로 저장
