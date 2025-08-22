# 🎬 Flutter Movie Info App

TMDB API를 활용한 영화 정보 앱으로, 인기/최신/높은 평점 영화들을 확인하고 상세 정보를 볼 수 있는 Flutter 애플리케이션입니다.

## 주요 기능

### 1. 홈 화면
- **인기 영화** - TMDB 인기 순위 기반 영화 목록 (페이지네이션 지원)
- **최신 영화** - 최근 개봉한 영화들
- **높은 평점 영화** - 평점 순으로 정렬된 영화 목록
- **무한 스크롤** - 인기 영화에서 추가 로딩 지원

### 2. 상세 정보
- **영화 포스터** - 고화질 포스터 이미지와 Hero 애니메이션
- **기본 정보** - 제목, 개봉일, 러닝타임, 장르
- **줄거리** - 영화 개요 및 태그라인
- **AI 리뷰 요약** -영화 제목 기반 온라인 리뷰 종합 분석
- **박스오피스 정보** - 평점, 투표수, 인기도, 제작비, 수익
- **제작사 정보** - 제작사 로고 갤러리

### 3. 사용자 경험
- **다크 테마** - 영화 앱에 적합한 어두운 UI
- **부드러운 애니메이션** - Hero 애니메이션을 통한 자연스러운 화면 전환
- **에러 처리** - 네트워크 오류 시 대체 이미지 기능

## 아키텍처

### **Clean Architecture**

클린 아키텍처 원칙을 따라 의존성 방향이 내부로 향하도록 설계된 3층 구조입니다.

```
Presentation Layer (가장 바깥층)
    ├── Pages (HomePage, DetailPage)
    ├── Widgets (MovieList, MovieInfo 등)
    └── ViewModels (Riverpod StateNotifier)
    
Domain Layer (핵심 비즈니스 로직)
    ├── Entities (Movie, MovieDetail)
    ├── Repositories (인터페이스)
    └── Use Cases (비즈니스 규칙)
    
Data Layer (가장 안쪽층)
    ├── DataSources (API 통신)
    ├── Repositories Impl (구현체)
    └── DTOs (데이터 변환)
```

### **의존성 방향**
```
Presentation → Domain ← Data
```
- **Presentation Layer**: Domain Layer의 인터페이스에만 의존
- **Data Layer**: Domain Layer의 인터페이스를 구현
- **Domain Layer**: 어떤 층에도 의존하지 않음 (순수 비즈니스 로직)


### **상태 관리**
- **Riverpod** - Provider 패턴으로 전역 상태 관리
- **StateNotifier** - 복잡한 상태 로직 처리
- **AsyncValue** - 비동기 데이터 상태 (로딩/성공/에러) 관리

## 기술 스택

### **Frontend**
- **Flutter** 3.19+ - 크로스 플랫폼 UI 프레임워크
- **Dart** 3.3+ - 프로그래밍 언어

### **상태 관리 & 의존성 주입**
- **flutter_riverpod** ^2.6.1 - 상태 관리 및 DI

### **네트워킹 & 데이터**
- **http** ^1.5.0 - HTTP 클라이언트
- **flutter_dotenv** ^5.0.2 - 환경 변수 관리
- **google_generative_ai ^0.4.3** - Gemini AI API 연동

### **UI & 디자인**
- **Custom Theme** - 일관성 있는 디자인 시스템
- **Material Design** - 구글 디자인 가이드라인

### **외부 API**
- **TMDB API** - 영화 정보 및 이미지 제공
- **Gemini AI API** - 영화 리뷰 분석

## 프로젝트 구조

```
lib/
├── presentation/           # UI 레이어
│   ├── pages/                # 화면별 페이지
│   │   ├── home/            # 홈 화면
│   │   │   ├── home_page.dart
│   │   │   ├── home_page_view_model.dart
│   │   │   └── widgets/     # 홈 화면 위젯들
│   │   └── detail/          # 상세 화면
│   │       ├── detail_page.dart
│   │       ├── detail_page_view_model.dart
│   │       └── widgets/     # 상세 화면 위젯들
│   └── widgets/             # 공통 위젯
│
├── domain/                # 도메인 레이어 (핵심 비즈니스 로직)
│   ├── entity/              # 엔티티 (순수 비즈니스 객체)
│   │   ├── movie.dart
│   │   └── movie_detail.dart
│   ├── repository/          # 레포지토리 인터페이스
│   │   └── movie_repository.dart
│   └── use_case/            # 비즈니스 규칙 및 유즈케이스
│
├── data/                  # 데이터 레이어 (외부 데이터 소스)
│   ├── data_source/         # 데이터 소스 (API, DB 등)
│   │   ├── movie_data_source.dart
│   │   ├── movie_data_source_impl.dart
│   │   └── gemini_data_source.dart
│   ├── dto/                 # 데이터 전송 객체 (외부 API 응답)
│   │   ├── movie_dto.dart
│   │   └── movie_detail_dto.dart
│   └── repository/          # 레포지토리 구현체
│       └── movie_repository_impl.dart
│
├── theme/                 # 디자인 시스템
│   └── theme.dart
│
└── main.dart                # 앱 진입점
```

## 주요 기능 상세
### **AI 리뷰 분석**
- Gemini AI 연동 - 영화 제목 기반 온라인 리뷰 종합 분석
- 관점별 분석 - 스토리, 연출/영상, 연기/캐릭터 3가지 관점으로 분류

### **데이터 플로우**
1. **API 호출** - TMDB API에서 영화 데이터 요청
2. **DTO 변환** - JSON 응답을 DTO 객체로 변환
3. **Entity 매핑** - DTO를 도메인 Entity로 변환
4. **상태 관리** - Riverpod으로 UI 상태 업데이트
5. **UI 렌더링** - 상태 변화에 따른 화면 업데이트

### **성능 최적화**
- **페이지네이션** - 무한 스크롤로 필요한 데이터만 로딩
- **상태 최적화** - 불필요한 리빌드 방지

### **알려진 이슈**
- 앱 첫 실행 시 Hero 애니메이션이 첫 번째 클릭에서 작동하지 않는 경우가 있음
  - 두 번째 클릭부터는 정상 작동
  - Flutter Hero 시스템의 초기화 타이밍 이슈로 추정


## **프로젝트 진행 문서 자세히 보기**

- [프로젝트 문서](https://polariseunhee94.notion.site/2523216a4dd280439b24da27804889b4?source=copy_link) - 프로젝트 개발 순서 및 트러블 슈팅 작성
