<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseUtil" %>

<%
    String username = (String) session.getAttribute("username");
    String nickname = (String) session.getAttribute("nickname");
    request.setCharacterEncoding("UTF-8");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String[][] boardData = new String[0][];  // I

    try {
        conn = DatabaseUtil.getConnection();

        // Count the total number of posts
        int count = 0;
        String sql = "SELECT count(*) FROM board";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            count = rs.getInt(1);
        }

        // Fetch the board data
        sql = "SELECT id, title, writer, date, views FROM board ORDER BY date DESC";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        // Initialize the boardData array with the correct size
        boardData = new String[count][5];
        int i = 0;
        while (rs.next()) {
            boardData[i][0] = rs.getString("id");
            boardData[i][1] = rs.getString("title");
            boardData[i][2] = rs.getString("writer");
            boardData[i][3] = rs.getString("date");
            boardData[i][4] = rs.getString("views");
            i++;
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시판 목록</title>
    <link rel="stylesheet" type="text/css" href="./css/index.css">
</head>
<body>
    <header>
        <h1>게시판</h1>
    </header>

    <div class="header-actions">
	    <% if (username == null) { %>
	        <a href="./login/login.jsp" class="login-btn">로그인</a> <!-- 로그인 버튼 -->
	    <% } else { %>
	        <span><%= nickname %>님</span> <!-- 로그인한 사용자의 닉네임 -->
	        <a href="./login/logout.jsp" class="login-btn">로그아웃</a>
	    <% } %>
	</div>


    <section class="board-list">
        <h2 class="board-title">게시글 목록</h2> <!-- 게시판 목록 제목 -->
        
        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                    <th>조회수</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    // 게시글 목록 출력
                    for (int i = 0; i < boardData.length; i++) {
                %>
                    <tr>
                        <td><%= boardData[i][0] %></td>
                        <td><a href="detail.jsp?id=<%= boardData[i][0] %>"><%= boardData[i][1] %></a></td>
                        <td><%= boardData[i][2] %></td> <!-- 작성자 -->
                        <td><%= boardData[i][3] %></td> <!-- 작성일 -->
                        <td><%= boardData[i][4] %></td> <!-- 조회수 -->
                    </tr>
                <%  
                    }
                %>
            </tbody>
        </table>

        <div class="board-actions">
            <a href="write.jsp" class="btn">새 게시글 작성</a> <!-- 새 게시글 작성 버튼 -->
        </div>

    </section>

    <footer>
        <p>&copy; 2025 게시판 시스템</p>
    </footer>
</body>
</html>
