<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@page import="java.sql.*" %>  <%--导入java.sql包--%>
<%
    String driver="com.mysql.cj.jdbc.Driver";
    String url="jdbc:mysql://127.0.0.1:3306/shoppingsite?&useSSL=false&serverTimezone=Asia/Shanghai";
    String user="root";
    String password="admin";
    
    request.setCharacterEncoding("UTF-8");
    String goodsID=request.getParameter("GOODSID");
    String discount=request.getParameter("DISCOUNT");
    try{
        Class.forName(driver);
        Connection conn=DriverManager.getConnection(url,user,password);
        Statement st=conn.createStatement();
        String sql = "UPDATE goods SET discount = 1";
        if(goodsID.equals("0")){
            sql="UPDATE goods SET discount = " + discount;
        }
        else{
            sql="UPDATE goods SET discount = " + discount + "WHERE ID = " + goodsID;
        }
        st.executeUpdate(sql);
        st.close();
        conn.close();
        response.sendRedirect("admin.jsp");
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