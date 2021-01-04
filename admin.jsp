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
    <title>管理员页面</title>
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
                            if(!KIND.equals("admin")){
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
        <div>
            <h2>现有成员</h2>
            <div class="Addmem">
                <a href="register.jsp"><b>添加用户</b></a>
            </div>
        </div>
        <sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver" url="jdbc:mysql://localhost/shoppingsite?&useSSL=false&serverTimezone=Asia/Shanghai" user="root"  password="admin"/>
        <sql:query dataSource="${snapshot}" var="result">
            SELECT * FROM buyer;
        </sql:query>
        <c:forEach var="row" items="${result.rows}">
        <div class="Member">
            <img src="${row.avatarurl}">
            <div class="Text-mem">
                <b>${row.nickname}</b>&emsp;ID:${row.ID}&emsp;买家
                <br>
                <br>
                TEL:${row.phonenumber}
            </div>
            <div class="Action-adm">
                <a href="deleteMem.jsp?ID=${row.ID}"><b>删除</b></a>
            </div>
        </div>
        </c:forEach>
    </div>
    <hr class="Hr">
    <div class="ProfilePageBox">
        <h2>全部订单</h2>
        <sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver" url="jdbc:mysql://localhost/shoppingsite?&useSSL=false&serverTimezone=Asia/Shanghai" user="root"  password="admin"/>
        <sql:query dataSource="${snapshot}" var="result">
            SELECT imgurl, orders.ID, buyer_id, orders.seller_id, time FROM orders LEFT JOIN goods ON orders.goods_id = goods.ID
        </sql:query>
        <c:forEach var="row" items="${result.rows}">
            <div class="Order">
                <img src="${row.imgurl}">
                <div class="Text-odr">
                    订单ID:${row.ID}&emsp;买家ID:${row.buyer_id}&emsp;卖家ID:${row.seller_id}
                    <br><br>
                    ${row.time}
                </div>
                <div class="Action-adm">
                    <a href="deleteOdr.jsp?ID=${row.ID}"><b>撤销</b></a>
                </div>
            </div>
        </c:forEach>
    </div>
    <hr class="Hr">
    <div class="ProfilePageBox">
        <h2>促销设置</h2>
        <div class="Discount">
            <form action="discount.jsp" method="POST">
                <select name="GOODSID">
                    <option value="0">全部商品</option>
                    <sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver" url="jdbc:mysql://localhost/shoppingsite?&useSSL=false&serverTimezone=Asia/Shanghai" user="root"  password="admin"/>
                    <sql:query dataSource="${snapshot}" var="result">
                        SELECT * FROM goods;
                    </sql:query>
                    <c:forEach var="row" items="${result.rows}">
                        <option value="${row.ID}">${row.name}</option>
                    </c:forEach>
                    </select>
                <input type="text" name="DISCOUNT">
                <button type="submit" onclick="return myCheck()"><b>设置折扣</b></button>
            </form>
        </div>
    </div>
    <footer class="Footer">
        Hello, World!
    </footer>
</body>
</html>