<%@ page language="java" import="java.util.*" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<link href="css/style.css" rel="stylesheet" type="text/css" id="STYLE" />
<title>修改成功</title>
</head>
<body>
    <%
        String driver="com.mysql.cj.jdbc.Driver";
        String url="jdbc:mysql://127.0.0.1:3306/shoppingsite?&useSSL=false&serverTimezone=Asia/Shanghai";
        String user="root";
        String password="admin";
        
        request.setCharacterEncoding("UTF-8");
        String name=request.getParameter("COM-NAME");
        int stock=Integer.parseInt(request.getParameter("AMOUNT"));
        String imgurl=request.getParameter("IMG-LINK");
        String introduction=request.getParameter("INTRODUCTION");
        String STATUS=request.getParameter("STATUS");
        float price=Float.parseFloat(request.getParameter("PRICE"));
        int UID=0;
        float discount=1;
        int status=1;
        String Yes="是";
        if(!Yes.equals(STATUS)){
            status=0;
        }
        try{
            Class.forName(driver);
            Connection conn=DriverManager.getConnection(url,user,password);
            Statement st=conn.createStatement();
            UID=Integer.parseInt(request.getParameter("ID"));
            String sql="update goods set name=?,price=?,imgurl=?,introduction=?,stock=?,discount=?,status=? where ID=?";
            PreparedStatement ps=conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setFloat(2, price);
            ps.setString(3, imgurl);
            ps.setString(4, introduction);
            ps.setInt(5, stock);
            ps.setFloat(6, discount);
            ps.setInt(7, status);
            ps.setInt(8,UID);
            ps.executeUpdate();
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
                        Connection conn = DriverManager.getConnection(url, user, password);  //连接状态
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
        <h2>修改成功！</h2>
        <form action="issue.jsp" method="POST">
            <h3>名称</h3>
            <input class="Input-short" type="text" name="COM-NAME" value=<%=name %> readonly>
            <h3>ID</h3>
            <input class="Input-short" type="text" name="ID" value=<%=UID %> readonly>
            <h3>数量</h3>
            <input class="Input-short" type="text" name="AMOUNT" value=<%=stock %> readonly>
            <h3>图片链接</h3>
            <input class="Input-long" type="text" name="IMG-LINK" value="<%=imgurl %>" readonly>
            <h3>介绍</h3>
            <input class="Input-long" type="text" name="INTRODUCTION" value="<%=introduction %>" readonly>
            <h3>定价</h3>
            <input class="Input-short" type="text" name="PRICE" value=<%=price %> readonly>
            <h3>上架/下架(1/0)</h3>
            <input class="Input-short" type="text" name="STATUS" value=<%=status %> readonly>
            <a href="seller.jsp" style="float:right"><b>返回卖家页面</b></a>
        </form>
    </div>
    <footer class="Footer">
        Hello, World!
    </footer>
</body>
</html>