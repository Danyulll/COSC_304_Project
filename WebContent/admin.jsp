<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

<%@ include file="jdbc.jsp"%>
<%@ include file="auth.jsp"%>
<%@ page import="java.util.Scanner" %>
<%@ page import="java.io.File" %>
<h2> Administrator Sales Report by Day</h2>

<%
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";
try (Connection con = DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement(); )
	{
		//String SQL = "SELECT shipmentDate, SUM(totalAmount) AS total FROM ((shipment JOIN productinventory ON shipment.warehouseId = productinventory.warehouseId) JOIN orderproduct ON productinventory.productId = orderproduct.productId) JOIN ordersummary ON orderproduct.orderId = ordersummary.orderId  GROUP BY shipmentDate";
        String SQL = "SELECT shipmentDate, SUM(totalAmount) total FROM shipment S JOIN orderSummary OS ON S.orderId=OS.orderId GROUP BY shipmentDate";
		ResultSet rst = stmt.executeQuery(SQL);

        // Display items in each order in a table
        out.println("<style>table,th,td { border: 1px solid black;}</style>");
        out.println("<table><tr><th>Order Date</th><th>Total Order Amount</th></tr>");
        while(rst.next()){
            out.println("<tr><td>" + rst.getDate("shipmentDate") + "</td><td>$" + rst.getBigDecimal("total") + "</td></tr>");
        }   
        out.println("</table>");

	} 
	catch(SQLException ex) {
		out.println(ex);
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

	Connection con = DriverManager.getConnection(url, uid, pw);
			
	String fileName = "/usr/local/tomcat/webapps/shop/orderdb_sql.ddl";
	
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
			if (command.trim().equals(""))
				continue;
			// out.print(command);        // Uncomment if want to see commands executed
			try
			{
				stmt.execute(command);
			}
			catch (Exception e)
			{	// Keep running on exception.  This is mostly for DROP TABLE if table does not exist.
				out.print(e);
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

</body>
</html>