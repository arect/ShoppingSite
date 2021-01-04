<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@page import="java.sql.*" %>  <%--导入java.sql包--%>
<%String ordersID=new String(request.getParameter("ID").getBytes("ISO-8859-1"),"UTF-8");%>
<sql:setDataSource var="snapshot" driver="com.mysql.cj.jdbc.Driver"
    url="jdbc:mysql://localhost:3306/shoppingsite?serverTimezone=Asia/Shanghai&characterEncoding=utf-8"
    user="root"  password="admin"/>
    <sql:update dataSource="${snapshot}" var="result">
        UPDATE orders SET status = "订单完成" WHERE ID = <%= ordersID %>
    </sql:update>
<%response.sendRedirect("buyer.jsp");%>