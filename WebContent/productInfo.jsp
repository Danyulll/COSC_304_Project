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
    
    
    
    %>
    
    

</html>