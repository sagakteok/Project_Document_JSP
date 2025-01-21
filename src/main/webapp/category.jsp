<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="header.jsp" %>
<%
    Connection conn = null;
    PreparedStatement pstmtParent = null;
    ResultSet rsParent = null;
    PreparedStatement pstmtChildren = null;
    ResultSet rsChildren = null;

    int parentId = Integer.parseInt(request.getParameter("parent_id")); // 선택된 대분류 ID

    try {
        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/Project_Document_JSP?useUnicode=true&characterEncoding=UTF-8";
        conn = DriverManager.getConnection(url, "root", "");

        // parent_id에 해당하는 부모 항목 이름 가져오기
        String queryParent = "SELECT name FROM categories WHERE id = ?";
        pstmtParent = conn.prepareStatement(queryParent);
        pstmtParent.setInt(1, parentId);
        rsParent = pstmtParent.executeQuery();

        String parentName = "항목 없음";
        if (rsParent.next()) {
            parentName = rsParent.getString("name");
        }

        // 선택된 대분류의 하위 항목 가져오기 (document_agency_images 추가)
        String queryChildren = "SELECT id, name, type, document_agency_images FROM categories WHERE parent_id = ?";
        pstmtChildren = conn.prepareStatement(queryChildren, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        pstmtChildren.setInt(1, parentId);
        rsChildren = pstmtChildren.executeQuery();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><%= parentName %> | 서류봉투</title>
    <style>
        body {
            font-family: 'SpoqaHanSansNeo-bold';
            margin: 0;
            padding: 0;
            background-color: #FFFFFF;
        }
        .container {
            display: flex;
            max-width: 1600px;
            margin: auto;
        }
        .left-sidebar {
            width: 300px;
            height: 100vh;
            background-color: #FFFFFF;
            border-right: 0.5px solid #EBEDF1;
        }
        .left-sidebar-container {
        	position: fixed;
        	margin-left: 50px;
        	margin-top: 80px;
        }
        .left-sidebar-text {
            display: block;
            margin-top: 30px;
            text-decoration: none;
            font-family: SpoqaHanSansNeo-Light;
            font-size: 20px;
            color: #757575;
        }
        .left-sidebar-text:hover {
        	font-family: SpoqaHanSansNeo-Medium;
            color: #2155D6;
        }
        .left-sidebar-text.active {
        	font-family: SpoqaHanSansNeo-Medium;
            color: #2155D6;
        }
        .content {
        	width: 100vw;
        	max-width: 1000px;
        	background-color: #FFFFFF;
        	z-index: 0;
        }
        .title {
            font-family: SpoqaHanSansNeo-Thin;
            font-size: 60px;
            color: #3829AA;
            margin-top: 100px;
            margin-bottom: 100px;
            text-align: center;
        }
        .category-container {
            margin: auto;
            margin-top: 30px;
            background-color: #FBFCFF;
            width: 85vw;
            max-width: 850px;
            height: 300px;
            border-radius: 30px;
            box-shadow: 0px 0px 5px 3px #00000001;
        }
        .category-title {
            font-family: SpoqaHanSansNeo-Bold;
            font-size: 30px;
            color: #4B7BF2;
            margin-left: 40px;
            padding-top: 40px;
        }
        .item-slider {
            display: flex;
            overflow-x: auto;
            padding-left: 40px;
            padding-right: 40px;
            gap: 50px;
        }
        .item-slider::-webkit-scrollbar {
            display: none; /* 스크롤바 숨기기 */
        }
        .item-button {
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #FFFFFF;
            border-radius: 30px;
            box-shadow: 0px 0px 5px 3px #00000001;
            width: 170px;
            height: 150px;
            margin-top: 30px;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .item-button a {
            text-decoration: none;
        }
        .item-button:hover {
            transform: translateY(-5px); /* 살짝 위로 올라가는 효과 */
            box-shadow: 0px 0px 10px 5px #00000005;
        }
        .item-button-text {
            font-family: SpoqaHanSansNeo-Regular;
            font-size: 16px;
            color: #414B6A;
            text-align: center;
        }
        .item-button-images {
            width: 60px; /* 이미지 너비 */
            margin-bottom: 15px; /* 텍스트와 간격 */
        }
        .right-sidebar {
            width: 300px;
            height: 100vh;
            background-color: #FFFFFF;
        }
        .right-sidebar h3 {
            font-family: SpoqaHanSansNeo-Bold;
            font-size: 25px;
            margin-top: 20px;
            color: #000000;
        }
        .right-sidebar-container {
        	position: fixed;
        	margin-left: 50px;
        	margin-top: 80px;
        }
        .scroll-button {
            display: block;
            margin-top: 20px;
            text-decoration: none;
            font-family: SpoqaHanSansNeo-Light;
            font-size: 20px;
            color: #757575;
            cursor: pointer;
        }
        .scroll-button:hover {
            font-family: SpoqaHanSansNeo-Medium;
            color: #2155D6;
        }
        .scroll-button.active {
        	font-family: SpoqaHanSansNeo-Medium;
            color: #2155D6;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="left-sidebar">
			    <div class="left-sidebar-container">
			        <% 
			        Statement stmtLeft = conn.createStatement();
			        ResultSet rsLeft = stmtLeft.executeQuery("SELECT id, name FROM categories WHERE id BETWEEN 1 AND 5");
			        while (rsLeft.next()) {
			            int currentId = rsLeft.getInt("id"); // 현재 링크의 id
			            String linkClass = (currentId == parentId) ? "left-sidebar-text active" : "left-sidebar-text"; // 현재 활성화된 링크인지 확인
			        %>
			        <a href="category.jsp?parent_id=<%= currentId %>" class="<%= linkClass %>">
			            <%= rsLeft.getString("name") %>
			        </a>
			        <% 
			        }
			        rsLeft.close();
			        stmtLeft.close();
			        %>
			    </div>
			</div>
        <div class="content">
            <p class="title"><%= parentName %></p>
            <% while (rsChildren.next()) { %>
            <div class="category-container" id="<%= rsChildren.getString("name") %>">
                <div class="category-title"><%= rsChildren.getString("name") %></div>
                <div class="item-slider">
                    <% 
                        PreparedStatement pstmtSubChildren = conn.prepareStatement("SELECT id, name, type, document_agency_images FROM categories WHERE parent_id = ?");
                        pstmtSubChildren.setInt(1, rsChildren.getInt("id"));
                        ResultSet rsSubChildren = pstmtSubChildren.executeQuery();
                        while (rsSubChildren.next()) { 
                    %>
                    <div class="item-button">
                        <a href="<%= "document_items".equals(rsSubChildren.getString("type")) 
                                    ? "viewDocument.jsp?document_id=" + rsSubChildren.getInt("id") 
                                    : "category.jsp?parent_id=" + rsSubChildren.getInt("id") %>">
                            <img src="<%= rsSubChildren.getString("document_agency_images") %>" class="item-button-images" alt="<%= rsSubChildren.getString("name") %>">
                            <div class="item-button-text"><%= rsSubChildren.getString("name") %></div>
                        </a>
                    </div>
                    <% 
                        }
                        rsSubChildren.close();
                        pstmtSubChildren.close();
                    %>
                </div>
            </div>
            <% } %>
        </div>
        <div class="right-sidebar">
	        <div class="right-sidebar-container">
	        	<h3>목차</h3>
	            <% 
	                rsChildren.beforeFirst();
	                while (rsChildren.next()) { 
	            %>
	            <p class="scroll-button" data-target="<%= rsChildren.getString("name") %>">
	                <%= rsChildren.getString("name") %>
	            </p>
	            <% } %>
	        </div>
        </div>
    </div>
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rsParent != null) rsParent.close();
        if (pstmtParent != null) pstmtParent.close();
        if (rsChildren != null) rsChildren.close();
        if (pstmtChildren != null) pstmtChildren.close();
        if (conn != null) conn.close();
    }
%>