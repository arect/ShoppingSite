<%@ page language="java" import="java.util.*" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <link href="css/style.css" rel="stylesheet" type="text/css" id="STYLE" />
    <title>上/下架</title>
</head>
<body>
    <sql:setDataSource var="snapshot" driver="com.mysql.cj.jdbc.Driver" url="jdbc:mysql://localhost/shoppingsite?&useSSL=false&serverTimezone=Asia/Shanghai" user="root"  password="admin"/>
    <c:choose>
        <c:when test="${param.istatus==1}">
            <sql:update dataSource="${snapshot}">
            UPDATE goods SET status=0 where ID=?;
            <sql:param value="${param.userID }"></sql:param>
            </sql:update>
        </c:when>
        <c:when test="${param.istatus==0}">
            <sql:update dataSource="${snapshot}">
            UPDATE goods SET status=1 where ID=?;
            <sql:param value="${param.userID }"></sql:param>
            </sql:update>
        </c:when>
    </c:choose>
    <sql:query dataSource="${snapshot}" var="result">
            SELECT * from goods where ID=?;
            <sql:param value="${param.userID }"></sql:param>
    </sql:query>
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
    <c:forEach var="row" items="${result.rows}">
    <div class="Issue">
        <h2>成功！</h2>
        <form>
            <h3>ID</h3>
            <input class="Input-short" type="text" name="ID" value=<c:out value="${row.ID }"/> onfocus=this.blur() style="caret-color: transparent;" readonly>
            <h3>名称</h3>
            <input class="Input-short" type="text" name="COM-NAME" value=<c:out value="${row.name }"/> readonly>
            <h3>数量</h3>
            <input class="Input-short" type="text" name="AMOUNT" value=<c:out value="${row.stock }"/> readonly>
            <h3>图片链接</h3>
            <input class="Input-long" type="text" name="IMG-LINK" value="${row.imgurl }" readonly>
            <h3>介绍</h3>
            <input class="Input-long" type="text" name="INTRODUCTION" value="${row.introduction }" readonly>
            <h3>定价</h3>
            <input class="Input-short" type="text" name="PRICE" value=<c:out value="${row.price }"/> readonly>
            <h3>上架</h3>
            <c:choose>
            <c:when test="${row.status==1 }"><input class="Input-short" type="text" name="STATUS" value="是" readonly></c:when>
            <c:when test="${row.status==0 }"><input class="Input-short" type="text" name="STATUS" value="否"  readonly></c:when>
            </c:choose>
            <a href="seller.jsp" style="float:right"><b>返回卖家页面</b></a>
        </form>
    </div>
    </c:forEach>
    <footer class="Footer">
        Hello, World!
    </footer>
</body>
</html>