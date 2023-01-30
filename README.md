# RestApi-Study

## Targets
- REST API 네트워크 이해
- 클로져, 리엑티브 등 비동기 프로그래밍 이해
- 클로져, RX, 콤바인 API 요청 차이 및 이해
- Alamofire 사용 이해 

## Background Information

#### Web/ App Service
- 웹 서버: 데이터베이스(DB)에 있는 데이터(자료) 처리 ex) Rest API 서버
- 클라이언트: 웹 프론트(리액트 등), 앱(iOS, Android) 
- ex) 내일 날씨는?? (요청) -> 서버: 날씨중에 내일 날씨를 찾아서 알려줌(응답)
- https://ko.wikipedia.org/wiki/API
- 서비스 운영: 백오피스, 관리자페이지
- 모든 서비스는 데이터의 나열이기 때문에 DB에서 CRUD해서 가져오는 것이 중요
-- Create: 데이터 추가 (Post)
-- Read: 데이터 조회 (Get)
-- Update: 데이터 수정 (Put, Patch, Post)
-- Delete: 데이터 삭제 (Delete)
