<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseUtil" %>
<%
request.setCharacterEncoding("UTF-8");
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    String writer = (String) session.getAttribute("nickname");  // 세션에서 닉네임 가져오기

   
    if (writer == null) {
        response.sendRedirect("login/login.jsp");  // 로그인되지 않은 상태에서 작성 시 로그인 페이지로 리디렉션
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = DatabaseUtil.getConnection();
        
        // 게시글 삽입 쿼리
        String sql = "INSERT INTO board (title, content, writer,date,views) VALUES (?, ?, ?,NOW(),0)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        pstmt.setString(3, writer);

        int result = pstmt.executeUpdate();

        if (result > 0) {
            response.sendRedirect("index.jsp");  // 게시글 작성 완료 후, 게시판 목록으로 리디렉션
        } else {
            out.println("<script>");
            out.println("alert('게시글 작성에 실패했습니다.');");
            out.println("history.back();");
            out.println("</script>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<script>");
        out.println("alert('데이터베이스 연결 오류. 관리자에게 문의해주세요.');");
        out.println("history.back();");
        out.println("</script>");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
