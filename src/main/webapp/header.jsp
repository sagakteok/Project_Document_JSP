<%@ page contentType="text/html; charset=UTF-8" %>
<style>
    header {
        width: 100vw; /* 전체 너비 */
        height: 85px; /* 고정 높이 */
        background-color: #FFFFFF; /* 헤더 배경색 */
        border-bottom: 0.5px solid #EBEDF1; /* 하단 테두리 */
        position: sticky; /* 스크롤해도 상단에 고정 */
        top: 0;
        z-index: 3;
    }
    .search-bar {
        padding: 5px; /* 내부 여백 */
        margin-left: 40px;
        width: 360px; /* 고정된 너비 */
        height: 50px;
        box-sizing: border-box; /* 테두리와 여백 포함 */
        border-radius: 25px; /* 둥근 모서리 */
        background-color: #FAFAFA; /* 내부 배경색 */
        display: flex; /* 플렉스 정렬 */
        align-items: center; /* 세로 가운데 정렬 */
        position: relative; /* 자식 요소의 위치 기준 */
    }
    .search-bar input[type="text"] {
        border: none; /* 기본 테두리 제거 */
        outline: none; /* 포커스 테두리 제거 */
        background: none; /* 투명 배경 */
        flex-grow: 1; /* 입력 필드가 남은 공간 차지 */
        padding: 0 15px; /* 양쪽 여백 */
        font-size: 14px; /* 글씨 크기 */
        font-family: 'SpoqaHanSansNeo-Medium';
        color: #000000; /* 텍스트 색상 */
        height: calc(100% - 10px); /* 부모 높이에 맞춤 (패딩 보정) */
    }
    .search-bar input::placeholder {
        color: #C8C8C8; /* 플레이스홀더 텍스트 색상 */
        font-size: 14px; /* 글씨 크기 */
        font-family: 'SpoqaHanSansNeo-Medium';
    }
    .search-bar::before {
        content: "🔍"; /* 돋보기 아이콘 */
        font-size: 16px; /* 아이콘 크기 */
        color: #C8C8C8; /* 아이콘 색상 */
        margin-left: 15px; /* 왼쪽 여백 */
    }
    .search-bar:focus-within {
            outline: 2px solid #424242; /* 바깥쪽 테두리 */
        }
    .autocomplete-results {
        position: absolute; /* 부모(search-bar)를 기준으로 위치 */
        top: calc(100% + 5px); /* 검색창 바로 아래에 배치 (여백 5px) */
        width: 100%; /* 검색창 너비에 맞춤 */
        background-color: #FFFFFF; /* 배경색 흰색 */
        max-height: 200px; /* 최대 높이 설정 */
        overflow-y: auto; /* 스크롤 활성화 */
        box-shadow: 0px 4px 5px 3px #00000010; /* 그림자 효과 */
        z-index: 10; /* 다른 요소 위에 표시 */
        border-radius: 10px; /* 둥근 모서리 */
        opacity: 0;
    }
    .autocomplete-results.active {
        opacity: 1;
    }
    .autocomplete-item {
        padding: 10px;
        cursor: pointer;
    }
    .autocomplete-item:hover {
        background-color: #F8FAFF;
    }
</style>

<script>
    function performSearch() {
        const query = document.getElementById("search-input").value.trim();
        const autocompleteResults = document.getElementById("autocomplete-results");

        if (query === "") {
            autocompleteResults.innerHTML = ""; // 결과 초기화
            autocompleteResults.classList.remove("active"); // 비활성화
            return;
        }

        const xhr = new XMLHttpRequest();
        xhr.open("GET", "searchAjax.jsp?query=" + encodeURIComponent(query), true);
        xhr.onload = function () {
            if (xhr.status === 200) {
                autocompleteResults.innerHTML = xhr.responseText;
                if (xhr.responseText.trim() !== "") {
                    autocompleteResults.classList.add("active"); // 활성화
                } else {
                    autocompleteResults.classList.remove("active"); // 비활성화
                }
            }
        };
        xhr.send();
    }

    // 외부 클릭 시 autocomplete 숨기기
    document.addEventListener("click", function (event) {
        const searchBar = document.querySelector(".search-bar");
        const autocompleteResults = document.getElementById("autocomplete-results");

        if (!searchBar.contains(event.target)) {
            autocompleteResults.classList.remove("active");
        }
    });
    
    function redirectToMain() {
        window.location.href = "MainHome.jsp";
    }
</script>

<header>
    <div style="max-width: 2000px; height: 85px; display: flex; align-items: center; margin: auto; background-color: #FFFFFF">
        <!-- 로고 -->
        <img class="Document-logo" src="image/Documents.png" width="130px" style="margin-left: 40px; cursor: pointer;" onclick="redirectToMain()">
        <!-- 검색 폼 -->
        <div class="search-bar">
            <input type="text" id="search-input" onkeyup="performSearch()" placeholder="원하는 서류를 검색해보세요">
            <div id="autocomplete-results" class="autocomplete-results"></div>
        </div>
    </div>
</header>