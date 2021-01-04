<%@ page language="java" import="java.util.*" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <link href="css/style.css" rel="stylesheet" type="text/css" id="STYLE" />
    <title>商品发布</title>
    <script type="text/javascript">
            function myCheck()
            {
                for(var i=0;i<document.form1.elements.length-1;i++)
               {
                  if(document.form1.elements[i].value=="")
                  {
                     alert("当前表单不能有空项");
                     document.form1.elements[i].focus();
                     return false;
                  }
               }
               return true;
            }
    </script>
</head>
<body>
    <div class="TopBar">
        <a href="index.jsp"><h1 class="Title">购物</h1></a>
        <%
            try {
                Cookie cookie = null;
                Cookie[] cookies = null; 
                cookies = request.getCookies();
                String ID = null;
                String KIND = null;
                if(cookies != null){
                    for (int i = 0; i < cookies.length; i++){
                        cookie = cookies[i];
                        if(cookie.getName().equals("ID")){
                            ID = cookie.getValue();
                        }
                        else if(cookie.getName().equals("KIND")){
                            KIND = cookie.getValue();
                        }
                    }
                    if(ID != null && KIND != null){
                        Class.forName("com.mysql.cj.jdbc.Driver");  ////驱动程序名
                        String url = "jdbc:mysql://localhost:3306/shoppingsite?serverTimezone=Asia/Shanghai&characterEncoding=utf-8"; //数据库名
                        String username = "root";  //数据库用户名
                        String password = "admin";  //数据库用户密码
                        Connection conn = DriverManager.getConnection(url, username, password);  //连接状态
                        if(conn != null){
                            Statement stmt = null; 
                            ResultSet rs = null;
                            String sql = "SELECT * FROM " + KIND + " WHERE ID = " + ID;  //查询语句
                            stmt = conn.createStatement();
                            rs = stmt.executeQuery(sql);
                            while (rs.next()) {
                                out.print("<a href='" + KIND + ".jsp");
                                out.print("'><img class='Avatar' src='");
                                out.print(rs.getString("avatarurl") + "' alt='头像'></a>"); //将查询结果输出 
                            }
                        }
                        else{
                            out.print("<a href='signin.jsp'><img class='Avatar' src='img/11.png' alt='头像'></a>");
                        }
                    }else{
                        out.print("<a href='signin.jsp'><img class='Avatar' src='img/11.png' alt='头像'></a>");
                    }
                }
                else{
                    out.print("<a href='signin.jsp'><img class='Avatar' src='img/11.png' alt='头像'></a>");
                }
            }catch (Exception e) {
                out.print("<a href='signin.jsp'><img class='Avatar' src='img/11.png' alt='头像'></a>");  
            }
        %>
    </div>
    <div class="Empty"></div>
    <div class="Issue">
        <h2>发布商品</h2>
        <form action="issueback.jsp" method="POST" name="form1">
            <h3>名称</h3>
            <input class="Input-short" type="text" name="COM-NAME">
            <h3>数量</h3>
            <input class="Input-short" type="text" name="AMOUNT">
            <h3>图片链接</h3>
            <input class="Input-long" type="text" name="IMG-LINK">
            <h3>介绍</h3>
            <input class="Input-long" type="text" name="INTRODUCTION">
            <h3>定价</h3>
            <input class="Input-short" type="text" name="PRICE">
            <button type="submit" onclick="return myCheck()"><b>发布商品</b></button>
        </form>
    </div>
    <footer class="Footer">
        Hello, World!
    </footer>
</body>
</html>