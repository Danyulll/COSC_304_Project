<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Hydrobottle Grocery Order Processing</title>
</head>
<h1>Your Order Summary</h1>
<body>

<% 
	// Set scope for orderId,firstName,lastName
	int orderId = -1;
	String firstName="";
	String lastName="";


	// Get customer username
	String username = (String)session.getAttribute("authenticatedUser");
	@SuppressWarnings({"unchecked"})
	HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
	
	// Server connection information
	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
	String uid = "SA";
	String pw = "YourStrong@Passw0rd";

	// Make connection
	try(Connection con = DriverManager.getConnection(url, uid, pw); Statement stmt = con.createStatement();){
		
		// Determine if valid customer id was entered
		boolean validId = false;
		String SQL = "SELECT userid FROM customer";
		ResultSet rst = stmt.executeQuery(SQL);
		while(rst.next()){
            if (username.equals(rst.getString("userid")) == true){
				validId = true;
			} 
        }

		// Determine if there are products in the shopping cart
		boolean validCart = false;
		if (productList == null){
			out.println("<H1>Your shopping cart is empty!</H1>");
			productList = new HashMap<String, ArrayList<Object>>();
		}

		// If either are not true, display an error message
		if(!validId){
			out.println("Your Customer ID is invalid");
		} 


		// Get Customer information
		String SQL4 = "SELECT * from customer where userid = ?";
		PreparedStatement pstmt = con.prepareStatement(SQL4);
		pstmt.setString(1,username);
		ResultSet rst4 = pstmt.executeQuery();
		rst4.next();

		java.util.Date orderDate = new java.util.Date();
		String shiptoAddress = rst4.getString("address");
		String shiptoCity = rst4.getString("city");
		String shiptoState = rst4.getString("state");
		String shiptoPostalCode = rst4.getString("postalCode");
		String shiptoCountry = rst4.getString("country");
		int custId = rst4.getInt("customerId");

		firstName = rst4.getString("firstName");
		lastName = rst4.getString("lastName");

		//DEBUGGING
		out.println(orderDate + ", "+shiptoAddress+ ", "+shiptoCity+ ", "+shiptoState+ ", "+shiptoPostalCode+ ", "+shiptoCountry+"\n");


		// Save order information to database

		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
		
			while (iterator.hasNext())
			{ 
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				String productId = (String) product.get(0);
				String productName = (String) product.get(1);
				String price = (String) product.get(2);
				double pr = Double.parseDouble(price);
				int qty = ( (Integer)product.get(3)).intValue();
		
				String SQL2 = "INSERT INTO ordersummary(orderDate,shiptoAddress,shiptoCity,shiptoState,shiptoPostalCode,shiptoCountry,customerId) VALUES(?,?,?,?,?,?,?)";
				// Use retrieval of auto-generated keys.
				PreparedStatement pstmt2 = con.prepareStatement(SQL2, Statement.RETURN_GENERATED_KEYS);
					
				pstmt2.setDate(1,new java.sql.Date(orderDate.getTime()));
				pstmt2.setString(2,shiptoAddress);
				pstmt2.setString(3,shiptoCity);
				pstmt2.setString(4,shiptoState);
				pstmt2.setString(5,shiptoPostalCode);
				pstmt2.setString(6,shiptoCountry);
				pstmt2.setInt(7,custId);

				int rowcount = pstmt2.executeUpdate();

				//DEBUGGING
				out.println("<br>Inserting new data into ordersummary Row affected?: " + rowcount);

				ResultSet keys = pstmt2.getGeneratedKeys();
				keys.next();
				orderId = keys.getInt(1);

				//DEBUGGING
				out.println("<br>Did I get a key? " + orderId+"\n");

				String SQL3 = "INSERT orderproduct VALUES(?,?,?,?)";

				PreparedStatement pstmt3 = con.prepareStatement(SQL3);        
        
                pstmt3.setInt(1,orderId);
                pstmt3.setString(2,productId);
                pstmt3.setInt(3,qty);
                pstmt3.setDouble(4,pr);
                int rowcount2 = pstmt3.executeUpdate();

				//DEBUGGING
				out.println("<br>Did I get a rowcount2 when I inserted data into orderproduct? " + rowcount2+"\n");


			}
		
		// Print out order summary

		out.println("<style>table,th,td { border: 1px solid black;}</style>");
        out.println("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");
        Iterator<Map.Entry<String, ArrayList<Object>>> iterator2 = productList.entrySet().iterator();
        double total = 0;

		while (iterator2.hasNext())
		{ 
			Map.Entry<String, ArrayList<Object>> entry = iterator2.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			String productId = (String) product.get(0);
			String productName = (String) product.get(1);
			String price = (String) product.get(2);
			double pr = Double.parseDouble(price);
			int qty = ( (Integer)product.get(3)).intValue();
			double subtotal = pr * qty;
			out.println("<tr>"+"<td>" +  productId + "</td>" + "<td>" + productName + "</td>" + "<td>" + qty + "</td>"+"<td> $" + pr + "</td>"+"<td> $" + subtotal + "</td>"+"</tr>");
			total += subtotal;
		}
		out.println("<tr><td colspan=\"3\"></td><td>Order Total</td><td>$"+ total+"</td></tr>");
		out.println("</table>");

		//Update ordersummary with new total amount
		String UPDATE = "UPDATE ordersummary SET totalAmount = ? WHERE orderId =?";
		PreparedStatement pstmt3 = con.prepareStatement(UPDATE); 
		pstmt3.setDouble(1,total);
		pstmt3.setDouble(2,orderId);
		int rowcount3 = pstmt3.executeUpdate();

		//DEBUGGING
		out.println("<br> Did ordersummary get updated with new totalAmount (rowcount3)?: "+rowcount3);

		// Clear cart if order placed successfully

		int rowcount4 = stmt.executeUpdate("DELETE FROM incart");
		session.removeAttribute("productList");
		session.removeAttribute("authenticatedUser");

		//DEBUGGING
		out.println("<br> Did the delete work on incart (rowcount4)? " + rowcount4);

		//Connection closed automatically
	} catch(SQLException ex) {out.println(ex);}
%>
<h1>Shiping To: <%= firstName %> <%= lastName %></h1>
<h1>Order Id: <%= orderId %></h1>
</BODY>
</HTML>

