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

 String SQL = "SELECT * FROM (customer JOIN ordersummary ON customer.customerId=ordersummary.customerId) JOIN orderproduct ON orderproduct.orderId=ordersummary.orderId";
 ResultSet rst = stmt.executeQuery(SQL);

 // Display items in each order in a table
 out.println("<style>table,th,td { border: 1px solid black;}</style>");
 

int lastOrdId = -1;
while(rst.next()){
	if(lastOrdId != rst.getInt("orderId") ){
		out.println("<table><tr><th>Order Id</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
		out.println("<tr><td>"+rst.getString("orderId")+"</td><td>"+rst.getString("customerId")+"</td><td>"+rst.getString("firstName")+" "+rst.getString("lastName")+"</td><td>$"+rst.getString("totalAmount")+"</td></tr>");
		Statement stmt2 = con.createStatement();
		String SQL2 = "SELECT * FROM  orderproduct WHERE orderId= ?";
		PreparedStatement pstmt = con.prepareStatement(SQL2);
		pstmt.setInt(1,rst.getInt("orderId"));
		ResultSet rst2 = pstmt.executeQuery();
		out.println("<tr><th colspan=\"2\">Product Id</th><th>Quantity</th><th>Price</th></tr>");
		while(rst2.next()){
			out.println("<tr><td colspan=\"2\">"+rst2.getString("productId")+"</td><td>"+rst2.getString("quantity")+"</td>"+"<td>$"+rst2.getBigDecimal("price")+"</td></tr>");
		}
		out.println("</table>");
		
		lastOrdId = rst.getInt("orderId");
		
	}

}









// Connection automatically closed

 } catch(SQLException ex) {out.println(ex);}
 %>


</body>
</html>

