<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta name = "viewport" content="width=device-width", initial-scale="1"> 
    <meta charset="UTF-8">
    <title>서류봉투: 증명서 알려주는 앱</title>
    <style>
        @media (min-width: 0px){
	        body {
	            background: url('image/Banner1Background.png') no-repeat center;
	            background-size: cover;
	            width: 100vw;
	            height: 100vh;
	            margin: 0;
	            padding: 0;
	            display: flex;
	            flex-direction: column;
	            align-items: center;
	        }
	        main {
	            width: 100%;
	            max-width: 2000px;
	            box-sizing: border-box;
	            margin: auto;
	        }
	        .container {
	        	position: relative;
			}
			.left-category-content {
				opacity: 0; /* 초기 상태 */
	            transform: translateX(-50px); /* 왼쪽으로 이동된 상태 */
	            animation: slideInLeft 0.8s ease-out forwards; /* 애니메이션 */
	            animation-delay: 1s;
			}
	        .maintitle-animation {
	        	opacity: 0; /* 초기 상태 */
	            transform: translateX(-50px); /* 왼쪽으로 이동된 상태 */
	            animation: slideInLeft 0.8s ease-out forwards; /* 애니메이션 */
	            animation-delay: 0s;
	        }
	        .subtitle-animation {
	        	opacity: 0; /* 초기 상태 */
	            transform: translateX(-50px); /* 왼쪽으로 이동된 상태 */
	            animation: slideInLeft 0.8s ease-out forwards; /* 애니메이션 */
	            animation-delay: 0.1s;
	        }
	        .category-item:hover {
	            transform: translateY(-5px); /* 살짝 위로 올라가는 효과 */
	            color: #00A4FF;
	            box-shadow: 0px 0px 10px 5px #00000005;
	        }
	        .right-content {
	        	position: absolute;
	        	right: 0%;
	        	top: 0%;
	        	bottom: 0%;
	        	z-index: 1;
	        	display: flex; 
	        	align-items: center;
	        	opacity: 0; /* 초기 상태 */
	        	transform: translateX(50px); /* 오른쪽으로 이동된 상태 */
	            animation: slideInRight 0.8s ease-out forwards; /* 애니메이션 */
	            animation-delay: 0.3s;
	        }
	        @keyframes slideInLeft {
	            0% {
	                opacity: 0;
	                transform: translateX(-50px);
	            }
	            100% {
	                opacity: 1;
	                transform: translateX(0);
	            }
	        }
	        /* 오른쪽 컨텐츠 트랜지션 */
	        @keyframes slideInRight {
	            0% {
	                opacity: 0;
	                transform: translateX(50px);
	            }
	            100% {
	                opacity: 1;
	                transform: translateX(0);
	            }
	        }
        	.left-content {
				position: relative;
				left: 0%;
				top: 0%;
				bottom: 0%;
				z-index: 2;
				margin-left: 60px;
			}
			.maintitle {
	        	font-family: SpoqaHanSansNeo-thin; 
	        	font-size: clamp(34px, 3.8vw, 41px); 
	        	color: #2155D6; 
	        	text-align: left;
	        }
	        .subtitle {
	        	font-family: SpoqaHanSansNeo-bold; 
	        	font-size: clamp(38px, 4.4vw, 49px); 
	        	color: #000000; 
	        	text-align: left;
	        }
			.category-title {
				font-family: SpoqaHanSansNeo-medium; 
				font-size: 15px; 
				color: #424242; 
				text-align: left;
			}
			.category-grid {
	            margin-top: 15px;
	            display: grid;
	            grid-template-columns: repeat(3, 135px); /* 열 3개 */
	            gap: 15px; /* 버튼 간격 */
	        }
	        .category-item {
	            width: 135px;
	            height: 75px;
	            display: flex;
	            flex-direction: column;
	            align-items: center;
	            justify-content: center;
	            background-color: #FFFFFF;
	            border-radius: 15px;
	            box-shadow: 0px 0px 5px 3px #00000001;
	            text-align: center;
	            font-family: SpoqaHanSansNeo-Bold;
	            font-size: 15px;
	            color: #4B7BF2;
	            text-decoration: none;
	            transition: transform 0.2s, color 0.2s, box-shadow 0.2s;
	        }
	        .right-content img {
	            width: clamp(200px, 45vw, 300px); /* 이미지 크기 조정 */
	            margin-right: 60px;
	            opacity: 0.7;
	        }
        }
        @media (min-width: 1000px){
        
        	.left-content {
				position: relative;
				left: 0%;
				top: 0%;
				bottom: 0%;
				z-index: 2;
				margin-left: 90px;
			}
			.maintitle {
	        	font-family: SpoqaHanSansNeo-thin; 
	        	font-size: clamp(45px, 3vw, 55px); 
	        	color: #2155D6; 
	        	text-align: left;
	        }
	        .subtitle {
	        	font-family: SpoqaHanSansNeo-bold; 
	        	font-size: clamp(50px, 3.5vw, 65px); 
	        	color: #000000; 
	        	text-align: left;
	        }
			.category-title {
				font-family: SpoqaHanSansNeo-medium; 
				font-size: 20px; 
				color: #424242; 
				text-align: left;
			}
			.category-grid {
	            margin-top: 20px;
	            display: grid;
	            grid-template-columns: repeat(3, 180px); /* 열 3개 */
	            gap: 20px; /* 버튼 간격 */
	        }
	        .category-item {
	            width: 180px;
	            height: 100px;
	            display: flex;
	            flex-direction: column;
	            align-items: center;
	            justify-content: center;
	            background-color: #FFFFFF;
	            border-radius: 20px;
	            box-shadow: 0px 0px 5px 3px #00000001;
	            text-align: center;
	            font-family: SpoqaHanSansNeo-Bold;
	            font-size: 20px;
	            color: #4B7BF2;
	            text-decoration: none;
	            transition: transform 0.2s, box-shadow 0.2s;
	        }
	        .right-content img {
	            width: clamp(400px, 30vw, 600px); /* 이미지 크기 조정 */
	            margin-right: 90px;
	            opacity: 0.7;
	        }
        }
    </style>
