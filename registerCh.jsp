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
    <meta charset="UTF-8">
    <title>注册</title>
</head>
<body>
<%
    request.setCharacterEncoding("utf-8");
    String name=request.getParameter("NICKNAME");
    String phone=request.getParameter("TELPHONE");
    String pwd=request.getParameter("PASSWORD");
    String pwd1=request.getParameter("PASSWORD-AGAIN");
    String type=request.getParameter("IDENTITY");
    String avatar=request.getParameter("AVATAR");
    String nextID = null;
    ArrayList<String> array=new ArrayList<>();
    ResultSet rs=null;
    Connection conn=null;
    Statement st=null;
    Statement st1=null;
    int count=0;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url="jdbc:mysql://localhost:3306/shoppingsite?useSSL=false&serverTimezone=Asia/Shanghai";
        String user="root";
        String password="admin";
        conn = DriverManager.getConnection(url, user, password);
        String sql1 = null;
        sql1 = "select nickname from " + type;
        st = conn.createStatement();
        st1 = conn.createStatement();
        rs = st1.executeQuery(sql1);
        while(rs.next())
        {
            String sname=rs.getString("nickname");
            array.add(sname);
        }
        boolean same = true;
        for(String s:array)
        {
            if(name.equals(s))
            {
                same = false;
            }
        }
        if(pwd.length()>=4&&pwd.equals(pwd1)&&same)
        {
            String sql=null;
            sql = "SELECT MAX(member_id)+1 AS max_ FROM member";
            rs = st.executeQuery(sql);
            rs.next();
            nextID = rs.getString("max_");
            if(type.equals("buyer"))
                sql="insert into buyer(ID,nickname,phonenumber,password,avatarurl) values('"+nextID+"','"+name+"','"+phone+"','"+pwd+"','"+avatar+"')";
            else if(type.equals("seller"))
                sql="insert into seller(ID,nickname,phonenumber,password) values('"+nextID+"','"+name+"','"+phone+"','"+pwd+"','"+avatar+"')";
            else if(type.equals("admin"))
                sql="insert into admin(ID,nickname,phonenumber,password) values('"+nextID+"','"+name+"','"+phone+"','"+pwd+"','"+avatar+"')";
            count=st.executeUpdate(sql);
        }    
    }
    catch (Exception e) {
        out.print(e);  
    }
    finally{
        if(rs!=null){
            rs.close();
        }
        if(st1!=null){
            st.close();
        }
        if(st!=null){
            st.close();
        }
        if(conn!=null){
            conn.close();
        }
    }
    if(count==1&&name.length()>=1&&pwd.length()>=4&&pwd.equals(pwd1)){
        Cookie ID = new Cookie("ID", nextID);
        Cookie KIND = new Cookie("KIND", type);
        response.addCookie(ID);
        response.addCookie(KIND);
        response.sendRedirect(type+".jsp");
    }
    else if(count==0){
        if(!pwd.equals(pwd1)){
%>
<a href="index.jsp"><font color="green" size="6px">再次输入密码不一致点此返回上一级</font></a>
<%
}
else
{
%>
<a href="index.jsp"><font color="green" size="6px">用户名重复或者用户名密码不符合要求点此返回上一级</font></a>
<%
        }

    }
%>
</body>
</html>