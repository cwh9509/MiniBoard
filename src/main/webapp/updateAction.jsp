<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseUtil" %>

<%
    // 폼에서 받은 값
    request.setCharacterEncoding("UTF-8"); 
    String postId = request.getParameter("id");
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    if (postId == null || title == null || content == null || postId.isEmpty() || title.isEmpty() || content.isEmpty()) {
        out.println("<script>alert('필수 항목이 비어 있습니다.'); history.back();</script>");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        conn = DatabaseUtil.getConnection(); // 데이터베이스 연결

        // 게시글 수정 쿼리 (제목과 내용 업데이트)
        String updateSql = "UPDATE board SET title = ?, content = ? WHERE id = ?";
        pstmt = conn.prepareStatement(updateSql);
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        pstmt.setString(3, postId);

        int result = pstmt.executeUpdate();

        if (result > 0) {
            // 수정이 성공하면 게시글 목록 페이지로 리다이렉트
            response.sendRedirect("detail.jsp?id=" + postId);
        } else {
            // 수정이 실패하면 에러 메시지 출력
            out.println("<script>alert('게시글 수정에 실패했습니다.'); history.back();</script>");
        }

    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<script>alert('데이터베이스 오류가 발생했습니다. 관리자에게 문의하세요.'); history.back();</script>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('알 수 없는 오류가 발생했습니다. 관리자에게 문의하세요.'); history.back();</script>");
    } finally {
        // 자원 해제
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
