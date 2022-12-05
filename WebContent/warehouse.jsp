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
out.println("<table><tr><th colspan=\"2\">Update Inventory</th><th><form method=\"get\" action=\"warehouse.jsp\"><input type=\"submit\" value=\"Update\" name=\"submit\"></form></th></tr>");
out.println("<tr><td><input type=\"text\" name=\"wareid\" size=\"3\" placeholder=\"WarehouseId\"></td><td><input type=\"text\" name=\"prodid\" size=\"3\" placeholder=\"ProductId\"></td><td><input type=\"text\" name=\"qty\" size=\"3\" placeholder=\"Quantity\"></td></tr></table>");

// Connection automatically closed

 } catch(SQLException ex) {out.println(ex);}
 
 
 
 
 %>


</body>
</html>
