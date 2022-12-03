<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>User Account Page</title>
</head>
<body>

    <%@ include file="auth.jsp"%>
    <%@ page import="java.text.NumberFormat" %>
    <%@ include file="jdbc.jsp" %>
    <h3><p1 style ="font-family:Courier New">Account Information:</h3></p1>
    <%
    try(Connection con = DriverManager.getConnection(url, uid, pw);){
        String SQL = "SELECT customerId,firstName,lastName,email,phonenum,address,city,state,postalCode,country,userid FROM customer WHERE userid = ?";
        PreparedStatement pst = null;
        ResultSet rst = null;
        String username = (String)session.getAttribute("authenticatedUser");
        boolean hasId = (username != null && !username.equals(""));
        if(hasId){
            pst = con.prepareStatement(SQL); 
            pst.setString(1, username);
            rst = pst.executeQuery();
            out.println("<style>table,th,td { border: 1px solid black;}</style>");
            while(rst.next())
            {
                out.println("<table><tr><th>Id</th><td>" + rst.getInt("customerId") + "</td></tr>");
                out.println("<tr><th>First Name</th><td>" + rst.getString("firstName") + "</td></tr>");
                out.println("<tr><th>Last Name</th><td>" + rst.getString("lastName") + "</td></tr>");
                out.println("<tr><th>Email</th><td>" + rst.getString("email") + "</td></tr>");
                out.println("<tr><th>Phone</th><td>" + rst.getString("phonenum") + "</td></tr>");
                out.println("<tr><th>Address</th><td>" + rst.getString("address") + "</td></tr>");
                out.println("<tr><th>City</th><td>" + rst.getString("city") + "</td></tr>");
                out.println("<tr><th>State</th><td>" + rst.getString("state") + "</td></tr>");
                out.println("<tr><th>Postal Code</th><td>" + rst.getString("postalCode") + "</td></tr>");
                out.println("<tr><th>Country</th><td>" + rst.getString("country") + "</td></tr>");
                out.println("<tr><th>User id</th><td>" + rst.getString("userid") + "</td></tr>");
            }
            out.println("</table>");
        }
    } catch (SQLException ex) { out.println(ex); }
    finally{closeConnection();}

    %>
    <h3 align="left"><a href="editaccount.jsp">Edit Your Account</a></h3>
</body>