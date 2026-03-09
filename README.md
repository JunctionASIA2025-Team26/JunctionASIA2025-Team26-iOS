<div align="center">

# 🏆 Junction Asia 2025 Upstage Track Winner & Final Winner

## Upstage Track Winner & **Final Winner**

### TEAM NAME : `Team26`

### PRIZE : `Upstage Track Winner 2,000,000`, `Final Winner 3,000,000`

</div>

## 💁‍♂️ Team Members

| 고재현 | 유경모 | 차원준 | 한건희 |
|:---:|:---:|:---:|:---:|
| UI/UX Designer | iOS / Mac App Developer | iOS Developer | Backend Developer |
| [@Gojaehyeon](https://github.com/Gojaehyeon) | [**@YooGyeongMo**](https://github.com/YooGyeongMo) | [@chawj1234](https://github.com/chawj1234) | [@keon22han](https://github.com/keon22han) |

---

## SyncTank — iOS

<!-- 앱 아이콘 -->
<!-- <img src="appicon.png" width="200"/> -->

> **한 줄 소개를 여기에 작성하세요**

### 핵심 기능 1 제목
설명을 여기에 작성하세요.

### 핵심 기능 2 제목
설명을 여기에 작성하세요.

### 핵심 기능 3 제목
설명을 여기에 작성하세요.

---

## Background & Problem Definition

<!--
- Upstage 트랙의 핵심 과제를 분석하며 어디에 주목했는지
- Pain Point: 기존에 어떤 문제가 있었는지
- The Gap: 왜 기존 방식으로는 부족했는지
- 그래서 SyncTank를 기획한 이유
-->

-
-
-

---

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

## 아키텍처

```
┌─────────────────────────────────────────────┐
│                   View                      │
│         ContentView / Subviews              │
│              SkeletonCard                   │
└──────────────────┬──────────────────────────┘
                   │ @StateObject / @ObservedObject
┌──────────────────▼──────────────────────────┐
│               ViewModel                     │
│          InsightViewModel.swift              │
│     (상태 관리 + 비즈니스 로직)                │
└──────────────────┬──────────────────────────┘
                   │ async/await
┌──────────────────▼──────────────────────────┐
│            Network Layer                    │
│  APIService.swift ──→ Endpoints.swift       │
│       ↓                                     │
│  DashItemRequest (Request DTO)              │
│  Errors/ (커스텀 에러 처리)                   │
└──────────────────┬──────────────────────────┘
                   │ HTTP (JSON)
┌──────────────────▼──────────────────────────┐
│              Backend API                    │
└─────────────────────────────────────────────┘
```

---

## 📂 Project Structure

```
SyncTank-iOS/
├── App/                          # App 진입점
├── DesignSystem/
│   └── Colors.xcassets/          # 컬러 에셋
├── Feature/
│   ├── Enum/                     # 열거형 정의
│   ├── Extensions/               # Swift Extension
│   ├── Models/
│   │   └── PlanModels.swift      # 도메인 모델
│   ├── SkeletonCard/             # 로딩 스켈레톤 UI
│   ├── Subviews/                 # 재사용 뷰 컴포넌트
│   └── ViewModel/
│       └── InsightViewModel.swift
├── Network/
│   ├── Errors/                   # 커스텀 에러 타입
│   ├── Models/
│   │   └── DashItemRequest.swift # Request DTO
│   ├── APIService.swift          # API 호출 서비스
│   └── Endpoints.swift           # 엔드포인트 정의
├── ContentView.swift
└── SyncTank_iOSApp.swift
```

---

## 🔄 데이터 흐름 (Data Flow)

SyncTank iOS는 BE 서버와 `REST API (JSON)` 기반으로 통신합니다.

### Request 흐름 (클라이언트 → 서버)

```
View (사용자 액션)
  └→ InsightViewModel
       └→ APIService.swift
            └→ Endpoints.swift → URL + HTTPMethod 조합
                 └→ DashItemRequest (Swift struct)
                      └→ JSONEncoder().encode() → JSON Data
                           └→ URLRequest.httpBody에 할당
                                └→ URLSession으로 BE API 호출
```

### Response 흐름 (서버 → 클라이언트)

```
BE 응답 (JSON Data)
  └→ URLSession.data(for: request)
       └→ JSONDecoder().decode() → Swift struct로 역직렬화
            └→ InsightViewModel @Published 프로퍼티 업데이트
                 └→ SwiftUI View 자동 리렌더링
```

### DTO ↔ 도메인 모델 분리

```
┌──────────────┐      ┌──────────────┐      ┌──────────────┐
│   Network    │      │   Mapping    │      │   Feature    │
│              │      │              │      │              │
│ DashItem     │ ──→  │   변환 로직   │ ──→  │ PlanModels   │
│ Request.swift│      │              │      │ .swift       │
│ (DTO)        │      │              │      │ (Domain)     │
└──────────────┘      └──────────────┘      └──────────────┘
```

- **DTO (Data Transfer Object)**: BE API와 직접 통신하는 데이터 구조 (`Network/Models/`)
- **Domain Model**: 앱 내부에서 사용하는 비즈니스 모델 (`Feature/Models/`)
- 두 레이어를 분리하여 BE 스펙 변경 시 DTO만 수정하면 됨

---

## 🔧 직렬화 (Serialization)

Swift의 `Codable` 프로토콜을 활용하여 JSON 직렬화/역직렬화를 처리합니다.

### 직렬화 (Swift → JSON)

```swift
// Request DTO 정의
struct DashItemRequest: Codable {
    let title: String
    let content: String
    // ...
}

// 직렬화
let request = DashItemRequest(title: "...", content: "...")
let jsonData = try JSONEncoder().encode(request)
```

### 역직렬화 (JSON → Swift)

```swift
// 서버 응답을 Swift 객체로 변환
let decoded = try JSONDecoder().decode(ResponseType.self, from: data)
```

### 직렬화 이슈 & 해결

| 이슈 | 해결 방법 |
|------|----------|
| **Snake_case ↔ camelCase** | `JSONDecoder().keyDecodingStrategy = .convertFromSnakeCase` |
| **날짜 포맷 불일치** | `JSONDecoder().dateDecodingStrategy = .iso8601` |
| **Optional 필드** | DTO 프로퍼티를 `Optional`로 선언 |
| **키 이름 매핑** | `CodingKeys` enum으로 커스텀 매핑 |

---

## 시연 영상

<!-- mp4 파일 추가 -->
<!-- SyncTank.mp4 -->

---

## 동작 흐름

1. **단계 1** — 설명
2. **단계 2** — 설명
3. **단계 3** — 설명
4. **단계 4** — 설명

---

## License

Apache License 2.0