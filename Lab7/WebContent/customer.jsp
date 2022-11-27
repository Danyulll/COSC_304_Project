<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Customer Information</title>
</head>
<body>
    <%@ include file="auth.jsp"%>
    <%@ page import="java.text.NumberFormat" %>
    <%@ include file="jdbc.jsp" %>
<h1><p1 style ="font-family:Courier New">Search for customer by ID:</h1></p1>

<form method="get" action="customer.jsp">
<input type="text" name="customerId" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all customers)
</form>

<%  
// Get customer Id to search for
String id = request.getParameter("customerId");

// Check that variable is not null
	boolean hasId = id != null && !id.equals("");

 String h2 = (hasId)? "Customer ID: " + id : "All Customers";
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
 

 if(!hasId){
 try(
Connection con = DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement(); ){
String str = "SELECT customerId,firstName,lastName FROM customer";
ResultSet rst = stmt.executeQuery(str);
out.println("<style>table,th,td { border: 1px solid black;}</style>");
out.println("<table><tr><th>Id</th><th>First Name</th><th>Last Name</th></tr>");
	
    while(rst.next()){
        out.println("<tr>" + "<td>" + rst.getInt("customerId") + "</td>" + "<td>" + rst.getString("firstName") + "</td>" + "<td>" + rst.getString("lastName") + "</td>" + "</tr>");
    }
   out.println("</table>");

}}else{

try(Connection con = DriverManager.getConnection(url, uid, pw);){
	// Create query
	String SQL = "SELECT customerId,firstName,lastName,email,phonenum,address,city,state,postalCode,country,userid FROM customer WHERE customerId = ?";

	PreparedStatement pst = null;
	ResultSet rst = null;

	// If variable is not null run the query
	if(hasId){
		
		// Create prepareStatement and insert formatted variable
		pst = con.prepareStatement(SQL); 
		pst.setString(1, id);

		// Execute the query
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
} catch (SQLException ex) { out.println(ex); }}


%>

</body>
</html>