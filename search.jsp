<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@page import="java.sql.*" %>  <%--导入java.sql包--%>

<html>
<head>
    <meta charset="utf-8">
    <link href="css/style.css" rel="stylesheet" type="text/css" id="STYLE" />
    <title>搜索结果</title>
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
                                out.print("<a href='" + KIND + ".jsp?ID=");
                                out.print(rs.getString("ID") + "'><img class='Avatar' src='");
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
        <div class="SearchBar">
            <form action="search.jsp" method="POST">
                <input type="text" name="name">
                <button type="submit"><img src="img/search.svg" alt="搜索"></button>
            </form>
        </div>
    </div>
    <%String name=new String(request.getParameter("name").getBytes("ISO-8859-1"),"UTF-8");%>
    <div class="Empty"></div>
    <div class="Searchtitle">
        <h2><%out.println(name);%>的搜索结果</h2>
    </div>
    <div class="Content">
        <sql:setDataSource var="snapshot" driver="com.mysql.cj.jdbc.Driver"
             url="jdbc:mysql://localhost:3306/shoppingsite?serverTimezone=Asia/Shanghai&characterEncoding=utf-8"
             user="root"  password="admin"/>
        <sql:query dataSource="${snapshot}" var="result">
        SELECT * from goods where name like "%<%=name%>%";
        </sql:query>
        <table width="100%">
        <c:forEach var="row" items="${result.rows}">
        <tr>
            <div class="Commodity">
                <img src="${row.imgurl}">
                <div class="Text">
                    <h2><c:out value="${row.name}"/></h2>
                    <div class="Price">
                        <c:out value="${row.price}"/>
                        <c:if test="${row.discount != '1'}">
                            ×${row.discount}
                        </c:if>
                    </div>
                    <p>&emsp;&emsp;<c:out value="${row.introduction}"/></p>
                    <div class="Action">
                        <c:if test="${row.status == 1}">
                            剩余：<c:out value="${row.stock}"/>&emsp;
                            <a href='buy.jsp?ID=${row.ID}'><b>购买</b></a>
                        </c:if>
                        <c:if test="${row.status == 0}">
                            已下架
                        </c:if>
                    </div>
                </div>
            </div>
        </tr>
        </c:forEach>
        </table>
    </div>
    <div class="Empty"></div>
    <div class="Nomore"><b>没有更多了……</b></div>
    <div class="Empty"></div>
    <footer class="Footer">
        Hello, World!
    </footer>
</body>
</html>