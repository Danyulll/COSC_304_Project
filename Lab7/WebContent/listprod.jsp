<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Hydrobottle</title>
</head>
<body>

<h1><p1 style ="font-family:Courier New">Search for the products you want to buy:</h1></p1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
<h2><p2 style ="font-family:Courier New">All Products</h2></p2>
</form>

<% // Get product name to search for
String name = request.getParameter("productName");	
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
 String uid = "SA";
 String pw = "YourStrong@Passw0rd";
 
 try(
Connection con = DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement(); ){
String str = "SELECT productName,productPrice FROM product";
ResultSet rst = stmt.executeQuery(str);
out.println("<table><tr><th></th><th>Product Name</th><th>Product Price</th>");
	
	while(rst.next()){
		out.println("<tr>"+"<td>Add to Cart</td>" + "<td>" + rst.getString("productName") + "</td>" + "<td> $" + rst.getBigDecimal("productPrice") + "</td>"+"</tr>");
	   
	}
   out.println("</table>");

}
// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

// Make the connection

// Print out the ResultSet

// For each product create a link of the form
//addcart.jsp?id=productId&name=productName&price=productPrice
// Close connection

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
%>

</body>
</html>