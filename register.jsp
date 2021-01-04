<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <link rel="stylesheet" type="text/css" id="STYLE" href="css/style.css" />
  <title>注册页面</title>
</head>
<body>
<div class="TopBar">
  <a href="index.jsp"><h1 class="Title">购物</h1></a>
</div>
<div class="Empty"></div>
<div class="Login">
  <h2>注册</h2>
  <form action="registerCh.jsp" method="POST">
    <h3>昵称</h3>
    <input type="text" name="NICKNAME">
    <h3>电话号码</h3>
    <input type="text" name="TELPHONE">
    <h3>身份</h3>
    <select name="IDENTITY">
      <option value="buyer">买家</option>
      <option value="seller">卖家</option>
      <option value="admin">管理员</option>
    </select>
    <h3>头像地址</h3>
    <input type="text" name="AVATAR">
    <h3>密码</h3>
    <input type="text" name="PASSWORD" placeholder="密码不少于四位">
    <h3>确认密码</h3>
    <input type="text" name="PASSWORD-AGAIN" placeholder="密码不少于四位">
    <button type="submit"><b>注册</b></button>
  </form>
  <p>注册即代表您同意我们的服务条款</p>
</div>
<footer class="Footer">
  Hello, World!
</footer>
</body>
</html>