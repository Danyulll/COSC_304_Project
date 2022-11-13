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
</form>

<%  
// Get product name to search for
String prodName = request.getParameter("productName");

// Check that varaible is not null
	boolean hasProdName = prodName != null && !prodName.equals("");

 String h2 = (hasProdName)? "Products containing " + prodName : "All Products";
%>

<h2><p2 style ="font-family:Courier New"> <% out.println(h2); %></h2></p2>

<% 

// Set currency format
NumberFormat currFormat = NumberFormat.getCurrencyInstance();


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
 

 if(!hasProdName){
 try(
Connection con = DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement(); ){
String str = "SELECT productId,productName,productPrice FROM product";
ResultSet rst = stmt.executeQuery(str);
out.println("<table><tr><th></th><th>Product Name</th><th>Product Price</th>");
	
	while(rst.next()){
		out.println("<tr>"+"<td><a href=" + "\"" + "addcart.jsp?id="+ rst.getString("productId") + "&name=" + rst.getString("productName") + "&price="+rst.getString("productPrice") + "\"" + ">Add to Cart</a></td>" + "<td>" + rst.getString("productName") + "</td>" + "<td> $" + rst.getBigDecimal("productPrice") + "</td>"+"</tr>");
	}
   out.println("</table>");

}}else{

try(Connection con = DriverManager.getConnection(url, uid, pw);){
	// Create query
	String SQL = "SELECT productId,productName,productPrice FROM product WHERE productName LIKE ?";

	PreparedStatement pst=null;
	ResultSet rst = null;

	// If varaible is not null run the query
	if(hasProdName){
		// Format LIKE
		prodName = "%"+prodName+"%";
		
		// Create prepareStatement and insert formatted varaible
		pst = con.prepareStatement(SQL); 
		pst.setString(1, prodName);

		// Execute the query
		rst = pst.executeQuery();

		

		out.println("<table><tr><th></th><th>Product Name</th><th>Product Price</th>");

		// Traverse results
		while(rst.next()){
			out.println("<tr>"+"<td>Add to Cart</td>" + "<td>" + rst.getString("productName")  + "</td>" + "<td> $" + rst.getBigDecimal("productPrice") + "</td>"+"</tr>" );
			
		}

	}

	// For each product create a link of the form
	


} catch (SQLException ex) { out.println(ex); }}


%>

</body>
</html>