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
try 
	{
		getConnection();
		String SQL = "SELECT shipmentDate, shipmentId FROM shipment";
        Statement stmt = con.createStatement();
        ResultSet rst = stmt.executeQuery(SQL);

        out.println(rst.next());

        // Display items in each order in a table
        out.println("<style>table,th,td { border: 1px solid black;}</style>");
        out.println("<table><tr><th>Order Date</th><th>Total Order Amount</th></tr>");
        while(rst.next()){
            out.println("<tr><td>" + rst.getDate("shipmentDate") + "</td><td>" + rst.getInt("shipmentId") + "</td></tr>");
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