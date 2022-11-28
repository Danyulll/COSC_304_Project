<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

<%@ include file="jdbc.jsp"%>
<%@ include file="auth.jsp"%>
<h2> Administrator Sales Report by Day</h2>

<%
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";
try (Connection con = DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement(); )
	{
		String SQL = "SELECT shipmentDate, SUM(totalAmount) AS total FROM ((shipment JOIN productinventory ON shipment.warehouseId = productinventory.warehouseId) JOIN orderproduct ON productinventory.productId = orderproduct.productId) JOIN ordersummary ON orderproduct.orderId = ordersummary.orderId  GROUP BY shipmentDate";
        ResultSet rst = stmt.executeQuery(SQL);

        // Display items in each order in a table
        out.println("<style>table,th,td { border: 1px solid black;}</style>");
        out.println("<table><tr><th>Order Date</th><th>Total Order Amount</th></tr>");
        while(rst.next()){
            out.println("<tr><td>" + rst.getDate("shipmentDate") + "</td><td>" + rst.getBigDecimal("total") + "</td></tr>");
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

</body>
</html>