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
        

<%
	//Connection information
	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
	String uid = "SA";
	String pw = "YourStrong@Passw0rd";

	// Get order id
	String id = request.getParameter("id");

	//DEBUGGING
	//out.println("Id recieved: " + id);
          
	// Check if valid order id
	boolean valid = false;
	String SQL = "SELECT orderId FROM ordersummary";
	try(Connection con = DriverManager.getConnection(url, uid, pw);Statement stmt = con.createStatement();){
		ResultSet rst = stmt.executeQuery(SQL);
		while(rst.next()){
			if(id.equals(rst.getString("orderId"))){
				valid = true;
			}
			
		}
	}catch (SQLException ex) {
		out.println(ex);
	}

	if(valid){
		out.println("Order id validated<br>");
	}else{
		out.println("Error: order id invalid<br>");
	}
	
	try(Connection con = DriverManager.getConnection(url, uid, pw);Statement stmt = con.createStatement();){
		
		// Start a transaction (turn-off auto-commit)
		con.setAutoCommit(false);
	
	
		// Retrieve all items in order with given id
		String SQL2 = "SELECT * FROM orderproduct OP JOIN ordersummary OS ON OP.orderId=OS.orderId  WHERE OS.orderId = ?";
		PreparedStatement pst = con.prepareStatement(SQL2); 
		pst.setString(1,id);
		ResultSet rst2 = pst.executeQuery();

		// Create a new shipment record (For now only for warehouse 1)
		int rowcount = stmt.executeUpdate("INSERT INTO shipment(warehouseId) VALUES (1)");
		

		//DEBUGGING
		out.println("<br>Did new shipment record creation work: " + rowcount);
	

		// For each item verify sufficient quantity available in warehouse 1
		boolean enough = false;
		while(rst2.next()){
			out.println("<br>Checking product: " + rst2.getString("productId")+" for amount: "+rst2.getString("quantity"));
			int idToCheck = rst2.getInt("productId");
			int quanToCheck= rst2.getInt("quantity");
			String SQL3 = "SELECT * FROM productinventory WHERE warehouseId = 1 AND productID = ?";
			PreparedStatement pstPI = con.prepareStatement(SQL3);
			pstPI.setInt(1,idToCheck);
			ResultSet rst3 = pstPI.executeQuery();
			
			// If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
			if(rst3.next()){
				int curAmount = rst3.getInt("quantity");
				if(curAmount >= quanToCheck){
					enough = true;
					String update = "UPDATE productinventory SET quantity = ?";
					PreparedStatement pstUpPI = con.prepareStatement(update);
					pstUpPI.setInt(1,(curAmount-quanToCheck));
					pstUpPI.executeUpdate();
					out.println("<h2>Ordered Product: "+idToCheck+"Qty: "+ quanToCheck +"Previous inventory: "+curAmount+ "New Inventory: "+(curAmount-quanToCheck)+"</h2>");
					
				}else{
					enough=false;
					out.println("<h1>Shipment Failed</h1>");
					out.println("<br><h2>There was not enough inventory for product id"+idToCheck+"</h2>");
					break;
				}
			}else{
				enough=false;
					out.println("<h1>Shipment Failed</h1>");
					out.println("<br><h2>There was not enough inventory for product id"+idToCheck+"</h2>");
					break;
			}
		
		}

			if(enough==true){
				out.println("<h1>Shipment sucessful, changes have been commited</h1>");
				con.commit();
			}else{
				out.println("<h1>Shipment failed, changes have been rolled back</h1>");
				con.rollback();
			}



		con.setAutoCommit(true);
	}catch (SQLException ex) {
		out.println(ex);
	}
	
	

	
	
	

	
%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
