# RestApi-Study



## Targets

1. REST API 네트워크 이해

2. 클로져, 리엑티브 등 비동기 프로그래밍 이해

3. 클로져, RX, 콤바인 API 요청 차이 및 이해

4. Alamofire 사용 이해 

## Background Information

#### Web/ App Service

`웹 서버`: 데이터베이스(DB)에 있는 데이터(자료) 처리 ex) Rest API 서버

`클라이언트`: 웹 프론트(리액트 등), 앱(iOS, Android) 

ex) 내일 날씨는?? (요청) -> 서버: 날씨중에 내일 날씨를 찾아서 알려줌(응답)

https://ko.wikipedia.org/wiki/API

`서비스 운영`: 백오피스, 관리자페이지, 모든 서비스는 데이터의 나열이기 때문에 DB에서 CRUD해서 가져오는 것이 중요

`HTTP Method`: `1. Create- 추가(Post)` `2. Read- 조회(Get)` `3. Update- 수정(Patch, Post)` `4. Delete- 삭제 (Delete)`

일반적인 방식
- Get - todos:list 할일 전체조회: [ www.example.com/api/todos:list ]
- Get - todos:list/{id}: 할일 단일조회: [ www.example.com/api/todos:list/01 ]
- Post - todos:post 할일 추가: [ www.example.com/api/todos:add/ ]
- Put, Patch - todos:post/{id}: 할일 수정: [ www.example.com/api/todos:add/01 ]
- Delete - todos:delete: 할일 삭제 : [ www.example.com/api/todos:delete/01 ]


기타 유용한 API 관련 서비스
- 간단한 API체크: 크롬 익스텐션 YARC

더미 API 사이트 모음
- https://www.dummyjson.com
- https://www.dummyapi.com
- https://randomuser.me/documentation

Curl: Command Line URL 
- HTTP 메소드 방식(GET, POST, PUT, PATCH, DELETE...)
- -H: 헤더 키: 값으로 이루어짐
- -F: FormData: 키: 값
- -d: 데이터
```
input -> below text into terminal
curl -X `GET` \
'https://api.odcloud.kr/api/15043890/v1/uddi:9840de90-5907-49bd-94ed-acd173ea9ae1?serviceKey=2ZcQqYLFgYL874KsymG6ArBdRsfToKYUt1v4HSQ%2FVlNsHos8zhdw9ekygVhyPW7gxQq5NXjyoIu4KKqe2vkl0w%3D%3D&page=1&perPage=1'
-H 'accept: application/json' \
-H 'X-CSRF-TOKEN: '

output -> 
{"currentCount":1,"data":[{"기종":"A21N","도착공항":"TAE","도착시간":"09:00","시작일자":"2022-03-28","운항요일":"월화수목금토일","종료일자":"2022-10-29","출발공항":"CJU","출발시간":"07:55","편명":"OZ8120","항공사":"AAR"}],"matchCount":1110,"page":1,"perPage":1,"totalCount":1110}
```

#### URL Session
Refernce link: https://github.com/alexpaul/UIKit/blob/main/URLSession-Cheatsheet.md

- Asynchronous network request 의 결과를 가져오기 
`Result`타입은 `success`와 `failure`을 가지고있는 `enum` 타입으로 정의

```swift 
func fetchWebData(completion: @escaping (Result<[ModelObject], Error>) -> ()) {
 // networking code here
}
```
- Get request를 사용하여 URLSession을 가져오기 
`URLSession.shared`는 URLSession에서 기본적인 네트워크를 구성하는 `singleton`(객채의 인스턴스가 오직 1개만 생성되는)패턴

```swift 
let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
  // networking code here
}
dataTask.resume()
```

- `HTTPURLResponse` 상태 코드가 유효한 범주내에 있는지 확인하기 
```swift 
guard let httpResponse = response as? HTTPURLResponse,
      (200...299).contains(httpResponse.statusCode) else {
  print("bad status code")
  return
}
```

- JSON 데이터를 JSONDecoder를 사용해서 변환하기
```swift 
do {
  let topLevelModel = try JSONDecoder().decode(TopLevelModel.self, from: jsonData)
  let modelObjects = topLevelModel.modelObjects
  completion(.success(modelObjects)
} catch {
  // decoding error
  completion(.failure(error))
}
```

- Codable 프로토콜을 사용해서 JSON을 모델로 파싱하기 

여기서 Codable이란 Decodable(Json에서 디코딩)과 Encodable(Json으로 인코딩)프로토콜을 준수하는 타입(프로토콜)이다.

```swift 
struct CovidCountriesWrapper: Codable {
  let countries: [CountrySummary]
  
  // CodingKeys allows us to rename properties
  enum CodingKeys: String, CodingKey {
    case countries = "Countries"
  }
}

struct CountrySummary: Codable {
  let country: String
  let totalConfirmed: Int
  let totalRecovered: Int
  
  enum CodingKeys: String, CodingKey {
    case country = "Country"
    case totalConfirmed = "TotalConfirmed"
    case totalRecovered = "TotalRecovered"
  }
}
```

-  `enum`에 명시된 `CodingKeys`로 JSON property name과 own name을 매칭하기 
아래 예는 Contries를 일반적인 swift 이름으로 변환하는 코드이다.

```swift 
struct CovidCountriesWrapper: Codable {
  let countries: [CountrySummary]
  
  // CodingKeys allows us to rename properties
  enum CodingKeys: String, CodingKey {
    case countries = "Countries"
  }
}
```

- 웹 데이터를 가져오기 위한 API Client 구성하기 

```swift 
 func fetchWebData(completion: @escaping (Result<[ModelObject], Error>) -> ()) {
    // 1. - endpoint URL string
    let endpointURLString = "https://........"
    
    // 2. - convert the string to an URL
    guard let url = URL(string: endpointURLString) else {
      print("bad url")
      return
    }
    
    // URL vs URLRequest
    
    // 3. - make the request using URLSession
    // .shared is an singleton instance on URLSession comes with basic configuration needed for most requests
    let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        return completion(.failure(error))
      }
      
      // first we have to type cast URLResponse to HTTPURLRepsonse to get access to the status code
      // we verify the that status code is in the 200 range which signals all went well with the GET request
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        print("bad status code")
        return
      }
      
      if let jsonData = data {
        // convert data to our swift model
        do {
          let topLevelModel = try JSONDecoder().decode(TopLevelModel.self, from: jsonData)
          let modelObjects = topLevelModel.modelObjects
          completion(.success(modelObjects))
        } catch {
          // decoding error
          completion(.failure(error))
        }
      }
    }
    dataTask.resume()
  }
```

#### Alamofire 
