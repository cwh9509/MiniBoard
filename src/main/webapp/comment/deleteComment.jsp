<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseUtil" %>>

<%
    String commentId = request.getParameter("id");
    String postId = request.getParameter("postId");

    if (commentId == null || postId == null) {
        out.println("<script>alert('잘못된 요청입니다.'); location.href='index.jsp';</script>");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        conn = DatabaseUtil.getConnection();

        // 댓글 삭제 쿼리
        String deleteCommentSql = "DELETE FROM comments WHERE id = ?";
        pstmt = conn.prepareStatement(deleteCommentSql);
        pstmt.setInt(1, Integer.parseInt(commentId));
        int result = pstmt.executeUpdate();

        if (result > 0) {
            // 댓글 삭제 성공 후, 상세 페이지로 리다이렉트
            out.println("<script>alert('댓글이 삭제되었습니다.'); location.href='../detail.jsp?id=" + postId + "';</script>");
        } else {
            out.println("<script>alert('댓글 삭제에 실패했습니다.'); location.href='../detail.jsp?id=" + postId + "';</script>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<p>데이터베이스 오류가 발생했습니다. 관리자에게 문의하세요.</p>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>알 수 없는 오류가 발생했습니다. 관리자에게 문의하세요.</p>");
    } finally {
        // 자원 반환
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
