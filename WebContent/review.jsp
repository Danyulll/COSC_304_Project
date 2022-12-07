<%@ page trimDirectiveWhitespaces="true" import="java.sql.*,java.io.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
<title>User Account Page</title>
</head>
<body>
<% 
String review = request.getParameter("comment");
String rating = request.getParameter("rating");
String productId = (String)session.getAttribute("productId");
String customerId = (String)session.getAttribute("customerId");
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

//DEBUGGING
//out.println("<br> You're ID: " + customerId + "<br> Your comment"+"<br> The product id: " + productId + "<br> Your rating: " + rating);

try{
    getConnection();
	Statement stmt = con.createStatement(); 			
	stmt.execute("USE orders");

    String SQL2 = "SELECT * FROM REVIEW WHERE customerId = ? AND productId = ?";
    PreparedStatement pst2 = con.prepareStatement(SQL2);
    pst2.setString(1,customerId);
    pst2.setString(2,productId);
    ResultSet rst2 = pst2.executeQuery();
    boolean madeReviewBefore = false;
   if(rst2.next()==false){
    //DEBUGGING
    //out.println("no reviews by you");
    }else{
       madeReviewBefore = true;
       //DEBUGGING
       //out.println("You have reviewed this before");
    }
    
    boolean boughtBefore = false;
    String SQL4 = "SELECT * FROM (customer JOIN ordersummary ON customer.customerId = ordersummary.customerId) JOIN orderproduct ON orderproduct.orderId =  ordersummary.orderId WHERE customer.customerId = ?";
    PreparedStatement pst4 = con.prepareStatement(SQL4);
    pst4.setString(1,customerId);
    ResultSet rst4 = pst4.executeQuery();

    while(rst4.next()){
        if(productId.equals(rst4.getString("productId"))){
            boughtBefore = true;
            //DEBUGGING
            //out.println("You have bought this product before");
            break;
        }else{
            //DEBUGGING
            //out.println("You have not bought this product before");
        }
    }
    
    
    if(!madeReviewBefore && boughtBefore){
    String SQL = "INSERT INTO review VALUES (?,?,?,?,?)";
    PreparedStatement pst = con.prepareStatement(SQL);
    pst.setString(1,rating);
    pst.setDate(2, new java.sql.Date(System.currentTimeMillis()));
    pst.setString(3, customerId);
    pst.setString(4,productId);
    pst.setString(5,review);
    int rowcount = pst.executeUpdate();
    out.println("<h2>Thank you for your feedback</h2>");
}else{
        if(!boughtBefore){
            out.println("<h2>You have not bought this product before</h2>");
        }

        if(madeReviewBefore){
            out.println("<h2>You have reviewed this before</h2>");
        }
    }
    

}catch(SQLException ex) {out.println(ex);}
%>
</body>
</html>
