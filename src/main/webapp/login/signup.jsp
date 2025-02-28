<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <link rel="stylesheet" type="text/css" href="../css/signUp.css">
</head>
<body>

    <header>
        <h1>게시판</h1>
    </header>

    <section class="signup-form-container">
        <h2>회원가입</h2>
        <form action="signupAction.jsp" method="post">
            <div class="input-group">
                <label for="username">아이디</label>
                <input type="text" id="username" name="username" placeholder="아이디를 입력하세요" required>
            </div>
            <div class ="input-group">
            	<label for="nickname">닉네임</label>
            	<input type="text" id="nickname" name="nickname" placeholder="닉네임을 입력하세요" required>
            </div>
            <div class="input-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
            </div>
            <div class="input-group">
                <label for="confirmPassword">비밀번호 확인</label>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="비밀번호를 다시 입력하세요" required>
            </div>
            <div class="input-group">
                <label for="email">이메일</label>
                <input type="email" id="email" name="email" placeholder="이메일을 입력하세요" required>
            </div>
            
            <input type="submit" value="회원가입">
            
            <p class="login-link">이미 계정이 있으신가요? <a href="login.jsp">로그인</a></p>
        </form>
    </section>

    <footer>
        <p>&copy; 2025 게시판 시스템</p>
    </footer>

</body>
</html>
