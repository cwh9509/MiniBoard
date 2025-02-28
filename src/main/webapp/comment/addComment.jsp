<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseUtil" %>

<%
    request.setCharacterEncoding("UTF-8");
    String comment = request.getParameter("comment");
    String postId = request.getParameter("postId");

    // 세션에서 사용자 닉네임 가져오기
    String writer = (String) session.getAttribute("nickname");

    // 로그인하지 않은 사용자 처리
    if (writer == null) {
        out.println("<script>alert('로그인 후 댓글을 작성할 수 있습니다.'); location.href='../login/login.jsp';</script>");
        return; // 댓글 작성 로직을 종료하고 로그인 페이지로 이동
    }

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
            response.sendRedirect("../detail.jsp?id=" + postId);
        } else {
            out.println("<script>");
            out.println("alert('댓글 작성에 실패했습니다.');");
            out.println("history.back();");
            out.println("</script>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<p>데이터베이스 오류가 발생했습니다. 관리자에게 문의하세요.</p>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>알 수 없는 오류가 발생했습니다. 관리자에게 문의하세요.</p>");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
