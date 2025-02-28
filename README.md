MySQL 데이터
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,        -- 고유 식별자
    username VARCHAR(50) NOT NULL,             -- 아이디 (중복되지 않도록 UNIQUE 제약)
    nickname VARCHAR(50) NOT NULL,             -- 닉네임 (중복되지 않도록 UNIQUE 제약)
    password VARCHAR(255) NOT NULL,            -- 비밀번호
    email VARCHAR(100) NOT NULL,               -- 이메일
    UNIQUE (username),                        -- 아이디 중복 방지
    UNIQUE (nickname),                        -- 닉네임 중복 방지
    UNIQUE (email)                            -- 이메일 중복 방지
);

CREATE TABLE board (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- 게시글 고유 ID
    title VARCHAR(255) NOT NULL,                -- 게시글 제목
    content TEXT NOT NULL,                     -- 게시글 내용
    writer VARCHAR(100) NOT NULL,              -- 작성자
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 작성일 (기본값은 현재 시간)
    views INT DEFAULT 0,                       -- 조회수 (기본값 0)
    comments INT DEFAULT 0                     -- 댓글 수 (기본값 0)
);

CREATE TABLE comments (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- 댓글 고유 ID
    board_id INT NOT NULL,                     -- 댓글이 달린 게시글의 ID (외래키)
    content TEXT NOT NULL,                     -- 댓글 내용
    writer VARCHAR(100) NOT NULL,              -- 댓글 작성자
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 댓글 작성일
    FOREIGN KEY (board_id) REFERENCES board(id) -- 외래키 설정
);
