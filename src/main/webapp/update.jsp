<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseUtil" %>

<%
	String username = (String) session.getAttribute("username");
	String nickname = (String) session.getAttribute("nickname");
	request.setCharacterEncoding("UTF-8"); 
    // postId 가져오기
    
    String postId = request.getParameter("id");

    if (postId == null) {
        out.println("<script>alert('잘못된 접근입니다.'); location.href='index.jsp';</script>");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // 게시글 정보
    String title = "", content = "", writer = "";

    try {
        conn = DatabaseUtil.getConnection();

        // 게시글 정보 가져오기
        String sql = "SELECT title, content, writer FROM board WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, postId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            content = rs.getString("content");
            writer = rs.getString("writer");
        } else {
            out.println("<script>alert('존재하지 않는 게시글입니다.'); location.href='index.jsp';</script>");
            return;
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<p>데이터베이스 오류가 발생했습니다. 관리자에게 문의하세요.</p>");
    } finally {
        // 리소스 정리
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 수정</title>
    <link rel="stylesheet" type="text/css" href="./css/boardUpdate.css">

    
</head>
<body>

    <header>
        <h1>게시판</h1>
        <div class="header-actions">
	    <% if (username == null) { %>
	        <a href="./login/login.jsp" class="login-btn">로그인</a> <!-- 로그인 버튼 -->
	    <% } else { %>
	        <span><%= nickname %>님</span> <!-- 로그인한 사용자의 닉네임 -->
	        <a href="./login/logout.jsp" class="login-btn">로그아웃</a>
	    <% } %>
	</div>
    </header>

    <section class="post-update">
    <h2>게시글 수정</h2>

    <form action="updateAction.jsp" method="post">
        <input type="hidden" name="id" value="<%= postId %>">
        <div>
            <label for="title">제목</label>
            <input type="text" id="title" name="title" value="<%= title %>" required>
        </div>

        <div>
            <label for="content">내용</label>
            <textarea id="content" name="content" rows="10" required><%= content %></textarea>
        </div>

        <div>
            <button type="submit" class="btn">수정하기</button>
        </div>
    </form>

    <form action="index.jsp">
        <input type="submit" value="목록으로 돌아가기" class="btn">
    </form>
</section>


    <footer>
        <p>&copy; 2025 게시판 시스템</p>
    </footer>

</body>
</html>
