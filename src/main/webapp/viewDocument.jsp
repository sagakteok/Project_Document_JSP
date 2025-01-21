<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="header.jsp" %>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    int documentId = Integer.parseInt(request.getParameter("document_id"));

    try {
        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/Project_Document_JSP?useUnicode=true&characterEncoding=UTF-8";
        conn = DriverManager.getConnection(url, "root", "");

        // 데이터 조회
        String query = "SELECT id, name, document_contents, document_images, document_cost_online, document_cost_offline, document_secprogram_info, document_agencies, document_agency_images, parent_id FROM categories WHERE id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, documentId);
        rs = pstmt.executeQuery();

        String documentName = "";
        String grandparentName = "";
        String parentName = "";

        if (rs.next()) {
            documentName = rs.getString("name");
            String[] descriptionLines = rs.getString("document_contents").split("\n"); // 줄바꿈으로 설명 분리
            
            // 부모 및 조부모 데이터 조회
            String parentQuery = "SELECT name, parent_id FROM categories WHERE id = ?";
            PreparedStatement parentPstmt = conn.prepareStatement(parentQuery);

            // 부모 정보 조회
            int parentId = rs.getInt("parent_id");
            int grandparentId = -1;
            if (parentId != 0) {
                parentPstmt.setInt(1, parentId);
                ResultSet parentRs = parentPstmt.executeQuery();
                if (parentRs.next()) {
                    parentName = parentRs.getString("name");
                    grandparentId = parentRs.getInt("parent_id");
                }
                parentRs.close();
            }

            // 조부모 정보 조회
            if (grandparentId != 0) {
                parentPstmt.setInt(1, grandparentId);
                ResultSet grandparentRs = parentPstmt.executeQuery();
                if (grandparentRs.next()) {
                    grandparentName = grandparentRs.getString("name");
                }
                grandparentRs.close();
            }

            parentPstmt.close();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><%= documentName %> | 서류봉투</title>
    <style>
        body {
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
        .content {
        	width: 100vw;
        	max-width: 1000px;
        	background-color: #FFFFFF;
        	z-index: 0;
        }
        .root-title-container {
            margin-top: 40px;
        }
        .root-title-grandparent {
        	text-decoration: none;
        	font-family: SpoqaHanSansNeo-Light;
            font-size: 20px;
            color: #757575;
            margin-left: clamp(35px, 5vw, 50px);
        }
         .root-title-parent {
            font-family: SpoqaHanSansNeo-Medium;
            font-size: 20px;
            color: #2155D6;
        }
        .title-container {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 95vw;
            max-width: 950px;
            height: 220px;
            background-color: #F8FAFF;
            border-radius: 30px;
            box-shadow: 0px 0px 5px 3px #00000001;
            margin: auto;
            margin-top: 40px;
        }
        .title {
            font-family: SpoqaHanSansNeo-Bold;
            font-size: 50px;
            color: #2B354F;
        }
        .before-info {
            margin-top: 50px;
            margin-left: clamp(35px, 5vw, 50px);
        }
        .icon-container {
            display: flex;
            align-items: center;
            margin-top: 2px;
        }
        .icon-text {
            font-family: SpoqaHanSansNeo-Regular;
            font-size: 15px;
            color: #757575;
            margin-left: 5px;
        }
        .icon-img {
            width: 50px;
        }
        .print-info {
            margin-top: 60px;
            margin-left: 35px;
        }
        .print-title {
            font-family: SpoqaHanSansNeo-Bold;
            font-size: 35px;
            color: #4B7BF2;
        }
        .steps {
            margin-top: 15px;
        }
        .step {
            font-size: 16px;
            font-weight: bold;
            color: #0056b3;
            margin-bottom: 5px;
        }
        .sub-step {
            margin-left: 20px;
            font-size: 15px;
            color: #007BFF;
            margin-bottom: 5px;
        }
        .detail {
            margin-left: 40px;
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
        }
        .document-image {
            text-align: center;
            margin-top: 20px;
        }
        .document-image img {
            max-width: 100%;
            height: auto;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .no-image {
            font-size: 14px;
            color: #999;
        }
        .fixed-footer {
        	background-color: transparent;
        	box-shadow: inset 0px -110px 30px -30px white;
       		bottom: 0px;
		    position: fixed;
		    margin: auto;
		    width: 100vw;
		   	max-width: 1000px;
		    height: 110px;
		    z-index: 10;
		}
		.view-document-button {
			display: flex;
			align-items: center;
			justify-content: center;
			margin: auto;
			margin-bottom: 30px;
			width: 320px;
			height: 65px;
		    background-color: #4B7BF2;
		    border: none;
		    border-radius: 15px;
		    box-shadow: 0px 0px 5px 3px #00000001;
		    transition: background-color 0.3s ease;
		  	cursor: pointer;
		}
		.view-document-button:hover {
		    background-color: #3A5BB8;
		}
		/* 모달 배경 */
		.modal {
		    display: none;
		    position: fixed;
		    z-index: 100;
		    left: 0;
		    top: 0;
		    width: 100%;
		    height: 100%;
		    overflow: auto;
		    background-color: rgba(0, 0, 0, 0.8); /* 반투명 배경 */
		}
		
		/* 모달 내용 */
		.modal-content {
		    position: relative;
		    margin: 15% auto;
		    padding: 20px;
		    width: 80%;
		    max-width: 800px;
		    background-color: #FFFFFF;
		    border-radius: 10px;
		    text-align: center;
		}
		
		/* 서류 이미지 */
		.modal-image {
		    width: 100%;
		    height: auto;
		    border-radius: 5px;
		}
		
		/* 닫기 버튼 */
		.close-button {
		    position: absolute;
		    top: 10px;
		    right: 15px;
		    color: #333;
		    font-size: 24px;
		    font-weight: bold;
		    cursor: pointer;
		}
		.close-button:hover {
		    color: #FF0000;
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
    <script>
    // 모달 열기 및 닫기 기능
    document.addEventListener("DOMContentLoaded", () => {
        const modal = document.getElementById("document-modal");
        const openModalButton = document.getElementById("open-modal");
        const closeButton = document.querySelector(".close-button");

        // 모달 열기
        openModalButton.addEventListener("click", () => {
            modal.style.display = "block";
        });

        // 모달 닫기
        closeButton.addEventListener("click", () => {
            modal.style.display = "none";
        });

        // 배경 클릭 시 모달 닫기
        window.addEventListener("click", (event) => {
            if (event.target === modal) {
                modal.style.display = "none";
            }
        });
    });
</script>
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
        	<div class="root-title-container">
		    <div class="root-title">
		        <% 
		            if (!grandparentName.isEmpty()) { 
		        %>
		            <a class="root-title-grandparent" href="category.jsp?parent_id=<%= grandparentId %>" ><%= grandparentName %> > </a>
		        <% 
		            }
		            if (!parentName.isEmpty()) { 
		        %>
		            <a class="root-title-parent"><%= parentName %></a>
		        <% 
		            } 
		        %>
		    </div>
		</div>
        <div class="title-container">
            <p class="title"><%= documentName %><p>
        </div>

        <div class="before-info">
            <a style="font-family: SpoqaHanSansNeo-Medium; color: #424242; font-size: 30px; margin-left: 10px;">👉 출력 전 확인해보세요.</a>
            <div class="icon-container" style="margin-top: 20px">
                <img class="icon-img" src="<%= (rs.getString("document_secprogram_info") != null) ? "icons/security.png" : "icons/no_security.png" %>" alt="보안 프로그램">
                <p class="icon-text"><%= (rs.getString("document_secprogram_info") != null)
                    ? "보안 프로그램 ( " + rs.getString("document_secprogram_info") + " )"
                    : "보안 프로그램 필요하지 않음" %></p>
            </div>
            <div class="icon-container">
                <img class="icon-img" src="icons/online_cost.png" alt="온라인 출력">
                <p class="icon-text">온라인 출력: 
                    <%= (rs.getObject("document_cost_online") != null) 
                        ? String.format("%,d원", rs.getInt("document_cost_online")) 
                        : "출력 비용 필요하지 않음" %>
                </p>
            </div>
            <div class="icon-container">
                <img class="icon-img" src="icons/offline_cost.png" alt="오프라인 출력">
                <p class="icon-text">오프라인 출력: 
                    <%= (rs.getObject("document_cost_offline") != null) 
                        ? String.format("%,d원", rs.getInt("document_cost_offline")) 
                        : "출력 비용 필요하지 않음" %>
                </p>
            </div>
            <div class="icon-container">
			    <% if (rs.getString("document_agencies") != null && !rs.getString("document_agencies").isEmpty()) { %>
			        <img class="icon-img" src="<%= rs.getString("document_agency_images") %>">
			        <p class="icon-text">담당 기관: <%= rs.getString("document_agencies") %></p>
			    <% } else { %>
			        <p>담당 기관 없음</p>
			    <% } %>
			</div>
        </div>

        <div class="print-info">
            <div class="print-title">출력 방법</div>
            <div class="steps">
                <% for (String line : descriptionLines) { %>
                    <% if (line.matches("^\\d+\\. .*")) { %>
                        <div class="step"><%= line %></div>
                    <% } else if (line.matches("^\\d+-\\d+\\. .*")) { %>
                        <div class="sub-step"><%= line %></div>
                    <% } else { %>
                        <div class="detail"><%= line %></div>
                    <% } %>
                <% } %>
            </div>
        </div>
		<div class="section document-image">
		    <!-- 서류 이미지 모달 -->
		    <div id="document-modal" class="modal">
		        <div class="modal-content">
		            <span class="close-button">&times;</span>
		            <% if (rs.getString("document_images") == null || rs.getString("document_images").isEmpty()) { %>
		                <p class="no-image">서류 양식 이미지가 없습니다.</p>
		            <% } else { %>
		                <img src="<%= rs.getString("document_images") %>" alt="서류 양식 이미지" class="modal-image">
		            <% } %>
		        </div>
		    </div>
		</div>
		
		<!-- 항상 하단에 고정된 버튼 -->
		<div class="fixed-footer">
		    <button id="open-modal" class="view-document-button">
		        <p style="font-family: SpoqaHanSansNeo-Bold; color: #FFFFFF; font-size: 18px;">서류양식 보기</p>
		    </button>
		</div>
        </div>
        <div class="right-sidebar">
		    <div class="right-sidebar-container">
		        <h3>목차</h3>
	            <p class="scroll-button">출력 전 확인 사항</p>
	            <p class="scroll-button">출력 방법</p>
		    </div>
		</div>
    </div>
</body>
</html>
<%
        } else {
            out.println("<h1>해당 문서를 찾을 수 없습니다.</h1>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>