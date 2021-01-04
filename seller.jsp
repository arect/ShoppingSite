<%@ page language="java" import="java.util.*" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<!DOCTYPE html>
<html>
<head>
    <link href="css/style.css" rel="stylesheet" type="text/css" id="STYLE" />
    <title>卖家页面</title>
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
    <div class="Profile">
        <%
            String ID = null;
            try {
                Cookie cookie = null;
                Cookie[] cookies = null; 
                cookies = request.getCookies();
                String KIND = null;
                if(cookies != null){
                    for (int i = 0; i < cookies.length; i++){
                        cookie = cookies[i];
                        if(cookie.getName().equals("ID")){
                            ID = cookie.getValue();
                        }
                        else if(cookie.getName().equals("KIND")){
                            KIND = cookie.getValue();
                            if(!KIND.equals("seller")){
                                response.sendRedirect(KIND+".jsp");
                            }
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
                                out.print("<img class='Avatar-big' src='");
                                out.print(rs.getString("avatarurl") + "' alt='头像'>"); //将查询结果输出
                                out.print("<h2>" + rs.getString("nickname") + "</h2>");
                                out.print("ID:" + ID);
                                out.print("<br>");
                                out.print("TEL:" + rs.getString("phonenumber"));
                            }
                        }
                        else{
                            out.print("<img class='Avatar-big' src='img/11.png'>");
                        }
                    }else{
                        out.print("<img class='Avatar-big' src='img/11.png'>");
                    }
                }
                else{
                    out.print("<img class='Avatar-big' src='img/11.png'>");
                }
            }catch (Exception e) {
                out.print("<img class='Avatar-big' src='img/11.png'>");  
            }
        %>
        <br>
        <div class="Quit"><a href="quit.jsp">退出登入</a></div>
    </div>
    <hr class="Hr">
    <div class="ProfilePageBox">
        <h2>收到订单</h2>
        <sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver" url="jdbc:mysql://localhost/shoppingsite?&useSSL=false&serverTimezone=Asia/Shanghai" user="root"  password="admin"/>
        <sql:query dataSource="${snapshot}" var="result">
            SELECT * from orders where seller_id= ? order by status desc;
            <sql:param value= "<%= ID%>"></sql:param><%--value的值应该是卖家的id号--%>
        </sql:query>
        <c:forEach var="row" items="${result.rows}">
        <div class="Order">
            <div class="Text-odr">
                <b><c:out value="${row.name}"/></b>
                <div>
                    订单ID：<c:out value="${row.ID}"/>
                    &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
                    下单时间：<c:out value="${row.time}"/>
                    <br>
                    状态：<c:out value="${row.status}"/>
                    &emsp;&emsp;&emsp;&emsp;
                    已支付：<c:out value="${row.price}"/>元
                </div>
            </div>
            <div class="Action-adm">
                <c:if test="${row.status=='等待发货'}">
                    <a href="ship.jsp?ID=${row.ID}"><b>发货</b></a>
                    &emsp;
                </c:if>
                <a href="asker.jsp"><b>联系买家</b></a>
            </div>
        </div>
        </c:forEach>
    </div>
    <hr class="Hr">
    <div class="ProfilePageBox">
        <h2>已发布</h2>
        <div class="Addmem">
            <a href="issue.jsp"><b>发布新商品</b></a>
        </div>
        <sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver" url="jdbc:mysql://localhost/shoppingsite?&useSSL=false&serverTimezone=Asia/Shanghai" user="root"  password="admin"/>
        <sql:query dataSource="${snapshot}" var="result">
            SELECT * from goods where seller_id= ? order by status desc;
            <sql:param value= "<%= ID%>"></sql:param><%--value的值应该是卖家的id号--%>
        </sql:query>
        <c:forEach var="row" items="${result.rows}">
        <div class="Commodity">
            <img src=${row.imgurl}>
            <div class="Text">
                <h3><c:out value="${row.name}"/></h3>
                <br>
                <div class="Price">定价：<c:out value="${row.price}"/></div>
                <p>&emsp;&emsp;<c:out value="${row.introduction}"/></p>
                <div class="Action">
                   <c:if test="${row.status==1 }">
                           <a href="
                        <c:url value="Shelf.jsp">
                        <c:param name="userID" value="${row.ID}"></c:param>
                        <c:param name="istatus" value="${row.status}"></c:param>
                        </c:url>
                    "><b>下架</b></a>
                    &emsp;
                   </c:if>
                    <c:if test="${row.status==0 }">
                        <a href="
                        <c:url value="Shelf.jsp">
                        <c:param name="userID" value="${row.ID}"></c:param>
                        <c:param name="istatus" value="${row.status}"></c:param>
                        </c:url>
                    "><b>上架</b></a>
                    &emsp;
                    </c:if>
                    <a href="
                        <c:url value="modify.jsp">
                        <c:param name="userID" value="${row.ID}"></c:param>
                        </c:url>
                    "><b>修改</b></a>
                </div>
            </div>
        </div>
        </c:forEach>
    </div>
    <footer class="Footer">
        Hello, World!
    </footer>

</body>
</html>