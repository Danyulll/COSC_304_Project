<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order List</title>
</head>
<body>

<h1>Order List</h1>

 <%  

 // Server connection information

 String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
 String uid = "SA";
 String pw = "YourStrong@Passw0rd";
 
 // Try-catch for connection
 try(
 Connection con = DriverManager.getConnection(url, uid, pw);
 Statement stmt = con.createStatement(); ){

 // Select orders and their products

 String SQL = "SELECT ordersummary.orderId, productName, productPrice FROM (ordersummary JOIN orderproduct ON ordersummary.orderId = orderproduct.orderId) JOIN product ON product.productId = orderproduct.productId";
 ResultSet rst = stmt.executeQuery(SQL);

 // Display items in each order in a table
 out.println("<table><tr><th>Order Id</th><th>Product Name</th><th>Product Price</th></tr>");
 while(rst.next()){
	 out.println("<tr>"+"<td>" +  rst.getString("orderId") + "</td>" + "<td>" + rst.getString("productName") + "</td>" + "<td> $" + rst.getBigDecimal("productPrice") + "</td>"+"</tr>");
	}
out.println("</table>");

// Connection automatically closed

 } catch(SQLException ex) {out.println(ex);}
 %>


</body>
</html>

