<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<html>
<head>
    <meta charset="utf-8">
    <link href="css/style.css" rel="stylesheet" type="text/css" id="STYLE" />
    <title>登入页面</title>
</head>
<body>
<div class="TopBar">
    <a href="index.jsp"><h1 class="Title">购物</h1></a>
    <div class="SearchBar">
        <form action="search.jsp" method="POST">
            <input type="text" name="name">
            <button type="submit"><img src="img/search.svg" alt="搜索"></button>
        </form>
    </div>
</div>
<div class="Empty"></div>
<div class="Signin">
    <h2>登入</h2>
    <form action="loginCh.jsp" method="POST">
        <h3>账号</h3>
        <input type="text" name="COUNT">
        <h3>密码</h3>
        <input type="text" name="PASSWORD">
        <button type="submit"><b>登入</b></button>
    </form>
    <a href="register.jsp"><b>注册</b></a>
</div>
<footer class="Footer">
    Hello, World!
</footer>
</body>
</html>