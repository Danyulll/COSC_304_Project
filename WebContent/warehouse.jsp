<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Hydrobottle Warehouse Inventory</title>
</head>
<body>

<h1>Inventory</h1>

 <%  

 // Server connection information

 String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
 String uid = "SA";
 String pw = "YourStrong@Passw0rd";
 
 // Try-catch for connection
 try(
 Connection con = DriverManager.getConnection(url, uid, pw);
 Statement stmt = con.createStatement(); ){

	//update warehouse inventory (if needed)
	if(request.getParameter("wareid") != null && request.getParameter("wareid") != "" && request.getParameter("prodid") != null
	&& request.getParameter("prodid") != "" && request.getParameter("qty") != null && request.getParameter("qty") != ""){
		out.println("working");

		int whouseid = Integer.parseInt(request.getParameter("wareid"));
		int productid = Integer.parseInt(request.getParameter("prodid"));
		int newquantity = Integer.parseInt(request.getParameter("qty"));
		
		PreparedStatement updatepst = con.prepareStatement("UPDATE productinventory SET quantity = ? WHERE warehouseId=? AND productId=?");
		updatepst.setInt(1,newquantity);
		updatepst.setInt(2,whouseid);
		updatepst.setInt(3,productid);
		ResultSet updaterst = updatepst.executeQuery();
		//updaterst.next();
	}


 // Select orders and their products
 String SQL = "SELECT * FROM warehouse as W JOIN productinventory as P ON W.warehouseId=P.warehouseId";
 ResultSet rst = stmt.executeQuery(SQL);

 // Display items in each order in a table
 out.println("<style>table,th,td { border: 1px solid black;}</style>");
 

int lastWareId = -1;
while(rst.next()){
	if(lastWareId != rst.getInt("warehouseId") ){
		out.println("<table><tr><th>Warehouse Id</th><th colspan=\"2\">Warehouse Name</th></tr>");
		out.println("<tr><td>"+rst.getString("warehouseId")+"</td><td colspan=\"2\">"+rst.getString("warehouseName")+"</td></tr>");
		Statement stmt2 = con.createStatement();
		String SQL2 = "SELECT * FROM productinventory WHERE warehouseId=?";
		PreparedStatement pstmt = con.prepareStatement(SQL2);
		pstmt.setInt(1,rst.getInt("warehouseId"));
		ResultSet rst2 = pstmt.executeQuery();
		out.println("<tr><th>Product Id</th><th>Quantity</th><th>Price</th></tr>");
		while(rst2.next()){
			out.println("<tr><td>"+rst2.getString("productId")+"</td><td align=\"center\"><input type=\"text\" name=\"newqty\" size=\"3\" value="+rst2.getString("quantity")+" </td><td>$"+rst2.getBigDecimal("price")+"</td></tr>");
		}
		out.println("</table>");
		
		lastWareId = rst.getInt("warehouseId");
		
	}

    
       

}
out.println("<br>");

out.println("<style>table,th,td { border: 1px solid black;}</style>");
out.println("<table><tr><th colspan=\"3\">Update Inventory</th></tr>");
out.println("<tr><td>Warehouse Id</td><td>Product Id</td><td>New Quantity  </td></tr>");
out.println("<tr><td><form action=\"warehouse.jsp\"><input type=\"text\" name=\"wareid\" size=\"8\"<td><td><input type=\"text\" name=\"prodid\" size=\"8\"></td><td><input type=\"text\" name=\"qty\" size=\"8\"></td></tr></table>");
out.println("<br><input type=\"submit\" value=\"Submit\"></form>");

// Connection automatically closed

 } catch(SQLException ex) {out.println(ex);}
 
 
 
 
 %>


</body>
</html>

