<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<!DOCTYPE html>
<%
    request.setCharacterEncoding("UTF-8"); 
    String nickname = (String) session.getAttribute("nickname");  // 세션에서 닉네임을 가져옴
    if (nickname == null) {
        response.sendRedirect("login/login.jsp");  // 로그인되지 않은 상태이면 로그인 페이지로 리디렉션
        return;
    }
%>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 작성</title>
        <link rel="stylesheet" type="text/css" href="./css/write.css">
</head>

<body>
    <header>
        <h1>새 게시글 작성</h1>
    </header>

    <section class="write-form">
        <h2>게시글 작성</h2>
        <!-- 게시글 작성 폼 -->
        <form action="writeAction.jsp" method="POST" class="post-form">
            <label for="title">제목</label>
            <input type="text" id="title" name="title" required placeholder="게시글 제목을 입력하세요." maxlength="100">

            <label for="writer">작성자</label>
            <input type="text" id="writer" name="writer" value="<%= nickname %>" readonly>  <!-- 닉네임 자동 입력 -->

            <label for="content">내용</label>
            <textarea id="content" name="content" rows="10" required placeholder="게시글 내용을 작성하세요."></textarea>

            <div class="form-actions">
                <input type="submit" value="게시글 작성하기">
                <a href="index.jsp" class="cancel-btn">취소</a> <!-- 취소 버튼 -->
            </div>
        </form>
    </section>

    <footer>
        <p>&copy; 2025 게시판 시스템</p>
    </footer>
</body>
</html>
