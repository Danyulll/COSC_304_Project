<%@ page trimDirectiveWhitespaces="true" import="java.sql.*,java.io.*" %>
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

try(
Connection con = DriverManager.getConnection(url, uid, pw); ){
    

    String SQL2 = "SELECT * FROM REVIEW WHERE customerId = ?";
    PreparedStatement pst2 = con.prepareStatement(SQL2);
    pst2.setString(1,customerId);
    ResultSet rst2 = pst2.executeQuery();
    boolean madeReviewBefore  = (!rst2.next())? false:true;
    
    
    if(!madeReviewBefore){
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
        out.println("<h2>You've already reviewed this product or haven't bought it before</h2>");
    }
    

}catch(SQLException ex) {out.println(ex);}
%>
</body>
</html>

<!-- CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
); -->