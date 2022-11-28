<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Hydrobottle Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	// Get order id
	int orderId = (String)session.getAttribute("authenticatedUser");
	@SuppressWarnings({"unchecked"})
	HashMap<String, ArrayList<Object>> ordersummary = (HashMap<String, ArrayList<Object>>) session.getAttribute("ordersummary");
        
	
	
	// Server connection information
	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
	String uid = "SA";
	String pw = "YourStrong@Passw0rd";
	

	


	// TODO: Start a transaction (turn-off auto-commit)
	try (Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();)
	{


		// Check if valid order id
		boolean validId = false;
		String SQL = "SELECT orderId FROM ordersummary";
		ResultSet rst = stmt.executeQuery(SQL);
		while(rst.next()){
        	if (orderId.equals(rst.getInt("orderId")) == true){
				validId = true;
			} 
    	}
		
		con.setAutocommit(false);
		String SQL = "SELECT * FROM ordersummary WHERE orderId = ?"
		PreparedStatement pstmt = con.prepareStatement(SQL);
		pstmt.setInt(1, orderId);
		ResultSet rst = pstmt.executeQuery();

		if (rst.next())
		{
			stmt.executeUpdate("UPDATE emp SET salary=100000 WHERE eno='E1'");
			con.commit();
		} else
			con.rollback();
		}
	catch (SQLException ex)
	{
		System.err.println(ex); con.rollback();
	}



	// TODO: Retrieve all items in order with given id
	// TODO: Create a new shipment record.
	// TODO: For each item verify sufficient quantity available in warehouse 1.
	// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
	
	// TODO: Auto-commit should be turned back on
%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
