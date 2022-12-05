<%@ page trimDirectiveWhitespaces="true" import="java.sql.*,java.io.*" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Product Information</title>
    </head>

    <h1>Product Info</h1>

    <% 
    String id = request.getParameter("id");
    String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
    String uid = "SA";
    String pw = "YourStrong@Passw0rd";

    try(
	Connection con = DriverManager.getConnection(url, uid, pw); ){

	PreparedStatement pst = con.prepareStatement("Select * FROM product where productId=?");
	pst.setString(1,id);
    ResultSet rst = pst.executeQuery();
    rst.next();
    if(rst.getString("productImageURL") != null){
        out.println("<h2>"+rst.getString("productName")+"</h2>");
	    out.println("<br><img src=\""+rst.getString("productImageURL")+"\">");
    
    }

    if(rst.getBlob("productImage") != null){
       out.println("<img src=\"displayImage.jsp?id=" + id+"\">");
    }

    out.println("<br><strong>Id: </strong>"+rst.getString("productId"));
    out.println("<br><strong>Price: </strong>"+rst.getString("productPrice"));

    out.println("<br><a href=" + "\"" + "addcart.jsp?id="+ rst.getString("productId") + "&name=" + rst.getString("productName") + "&price="+rst.getString("productPrice") + "\"" + ">Add to Cart</a>");
    out.print("<br><a href=\"listprod.jsp\">Continue Shopping</a>");
	}catch(SQLException ex) {out.println(ex);}
    

    String username = (String)session.getAttribute("authenticatedUser");
if(username==null){
    out.println("<br><a href=\"login.jsp\">Log in to leave a review</a>");
}else{
    try(
	Connection con = DriverManager.getConnection(url, uid, pw); ){
    String pid = id;

    String SQL3 = "SELECT customerId FROM customer WHERE userid=?";
    PreparedStatement pst3 = con.prepareStatement(SQL3);
    pst3.setString(1,username);
    ResultSet rst3 = pst3.executeQuery();
    rst3.next();
    String cid = rst3.getString(1);

    //session = request.getSession(true);// May create new session
    session.setAttribute("productId",pid);
    session.setAttribute("customerId",cid);

    out.println("<br>Leave a review<br><form action=\"review.jsp\"><input type=\"text\" name=\"comment\"><br><input type=\"submit\" value=\"submit\"><select name=\"rating\"><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option></select></form>");
    }catch(SQLException ex) {out.println(ex);}
}
    %>
    
    
<%
out.println("<h2>Reviews</h2>");
try(Connection con = DriverManager.getConnection(url, uid, pw);){
	// Create query
	String SQL2 = "SELECT * FROM review  WHERE productId = ?";

	PreparedStatement pst2 = con.prepareStatement(SQL2);
	pst2.setString(1,id);


	// Execute the query
	ResultSet rst2 = pst2.executeQuery();


	out.println("<style>table,th,td { border: 1px solid black;}</style>");
	out.println("<table><tr><th>Review Date</th><th>Review Rating</th><th>Review</th>");

	// Traverse results
	while(rst2.next()){
	
	out.println("<tr><td>"+ rst2.getString("reviewDate")+"</td><td>" + rst2.getInt("reviewRating") + "</td><td>" + rst2.getString("reviewComment") + "</td></tr>");
	}

} catch (SQLException ex) { out.println(ex); }
%>

</html>