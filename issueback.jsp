<%@ page language="java" import="java.util.*" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<link href="css/style.css" rel="stylesheet" type="text/css" id="STYLE" />
<title>新增商品</title>
</head>
<body>
    <div class="TopBar">
        <a href="index.jsp"><h1 class="Title">购物</h1></a>
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
                            rs.close();
                            stmt.close();
                            conn.close();
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
            String driver="com.mysql.cj.jdbc.Driver";
            String url="jdbc:mysql://127.0.0.1:3306/shoppingsite?&useSSL=false&serverTimezone=Asia/Shanghai";
            String user="root";
            String password="admin";
            request.setCharacterEncoding("UTF-8");
            String name=request.getParameter("COM-NAME");
            String stock=request.getParameter("AMOUNT");
            String imgurl=request.getParameter("IMG-LINK");
            String introduction=request.getParameter("INTRODUCTION");
            String price=request.getParameter("PRICE");
            try{
                Class.forName(driver);
                ResultSet rs = null;
                Connection conn = DriverManager.getConnection(url,user,password);
                Statement st = conn.createStatement();
                rs = st.executeQuery("select max(ID)+1 AS max_ from goods");
                String ID_ = rs.getString("max_");
                rs.next();
                rs.close();
                String sql = "INSERT INTO goods(name, ID, price, seller_id, imgurl, introduction, stock, discount, status) values('"+ name +"', '" + ID_ + "', '" + price + "', '" + ID + "', '" + imgurl + "', '" + introduction + "', '" + stock + "', '1', '1')";
                st.executeUpdate(sql);
                conn.close();
                out.println("插入成功！");
            }catch(ClassNotFoundException e){
                out.println("未找到驱动！");
                e.printStackTrace();
            }catch(SQLException e){
                out.println("未找到数据库！");
                e.printStackTrace();
            }catch(Exception e){
                out.println("失败！");
                e.printStackTrace();
            }    
        %>
    </div>
    <div class="Empty"></div>
    <div class="Issue">
        <h2>发布成功！</h2>
        <form action="issue.jsp" method="POST">
            <h3>名称</h3>
            <input class="Input-short" type="text" name="COM-NAME" value="<%=name %>" readonly>
            <h3>数量</h3>
            <input class="Input-short" type="text" name="AMOUNT" value="<%=stock %>" readonly>
            <h3>图片链接</h3>
            <input class="Input-long" type="text" name="IMG-LINK" value="<%=imgurl %>" readonly>
            <h3>介绍</h3>
            <input class="Input-long" type="text" name="INTRODUCTION" value="<%=introduction %>" readonly>
            <h3>定价</h3>
            <input class="Input-short" type="text" name="PRICE" value="<%=price %>" readonly>
            <a href="seller.jsp" style="float:right"><b>返回卖家页面</b></a>
        </form>
    </div>
    <footer class="Footer">
        Hello, World!
    </footer>
</body>
</html>