</head>
<body>
    <main>
        <!-- 전체 레이아웃 -->
        <div class="container">
            <!-- 왼쪽 텍스트 부분 (기존 최상위 div) -->
            <div class="left-content">
                <div>
                    <div class="maintitle-animation">
                        <a class="maintitle">원하는 민원문서,</a>
                    </div>
                    <div class="subtitle-animation">
                        <a class="subtitle">이제 한 곳에서 찾아보세요!</a>
                    </div>
                </div>
                <div class="left-category-content">
                	<div style="margin-top: 120px">
                    <a class="category-title">서비스를 선택하세요.</a>

                    <!-- 카테고리 그리드 -->
                    <div class="category-grid">
                        <% 
                        Connection conn = null;
                        Statement stmt = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;

                        try {
                            // 데이터베이스 연결
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            String url = "jdbc:mysql://localhost:3306/";
                            conn = DriverManager.getConnection(url, "root", "");
                            stmt = conn.createStatement();

                            // SQL 파일 경로 설정
                            String filePath = application.getRealPath("/WEB-INF/categoriesTable.sql");
                            File sqlFile = new File(filePath);

                            if (sqlFile.exists()) {
                                // SQL 파일 읽기
                                BufferedReader reader = new BufferedReader(new FileReader(sqlFile));
                                StringBuilder sqlBuilder = new StringBuilder();
                                String line;

                                while ((line = reader.readLine()) != null) {
                                    sqlBuilder.append(line).append("\n");
                                }
                                reader.close();

                                // SQL 명령어 실행
                                String[] sqlCommands = sqlBuilder.toString().split(";");
                                for (String sql : sqlCommands) {
                                    if (!sql.trim().isEmpty()) {
                                        stmt.execute(sql.trim());
                                    }
                                }
                            }

                            // 최상위 항목 가져오기
                            String query = "SELECT id, name FROM categories WHERE parent_id IS NULL AND type = 'main_title'";
                            pstmt = conn.prepareStatement(query);
                            rs = pstmt.executeQuery();

                            while (rs.next()) { 
                        %>
                            <a href="category.jsp?parent_id=<%= rs.getInt("id") %>" class="category-item">
                                <%= rs.getString("name") %>
                            </a>
                        <% 
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) rs.close();
                            if (pstmt != null) pstmt.close();
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
                        }
                        %>
                    </div>
                </div>
                </div>
            </div>

            <!-- 오른쪽 이미지 -->
            <div class="right-content">
                <img src="image/DesktopBanner1.png" alt="Desktop Banner">
            </div>
        </div>
    </main>
</body>
</html>