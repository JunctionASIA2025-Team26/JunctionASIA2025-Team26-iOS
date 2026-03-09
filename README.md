<div>

# 🏆 Junction Asia 2025 Track Winner & Final Winner

## Upstage Track Winner & **Final Winner**

### TEAM NAME : `GO!`
### App Name : `SyncTank`
<img width="600" height="600" alt="MainPage" src="https://github.com/user-attachments/assets/205b85a4-b513-4d18-8f92-f8a393631a4d" />
</br>

### Track Winner PRIZE :  `₩ 2,000,000`
### Final Winne PRIZE : `₩ 3,000,000`

</div>

## 💁‍♂️ Team Members

| 고재현 | 유경모 | 차원준 | 한건희 |
|:---:|:---:|:---:|:---:|
| UI/UX Designer | iOS / Mac App Developer | iOS Developer | Backend Developer |
| [@Gojaehyeon](https://github.com/Gojaehyeon) | [**@YooGyeongMo**](https://github.com/YooGyeongMo) | [@chawj1234](https://github.com/chawj1234) | [@keon22han](https://github.com/keon22han) |

---

## SyncTank — iOS

<!-- 앱 아이콘 -->
<img width="200" height="200" alt="SyncTank" src="https://github.com/user-attachments/assets/dbd2a063-ddcf-44e9-b56d-187019e4c84a" />


> Upstage LLM 및 Document Parser 기반의 LLM-Powered Context-Aware Notification System으로, 스크린샷·문서의 핵심 정보를 자동 추출·추론하여 컨텍스트 인지형 알림을 생성하고, macOS-iOS 간 실시간 동기화를 통해 크로스 디바이스 리마인더를 제공하는 지능형 인사이트 대시보드 서비스입니다.

### 📄 LLM 기반 문서·스크린샷 자동 분석
`Upstage Document Parser`를 통해 이미지·문서의 텍스트와 레이아웃을 추출하고, `Upstage LLM Solar Pro2`가 컨텍스트를 추론하여 핵심 정보(일정, 마감, 중요 키워드 등)를 자동으로 식별합니다.

### 🔔 컨텍스트 인지형 스마트 알림
추출된 정보를 기반으로 **언제, 무엇을** 알려줘야 하는지 LLM이 자율적으로 판단하여 알림을 생성합니다. 단순 키워드 매칭이 아닌, 문맥을 이해한 추론 기반 알림 시스템입니다.

### 🔄 macOS ↔ iOS 크로스 디바이스 실시간 동기화
Mac에서 캡처한 인사이트가 iOS 디바이스로 실시간 동기화되어, 어디서든 리마인더를 받을 수 있습니다.

---

## Background & Problem Definition

> Upstage 트랙의 핵심 과제인 **LLM과 Document AI 기술을 활용한 실용적 서비스 개발**을 분석하며, 우리는 정보 과부하 시대에서 일상생활 속 **중요한 정보를 놓치는 문제**에 주목했습니다.

* **Pain Point**: 현대인은 매일 수십 개의 스크린샷, 문서, 메시지를 접하지만, 정작 중요한 마감일이나 약속을 놓치는 경우가 빈번합니다. 정보는 넘쳐나지만, 그 속에서 **지금 나에게 중요한 것**을 걸러내는 데 인지적 비용이 큽니다.

* **Core Insight**: 기존 리마인더 앱은 사용자가 **직접 입력**해야 하고, OCR 기반 도구는 텍스트만 추출할 뿐 **맥락을 이해하지 못합니다**. "다음 주 금요일까지 제출"이라는 문장에서 날짜와 중요도를 동시에 판단하려면 **LLM 수준의 추론**이 필요합니다.

* **Solution**: SyncTank는 Upstage Document Parser로 문서/스크린샷을 구조화하고, Upstage LLM (Solar Pro2) 으로 컨텍스트를 추론하여, 사용자가 아무것도 입력하지 않아도 **알아서 중요한 정보를 잡아내고 알려주는** 시스템을 구현했습니다. 또한 macOS-iOS 간 실시간 동기화로 디바이스 간 경계 없는 경험을 제공합니다.

## 기술 스택

| Category | Stack |
|----------|-------|
| **Platform** | iOS |
| **Language** | Swift 5.9 |
| **IDE** | Xcode 15.0 |
| **UI** | SwiftUI |
| **Architecture** | MVVM |
| **Networking** | URLSession + Codable (JSON) |
| **Design** | Figma |

---

## 시연 영상

[![SyncTank Demo](https://img.youtube.com/vi/tzN3OjnnENs/0.jpg)](https://www.youtube.com/watch?v=tzN3OjnnENs)

▶️ **시연 영상 보기**

<br/>

[![Junction Asia 2025 Live Demo](https://img.youtube.com/vi/TdIRpI2Og84/0.jpg)](https://www.youtube.com/watch?v=TdIRpI2Og84&t=18049s)

▶️ **Junction Asia 2025 실시간 발표 보기 4:52:00 참고**

---

## 동작 흐름

1. **캡처** — macOS에서 스크린샷 또는 문서를 캡처/업로드합니다.
2. **분석** — Upstage Document Parser가 텍스트와 레이아웃을 추출하고, LLM이 컨텍스트를 추론합니다.
3. **인사이트 생성** — 중요한 일정, 마감일, 키워드 등을 자동 식별하여 인사이트를 생성합니다.
4. **동기화** — 생성된 인사이트가 Backend를 통해 iOS 디바이스로 실시간 동기화됩니다.
5. **알림** — iOS 앱에서 컨텍스트 인지형 알림을 통해 사용자에게 실시간으로 알림합니다.

<table>
  <tr>
    <td align="center"><img width="1094" height="727" alt="MacApp" src="https://github.com/user-attachments/assets/191a7f75-b1a3-4bbb-8a5d-fb479c932365" /></td>
    <td align="center"><img width="250" alt="ios" src="https://github.com/user-attachments/assets/6fa08c54-8c7f-4e13-96bf-584fa574bf32" /></td>
    <td align="center"><img width="250" alt="ios2" src="https://github.com/user-attachments/assets/eaefcead-0e70-4f88-b0ff-1347cad5801d" /></td>
  </tr>
</table>

---

## License

Apache License 2.0
