<%@ page language="java" import="java.util.*" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<%
    String driver="com.mysql.cj.jdbc.Driver";
    String url="jdbc:mysql://127.0.0.1:3306/shoppingsite?&useSSL=false&serverTimezone=Asia/Shanghai";
    String user="root";
    String password="admin";
    
    request.setCharacterEncoding("UTF-8");
    String ordersID=request.getParameter("ID");
    try{
        Class.forName(driver);
        Connection conn=DriverManager.getConnection(url,user,password);
        Statement st=conn.createStatement();
        String sql = "UPDATE orders SET status = '正在运送' WHERE ID = " + ordersID;
        st.executeUpdate(sql);
        st.close();
        conn.close();
        response.sendRedirect("seller.jsp");
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