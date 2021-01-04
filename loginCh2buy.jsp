<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@page import="java.sql.*" %>  <%--导入java.sql包--%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <link href="css/style.css" rel="stylesheet" type="text/css" id="STYLE" />
    <title>登入页面</title>
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
<%
    request.setCharacterEncoding("utf-8");
    String name=request.getParameter("COUNT");
    String pwd=request.getParameter("PASSWORD");
    String goodsID = request.getParameter("GOODSID");
    boolean flag = false;
    String ID_ = null;
    String KIND_ = null;
    Statement st = null; 
    ResultSet rs = null;
    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/shoppingsite?useSSL=false&serverTimezone=Asia/Shanghai";
        String user = "root";
        String password = "admin";
        conn = DriverManager.getConnection(url, user, password);
        if(conn != null){
            String sql = "SELECT * FROM admin WHERE nickname = '" + name + "' AND password = '" + pwd + "'";  //查询语句
            st = conn.createStatement();
            rs = st.executeQuery(sql);
            if(rs.next()){
                ID_ = rs.getString("ID");
                KIND_ = "admin";
                flag=true;
            }
            else{
                sql = "SELECT * FROM seller WHERE nickname = '" + name + "' AND password = '" + pwd + "'";  //查询语句
                st = conn.createStatement();
                rs = st.executeQuery(sql);
                if(rs.next()){
                    ID_ = rs.getString("ID");
                    KIND_ = "seller";
                    flag=true;
                }
                else{
                    sql = "SELECT * FROM buyer WHERE nickname = '" + name + "' AND password = '" + pwd + "'";  //查询语句
                    st = conn.createStatement();
                    rs = st.executeQuery(sql);
                    if(rs.next()){
                        ID_ = rs.getString("ID");
                        KIND_ = "buyer";
                        flag=true;
                    }
                }
            }
        }
    }catch (SQLException e) {
        e.printStackTrace();
    }
    finally{
        if(rs!=null){
            rs.close();
        }
        if(st!=null){
            st.close();
        }
        if(conn!=null){
            conn.close();
        }
    }
    if(flag){
        Cookie ID = new Cookie("ID", ID_);
        Cookie KIND = new Cookie("KIND", KIND_);
        response.addCookie(ID);
        response.addCookie(KIND);
        response.sendRedirect("buy.jsp?ID=" + goodsID);
    }
    else{
        out.print("<div class='Empty'></div>");
        out.print("<div class='Empty'></div>");
        out.print("<script>alert('密码错误');window.history.back(-1);</script>");
    }
%>
</body>
</html>