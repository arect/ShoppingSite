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
    <%String goodsID=new String(request.getParameter("ID").getBytes("ISO-8859-1"),"UTF-8");%>
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
                        if(KIND.equals("buyer")){
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
                                response.sendRedirect("signin_jump.jsp?goodsID=" + goodsID);
                                out.print("<a href='signin.jsp'><img class='Avatar' src='img/11.png' alt='头像'></a>");
                            }
                        }else{
                            response.sendRedirect("signin_jump.jsp?goodsID=" + goodsID);
                        }
                    }else{
                        response.sendRedirect("signin_jump.jsp?goodsID=" + goodsID);
                        out.print("<a href='signin.jsp'><img class='Avatar' src='img/11.png' alt='头像'></a>");
                    }
                }
                else{
                    response.sendRedirect("signin_jump.jsp?goodsID=" + goodsID);
                    out.print("<a href='signin.jsp'><img class='Avatar' src='img/11.png' alt='头像'></a>");
                }
            }catch (Exception e) {
                response.sendRedirect("signin_jump.jsp?goodsID=" + goodsID);
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
    <div class="Empty"></div>
    <div class="Searchtitle">
        <h2>正在购买</h2>
    </div>
    <div class="Content">
        <sql:setDataSource var="snapshot" driver="com.mysql.cj.jdbc.Driver"
             url="jdbc:mysql://localhost:3306/shoppingsite?serverTimezone=Asia/Shanghai&characterEncoding=utf-8"
             user="root"  password="admin"/>
        <sql:query dataSource="${snapshot}" var="result">
        SELECT imgurl, name, introduction, ID, ROUND(price*discount, 2) AS price_ from goods where ID = "<%=goodsID%>";
        </sql:query>
        <table width="100%">
        <c:forEach var="row" items="${result.rows}">
        <tr>
            <div class="Commodity">
                <img src="${row.imgurl}">
                <div class="Text">
                    <h2><c:out value="${row.name}"/></h2>
                    <p>&emsp;&emsp;<c:out value="${row.introduction}"/></p>
                    <div class="Action"><a href='sure2buy.jsp?ID=${row.ID}'><b>支付<c:out value="${row.price_}"/>元</b></a>
                    </div>
                </div>
            </div>
        </tr>
        </c:forEach>
        </table>
    </div>
    <div class="Empty"></div>
    <div class="Empty"></div>
    <footer class="Footer">
        Hello, World!
    </footer>
</body>
</html>