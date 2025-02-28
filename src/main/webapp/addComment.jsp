<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseUtil" %>

<%
    String comment = request.getParameter("comment");
    String postId = request.getParameter("postId");
    String writer = (String) session.getAttribute("nickname");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        conn = DatabaseUtil.getConnection();
        
        // 댓글 삽입 쿼리
        String sql = "INSERT INTO comments (board_id, content, writer) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, postId);
        pstmt.setString(2, comment);
        pstmt.setString(3, writer);

        int result = pstmt.executeUpdate();

        if (result > 0) {
            // 댓글이 정상적으로 추가되면 게시글 상세 페이지로 리디렉션
            response.sendRedirect("detail.jsp?id=" + postId);
        } else {
            out.println("<script>");
            out.println("alert('댓글 작성에 실패했습니다.');");
            out.println("history.back();");
            out.println("</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
