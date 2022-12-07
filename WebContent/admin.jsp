<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="java.io.File" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%

// Print out total order amount by day
String sql = "select year(orderDate), month(orderDate), day(orderDate), SUM(totalAmount) FROM OrderSummary GROUP BY year(orderDate), month(orderDate), day(orderDate)";

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

try 
{	
	out.println("<h3>Administrator Sales Report by Day</h3>");
	
	getConnection();
	Statement stmt = con.createStatement(); 
	stmt.execute("USE orders");

	ResultSet rst = con.createStatement().executeQuery(sql);		
	out.println("<table class=\"table\" border=\"1\">");
	out.println("<tr><th>Order Date</th><th>Total Order Amount</th>");	

	while (rst.next())
	{
		out.println("<tr><td>"+rst.getString(1)+"-"+rst.getString(2)+"-"+rst.getString(3)+"</td><td>"+currFormat.format(rst.getDouble(4))+"</td></tr>");
	}
	out.println("</table>");		
}
catch (SQLException ex) 
{ 	out.println(ex); 
}
finally
{	
	closeConnection();	
}
%>

<h2>Reload Database</h2>
<form method="get" action="admin.jsp"><input type="submit" value="Reload" name="submit"></form>

<%
if (request.getParameter("submit") != null) {
	out.print("<h1>Connecting to database.</h1><br><br>");

	getConnection();
			
	String fileName = "/usr/local/tomcat/webapps/shop/ddl/orderdb_sql.ddl";
	
	try
	{
		// Create statement
		Statement stmt = con.createStatement();
		
		Scanner scanner = new Scanner(new File(fileName));
		// Read commands separated by ;
		scanner.useDelimiter(";");
		while (scanner.hasNext())
		{
			String command = scanner.next();
			if (command.trim().equals("") || command.trim().equals("go"))
				continue;
			// out.print(command+"<br>");        // Uncomment if want to see commands executed
			try
			{
				stmt.execute(command);
			}
			catch (Exception e)
			{	// Keep running on exception.  This is mostly for DROP TABLE if table does not exist.
				out.println(e+"<br>");
			}
		}	 
		scanner.close();
		
		out.print("<br><br><h1>Database loaded.</h1>");
	}
	catch (Exception e)
	{
		out.print(e);
	}  
}

%>

<h2><a href="warehouse.jsp">View Warehouses</a></h2>
</body>
</html>

</body>
</html>

