<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="util.DatabaseUtil"%>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // id 파라미터 확인
    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }

    int postId = 0;
    try {
        postId = Integer.parseInt(idStr); // 숫자 형식으로 변환
    } catch (NumberFormatException e) {
        out.println("<script>alert('잘못된 게시글 ID입니다.'); history.back();</script>");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        conn = DatabaseUtil.getConnection();
        System.out.println("게시글 ID: " + postId);  // 게시글 ID 확인
        System.out.println("로그인한 사용자: " + session.getAttribute("username"));  // 로그인한 사용자 확인 여기까진 됨 게시글 7번 hgd123 뜨는거 확인햇음
        String sql = "DELETE FROM board WHERE id = ?";
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, postId); // id를 사용
        //pstmt.setString(2, (String) session.getAttribute("username")); // 로그인한 사용자와 일치하는지 체크

        int result = pstmt.executeUpdate();

        if (result > 0) {
            response.sendRedirect("index.jsp"); // 삭제 후 리다이렉트
        } else {
            out.println("<script>alert('삭제에 실패했습니다.'); history.back();</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>

