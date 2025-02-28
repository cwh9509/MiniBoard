<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="util.DatabaseUtil" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = request.getParameter("username");
    String nickname = request.getParameter("nickname");
    String password = request.getParameter("password");
    String email = request.getParameter("email");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = DatabaseUtil.getConnection();
        
        // 아이디 중복 체크
        String checkUsernameSql = "SELECT username FROM users WHERE username = ?";
        pstmt = conn.prepareStatement(checkUsernameSql);
        pstmt.setString(1, username);
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            out.println("<script>");
            out.println("alert('이미 존재하는 아이디입니다.');");
            out.println("history.back();");
            out.println("</script>");
        } else {
            // 닉네임 중복 체크
            String checkNicknameSql = "SELECT nickname FROM users WHERE nickname = ?";
            pstmt = conn.prepareStatement(checkNicknameSql);
            pstmt.setString(1, nickname);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                out.println("<script>");
                out.println("alert('이미 존재하는 닉네임입니다.');");
                out.println("history.back();");
                out.println("</script>");
            } else {
                // 회원가입 처리
                String sql = "INSERT INTO users (username, nickname, password, email) VALUES (?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, nickname);
                pstmt.setString(3, password);
                pstmt.setString(4, email);
                
                int result = pstmt.executeUpdate();
                
                if(result > 0) {
                    out.println("<script>");
                    out.println("alert('회원가입이 완료되었습니다.');");
                    out.println("location.href='login.jsp';");
                    out.println("</script>");
                } else {
                    out.println("<script>");
                    out.println("alert('회원가입에 실패했습니다.');");
                    out.println("history.back();");
                    out.println("</script>");
                }
            }
        }
    } catch(Exception e) {
        e.printStackTrace();
        out.println("<script>");
        out.println("alert('오류가 발생했습니다.');");
        out.println("history.back();");
        out.println("</script>");
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>
