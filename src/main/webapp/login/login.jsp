<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <link rel="stylesheet" type="text/css" href="../css/login.css">
</head>
<body>

    <header>
        <h1>게시판</h1>
    </header>

    <section class="login-form-container">
        <h2>로그인</h2>
        <form action="loginAction.jsp" method="post">
            <div class="input-group">
                <label for="username">아이디</label>
                <input type="text" id="username" name="username" placeholder="아이디를 입력하세요" required>
            </div>
            <div class="input-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
            </div>
            <input type="submit" value="로그인">
            
            <!-- 돌아가기 버튼 -->
		<div class="btn-container">
		    <button onclick="window.location.href='../index.jsp';" class="back-btn">돌아가기</button>
		</div>
		<p class="login-link">계정이 없으신가요? <a href="signup.jsp">회원가입</a></p>
        </form>

		
        
        
		
        
    </section>

    <footer>
        <p>&copy; 2025 게시판 시스템</p>
    </footer>

</body>
</html>
