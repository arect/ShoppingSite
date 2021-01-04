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
    <title>购买</title>
</head>
<body>
    <div class="TopBar">
        <a href="index.jsp"><h1 class="Title">购物</h1></a>
        <%
            String ID_ = null;
            try {
                Cookie cookie = null;
                Cookie[] cookies = null; 
                cookies = request.getCookies();
                String KIND = null;
                if(cookies != null){
                    for (int i = 0; i < cookies.length; i++){
                        cookie = cookies[i];
                        if(cookie.getName().equals("ID")){
                            ID_ = cookie.getValue();
                        }
                        else if(cookie.getName().equals("KIND")){
                            KIND = cookie.getValue();
                        }
                    }
                    if(ID_ != null && KIND != null){
                        Class.forName("com.mysql.cj.jdbc.Driver");  ////驱动程序名
                        String url = "jdbc:mysql://localhost:3306/shoppingsite?serverTimezone=UTC&characterEncoding=utf-8"; //数据库名
                        String username = "root";  //数据库用户名
                        String password = "admin";  //数据库用户密码
                        Connection conn = DriverManager.getConnection(url, username, password);  //连接状态
                        if(conn != null){
                            Statement stmt = null; 
                            ResultSet rs = null;
                            String sql = "SELECT * FROM " + KIND + " WHERE ID = " + ID_;  //查询语句
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
                <input type="text" name="SEARCH">
                <button type="submit"><img src="img/search.svg" alt="搜索"></button>
            </form>
        </div>
    </div>
    <div class="Empty"></div>
    <%
        String goodsID = new String(request.getParameter("ID").getBytes("ISO-8859-1"),"UTF-8");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/shoppingsite?useSSL=false&serverTimezone=Asia/Shanghai";
            String user = "root";
            String password = "admin";
            Connection conn = DriverManager.getConnection(url, user, password);
            if(conn != null){
                Statement st = null;
                ResultSet rs = null;
                String sql = "SELECT * FROM goods WHERE ID = " + goodsID;  //查询语句
                st = conn.createStatement();
                rs = st.executeQuery(sql);
                if(rs.next()){
                    if(!rs.getString("stock").equals("0")){
                        String goodsName = rs.getString("name");
                        String sellerID = rs.getString("seller_id");
                        sql = "SELECT price*discount AS price_ FROM goods WHERE ID = " + goodsID;
                        rs = st.executeQuery(sql);
                        rs.next();
                        String price = rs.getString("price_");
                        String status = "等待发货";
                        sql = "SELECT MAX(ID) + 1 AS max_ FROM orders";
                        rs = st.executeQuery(sql);
                        rs.next();
                        String max_ = rs.getString("max_");
                        sql="INSERT INTO orders(name,goods_id,buyer_id,seller_id,price,time,ID,remark,status) values('" + goodsName + "','" + goodsID +"','" + ID_ + "','" + sellerID + "','" + price + "',NOW(),'" + max_ + "','无','" + status + "')";
                        if(st.executeUpdate(sql) == 1){
                            sql = "UPDATE goods SET stock = stock - 1 WHERE ID = " + goodsID;
                            if(st.executeUpdate(sql) == 1){
                                sql = "SELECT * FROM goods WHERE ID = " + goodsID;
                                rs = st.executeQuery(sql);
                                rs.next();
                                out.print("<div class='Searchtitle'><h2>感谢您的购买</h2></div>");
                                out.print("<div class='Commodity'>");
                                out.print("<img src='" + rs.getString("imgurl") + "'>");
                                out.print("<div class='Text'>");
                                out.print("<h3>" + goodsName + "</h3>");
                                sql = "SELECT * FROM orders WHERE ID = " + max_;
                                rs = st.executeQuery(sql);
                                rs.next();
                                out.print("<div class='Price'>支付：" + rs.getString("price") + "元</div>");
                                sql = "SELECT * FROM goods WHERE ID = " + goodsID;
                                rs = st.executeQuery(sql);
                                rs.next();
                                out.print("<p>&emsp;&emsp;" + rs.getString("introduction") + "</p>");
                                out.print("<div class='Action'><a href='receipt.jsp?orderID=" + max_ + "'><b>确认收货</b></a>&emsp;<a href='asker.jsp'><b>联系客服</b></a></div>");
                                out.print("</div></div>");
                            }
                        }
                    }
                    else{
                        sql = "UPDATE goods SET status = 0 WHERE ID = " + goodsID;
                        st.executeUpdate(sql);
                        out.print("<div class='Empty'></div><div class='Searchtitle'>");
                        out.print("<h2>商品已经售罄</h2>");
                        out.print("<p style='text-align: left; color: #888888;'>先去看看别的商品吧o(TヘTo)</p></div>");
                        out.print("<div class='Empty'></div><div class='Empty'></div>");
                    }
                }
                else{
                    out.print("未知错误");
                }
            }
        }catch (SQLException e) {
            out.print(e);
        }
    %>
    <footer class="Footer">
        Hello, World!
    </footer>
</body>
</html>