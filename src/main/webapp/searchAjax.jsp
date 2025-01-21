<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.regex.*" %>
<%
    String query = request.getParameter("query");
    Connection conn = null;
    PreparedStatement pstmt = null;
    PreparedStatement parentStmt = null;
    PreparedStatement grandParentStmt = null;
    ResultSet rs = null;
    ResultSet parentRs = null;
    ResultSet grandParentRs = null;

    boolean hasResults = false; // 검색 결과 존재 여부

    try {
        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/Project_Document_JSP?useUnicode=true&characterEncoding=UTF-8";
        conn = DriverManager.getConnection(url, "root", "");

        // 검색 SQL - type이 document_items인 항목만 검색
        String sql = "SELECT id, parent_id, name, document_contents FROM categories WHERE type = 'document_items' AND (name LIKE ? OR document_contents LIKE ?) LIMIT 10";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, "%" + query + "%");
        pstmt.setString(2, "%" + query + "%");
        rs = pstmt.executeQuery();

        while (rs.next()) {
            hasResults = true; // 결과가 있음을 표시
            int parentId = rs.getInt("parent_id");
            String parentName = "상위 없음";
            String grandParentName = "최상위 없음";

            // 상위 분류 이름 조회
            if (parentId != 0) {
                parentStmt = conn.prepareStatement("SELECT parent_id, name FROM categories WHERE id = ?");
                parentStmt.setInt(1, parentId);
                parentRs = parentStmt.executeQuery();
                if (parentRs.next()) {
                    parentName = parentRs.getString("name");
                    int grandParentId = parentRs.getInt("parent_id");

                    // 상위의 상위 분류 이름 조회
                    if (grandParentId != 0) {
                        grandParentStmt = conn.prepareStatement("SELECT name FROM categories WHERE id = ?");
                        grandParentStmt.setInt(1, grandParentId);
                        grandParentRs = grandParentStmt.executeQuery();
                        if (grandParentRs.next()) {
                            grandParentName = grandParentRs.getString("name");
                        }
                    }
                }
            }

            // 검색어 하이라이트 처리
            String regex = "(?i)(" + query.chars()
                .mapToObj(c -> Pattern.quote(String.valueOf((char)c)))
                .reduce((a, b) -> a + "|" + b).orElse("") + ")";
            String highlightedName = rs.getString("name").replaceAll(regex, "<strong style='color:#4B7BF2;'>$1</strong>");

            String documentContents = rs.getString("document_contents") != null ? rs.getString("document_contents") : "내용 없음";
            String highlightedContents = documentContents.replaceAll(regex, "<strong style='color:#4B7BF2;'>$1</strong>");

            // 검색어 주변 10글자 추출
            Matcher matcher = Pattern.compile("(?i)(" + query + ")").matcher(documentContents);
            StringBuilder snippet = new StringBuilder();

            while (matcher.find()) {
                int start = Math.max(0, matcher.start() - 10);
                int end = Math.min(documentContents.length(), matcher.end() + 10);

                snippet.append(start > 0 ? "..." : "")
                       .append(documentContents.substring(start, end).replaceAll(regex, "<strong style='color:#4B7BF2;'>$1</strong>"))
                       .append(end < documentContents.length() ? "..." : "");
                break; // 첫 번째 감지된 부분만 표시
            }

            if (snippet.length() == 0) {
                snippet.append("감지된 내용 없음");
            }

%>
<div class="autocomplete-item" onclick="location.href='viewDocument.jsp?document_id=<%= rs.getInt("id") %>';">
    <p>[<%= grandParentName %> > <%= parentName %>] <%= highlightedName %></p>
    <p style="font-size: 12px; color: gray;">감지된 내용: <%= snippet.toString() %></p>
</div>
<%
        }

        // 검색 결과가 없을 경우 메시지 출력
        if (!hasResults) {
%>
<div class="autocomplete-item">
    <p style="color: gray;">검색된 결과가 없습니다.</p>
</div>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (grandParentRs != null) grandParentRs.close();
        if (grandParentStmt != null) grandParentStmt.close();
        if (parentRs != null) parentRs.close();
        if (parentStmt != null) parentStmt.close();
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
<style>
@font-face {
	font-family: 'SpoqaHanSansNeo-regular';
}
</style>