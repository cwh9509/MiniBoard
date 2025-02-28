<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    String username = (String) session.getAttribute("username");
    String nickname = (String) session.getAttribute("nickname");
    String postId = request.getParameter("id");
    request.setCharacterEncoding("UTF-8");
    System.out.println("Received postId: " + postId);  // 받아오는지 체크용

    // postId가 null인 경우 에러 처리
    request.setCharacterEncoding("UTF-8"); 

    if (postId == null) {
        out.println("<script>alert('게시글 ID가 잘못되었습니다.'); location.href='index.jsp';</script>");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // 게시글 정보를 담을 변수 선언
    String title = "", writer = "", content = "", date = "", views = "0";

    // 댓글 정보 담을 List
    List<String> comments = new ArrayList<>();
    List<String> commentWriters = new ArrayList<>();
    List<String> commentDates = new ArrayList<>();
    List<Integer> commentIds = new ArrayList<>();

    try {
        conn = DatabaseUtil.getConnection();

        // 조회수 증가 쿼리
        String updateViewsSql = "UPDATE board SET views = views + 1 WHERE id = ?";  
        pstmt = conn.prepareStatement(updateViewsSql);
        pstmt.setString(1, postId);
        pstmt.executeUpdate(); // 조회수 증가

        // 게시글 정보 가져오기
        String sql = "SELECT id, title, writer, content, date, views FROM board WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, postId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            writer = rs.getString("writer");
            content = rs.getString("content");
            date = rs.getString("date");
            views = rs.getString("views");
        } else {
            // 해당 게시글이 없을 경우 처리
            out.println("<script>alert('존재하지 않는 게시글입니다.'); location.href='index.jsp';</script>");
            return;
        }

        // 댓글 목록 가져오기
        String commentSql = "SELECT id, content, writer, date FROM comments WHERE board_id = ? ORDER BY date ASC";
        pstmt = conn.prepareStatement(commentSql);
        pstmt.setString(1, postId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            int commentId = rs.getInt("id");
            String commentContent = rs.getString("content");
            String commentWriter = rs.getString("writer");
            String commentDate = rs.getString("date");

            comments.add(commentContent);
            commentWriters.add(commentWriter);
            commentDates.add(commentDate);
            commentIds.add(commentId);
        }

    } catch (SQLException e) {
        // SQL 예외 발생 시 처리
        e.printStackTrace();
        out.println("<p>데이터베이스 오류가 발생했습니다. 관리자에게 문의하세요.</p>");
    } catch (Exception e) {
        // 일반 예외 처리
        e.printStackTrace();
        out.println("<p>알 수 없는 오류가 발생했습니다. 관리자에게 문의하세요.</p>");
    } finally {
        // rs와 pstmt는 사용 후 반드시 닫아야 함
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
    <title>게시글 상세 보기</title>
    <link rel="stylesheet" type="text/css" href="./css/boardDetail.css">
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

    <section class="post-detail">
        <h2><%= title %></h2>
        <p><strong>작성자:</strong> <%= writer %> | <strong>작성일:</strong> <%= date %> | <strong>조회수:</strong> <%= views %></p>
        <p><%= content %></p>

        <div class="post-actions">
            <% 
                // 로그인된 사용자와 게시글 작성자가 일치하는지 확인
                String loggedInUser = (String) session.getAttribute("nickname");
                if (loggedInUser != null && loggedInUser.equals(writer)) {
            %>
                <a href="update.jsp?id=<%= postId %>" class="btn">수정</a>
                <a href="deleteAction.jsp?id=<%= postId %>" class="btn">삭제</a>
            <% } %>
        </div>

        <h3>댓글</h3>
        <ul class="comments-list">
            <% 
                // 댓글 출력
                for (int i = 0; i < comments.size(); i++) {
            %>
            <li>
                <div class="comment-header">
                    <strong><%= commentWriters.get(i) %>  <%= commentDates.get(i) %></strong>
                </div>
                <div class="comment-content">
                    <%= comments.get(i) %>
                </div>
                <% if (session.getAttribute("nickname") != null && session.getAttribute("nickname").equals(commentWriters.get(i))) { %>
                <a href="comment/deleteComment.jsp?id=<%= commentIds.get(i) %>&postId=<%= postId %>" class="comment-delete-btn">삭제</a>
                <% } %>
            </li>
            <% 
                }
            %>
        </ul>

        <!-- 댓글 폼: 로그인된 사용자만 보이도록 처리 -->
        <% nickname = (String) session.getAttribute("nickname"); %>
        <% if (nickname != null) { %>
            <form action="comment/addComment.jsp" method="post" class="commentForm">
                <textarea name="comment" placeholder="댓글을 작성하세요..." required></textarea>
                <input type="hidden" name="postId" value="<%= postId %>">
                <input type="submit" value="댓글 작성">
            </form>
        <% } else { %>
            <p>댓글을 작성하려면 <a href="./login/login.jsp">로그인</a>하세요.</p>
        <% } %>

        <form action="index.jsp">
            <input type="submit" value="목록으로 돌아가기">
        </form>

    </section>

    <footer>
        <p>&copy; 2025 게시판 시스템</p>
    </footer>

</body>
</html>
