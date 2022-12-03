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
<input type="text" name="productName" size="50" placeholder="Leave blank for all products">
<input type="submit" value="Submit"><input type="reset" value="Reset"> 
<select name="Category">
	<option>Any Category</option>
	<option>Beverages</option>
	<option>Condiments</option>
	<option>Dairy Products</option>
	<option>Produce</option>
	<option>Meat/Poultry</option>
	<option>Seafood</option>
	<option>Confections</option>
	<option>Grains/Cereals</option>
</select>
</form>


<%  
// Get product name to search for
String prodName = request.getParameter("productName");
String catName = request.getParameter("Category");
boolean hasCat = false;
if(catName != null){
 hasCat = !catName.equals("Any Category");
}

// Check that varaible is not null
	boolean hasProdName = prodName != null && !prodName.equals("");

 String h2 = (hasProdName)? "Products containing " + prodName : "All Products";
 
%>

<h2><p2 style ="font-family:Courier New"> <% if(hasCat==false){out.println(h2);}else{out.println(h2+ " in " + catName);}  %></h2></p2>

<% 

// Set currency format
NumberFormat currFormat = NumberFormat.getCurrencyInstance();


//Note: Forces loading of SQL Server driver
try{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e){
	out.println("ClassNotFoundException: " +e);
}

String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";


 if(!hasProdName && !hasCat){
	 try( Connection con = DriverManager.getConnection(url, uid, pw); Statement stmt = con.createStatement(); ){
	String str = "SELECT productId,productName,productPrice FROM product";
	ResultSet rst = stmt.executeQuery(str);
	out.println("<style>table,th,td { border: 1px solid black;}</style>");
	out.println("<table><tr><th></th><th>Product Name</th><th>Product Price</th>");

		while(rst.next()){
			out.println("<tr>"+"<td><a href=" + "\"" + "addcart.jsp?id="+ rst.getString("productId") + "&name=" + rst.getString("productName") + "&price="+rst.getString("productPrice") + "\"" + ">Add to Cart</a></td>" + "<td>" + "<a href=\"productInfo.jsp?id=" + rst.getString("productId") +"\">" + rst.getString("productName") + "</a>" + "</td>" + "<td> $" + rst.getBigDecimal("productPrice") + "</td>"+"</tr>");
		}
	}catch (SQLException ex) { out.println(ex); }
	   out.println("</table>");
} else if(hasProdName && !hasCat){
	try(Connection con = DriverManager.getConnection(url, uid, pw);){
		// Create query
		String SQL = "SELECT productId,productName,productPrice FROM product WHERE productName LIKE ?";

		PreparedStatement pst=null;
		ResultSet rst = null;

		// Format LIKE
		prodName = "%"+prodName+"%";
	
		// Create prepareStatement and insert formatted varaible
		pst = con.prepareStatement(SQL); 
		pst.setString(1, prodName);

		// Execute the query
		rst = pst.executeQuery();

	
		out.println("<style>table,th,td { border: 1px solid black;}</style>");
		out.println("<table><tr><th></th><th>Product Name</th><th>Product Price</th>");

		// Traverse results
		while(rst.next()){
		
		out.println("<tr>"+"<td><a href=" + "\"" + "addcart.jsp?id="+ rst.getString("productId") + "&name=" + rst.getString("productName") + "&price="+rst.getString("productPrice") + "\"" + ">Add to Cart</a></td>" + "<td>" + rst.getString("productName") + "</td>" + "<td> $" + rst.getBigDecimal("productPrice") + "</td>"+"</tr>");
		}
	}catch (SQLException ex) { out.println(ex); }
	}else if(hasProdName && hasCat){
	try(Connection con = DriverManager.getConnection(url, uid, pw);){
		// Create query
		String SQL = "SELECT productId,productName,productPrice FROM product JOIN category ON category.categoryId = product.categoryId WHERE productName LIKE ? AND categoryName = ?";

		PreparedStatement pst=null;
		ResultSet rst = null;

		// If varaible is not null run the query
		
			// Format LIKE
			prodName = "%"+prodName+"%";
	
		// Create prepareStatement and insert formatted varaible
		pst = con.prepareStatement(SQL); 
		pst.setString(1, prodName);
		pst.setString(2,catName);

		// Execute the query
		rst = pst.executeQuery();

	
		out.println("<style>table,th,td { border: 1px solid black;}</style>");
		out.println("<table><tr><th></th><th>Product Name</th><th>Product Price</th>");

		// Traverse results
		while(rst.next()){
		
		out.println("<tr>"+"<td><a href=" + "\"" + "addcart.jsp?id="+ rst.getString("productId") + "&name=" + rst.getString("productName") + "&price="+rst.getString("productPrice") + "\"" + ">Add to Cart</a></td>" + "<td>" + rst.getString("productName") + "</td>" + "<td> $" + rst.getBigDecimal("productPrice") + "</td>"+"</tr>");
		}
   
} catch (SQLException ex) { out.println(ex); }
}else{
	//no product name and a category
	try(Connection con = DriverManager.getConnection(url, uid, pw);){
		// Create query
		String SQL = "SELECT productId,productName,productPrice FROM product JOIN category ON category.categoryId = product.categoryId WHERE categoryName = ?";

		PreparedStatement pst=null;
		ResultSet rst = null;
	
		// Create prepareStatement and insert formatted varaible
		pst = con.prepareStatement(SQL); 
		pst.setString(1,catName);

		// Execute the query
		rst = pst.executeQuery();

	
		out.println("<style>table,th,td { border: 1px solid black;}</style>");
		out.println("<table><tr><th></th><th>Product Name</th><th>Product Price</th>");

		// Traverse results
		while(rst.next()){
		
		out.println("<tr>"+"<td><a href=" + "\"" + "addcart.jsp?id="+ rst.getString("productId") + "&name=" + rst.getString("productName") + "&price="+rst.getString("productPrice") + "\"" + ">Add to Cart</a></td>" + "<td>" + rst.getString("productName") + "</td>" + "<td> $" + rst.getBigDecimal("productPrice") + "</td>"+"</tr>");
		}
   
} catch (SQLException ex) { out.println(ex); }
}


%>
<h2>Reviews</h2>
<%
try(Connection con = DriverManager.getConnection(url, uid, pw);){
	// Create query
	String SQL = "SELECT * FROM review  WHERE productId = ?";

	PreparedStatement pst=null;
	ResultSet rst = null;

	// Create prepareStatement and insert formatted varaible
	pst = con.prepareStatement(SQL); 
	pst.setString(1,catName);

	// Execute the query
	rst = pst.executeQuery();


	out.println("<style>table,th,td { border: 1px solid black;}</style>");
	out.println("<table><tr><th></th><th>Product Name</th><th>Product Price</th>");

	// Traverse results
	while(rst.next()){
	
	out.println("<tr>"+"<td><a href=" + "\"" + "addcart.jsp?id="+ rst.getString("productId") + "&name=" + rst.getString("productName") + "&price="+rst.getString("productPrice") + "\"" + ">Add to Cart</a></td>" + "<td>" + rst.getString("productName") + "</td>" + "<td> $" + rst.getBigDecimal("productPrice") + "</td>"+"</tr>");
	}

} catch (SQLException ex) { out.println(ex); }
%>
</body>
</html>