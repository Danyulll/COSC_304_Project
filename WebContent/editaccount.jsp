<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Edit Account</title>
</head>
<body>
    <h1><p1 style ="font-family:Courier New">Edit Your Account</h1></p1>
    <h3><p1 style ="font-family:Courier New">Please enter your current user name and password followed by your new information.</h3></p1>
    <form method="get" action="editaccount.jsp">
        <h3><p1 style ="font-family:Courier New">Enter your username:</h3></p1>
        <input type="text" name="username" size="50" placeholder="Enter a Username">
        <h3><p1 style ="font-family:Courier New">Enter your password</h3></p1>
        <input type="text" name="password" size="50" placeholder="Enter password">
        <h3><p1 style ="font-family:Courier New">Enter a new password</h3></p1>
        <input type="text" name="newPassword" size="50" placeholder="Enter new password">
        <h3><p1 style ="font-family:Courier New">Enter a new Street Address:</h3></p1>
        <input type="text" name="address" size="50" placeholder="Street Address">
        <h3><p1 style ="font-family:Courier New">Enter a new City:</h3></p1>
        <input type="text" name="city" size="50" placeholder="City">
        <h3><p1 style ="font-family:Courier New">Enter a new State::</h3></p1>
        <input type="text" name="state" size="50" placeholder="State">
        <h3><p1 style ="font-family:Courier New">Enter a new Postal Code:</h3></p1>
        <input type="text" name="postalCode" size="50" placeholder="Postal Code">
        <h3><p1 style ="font-family:Courier New">Enter a new Country:</h3></p1>
        <input type="text" name="country" size="50" placeholder="Country">
        <h3><p1 style ="font-family:Courier New">Press Submit Once all Fields are complete:</h3></p1>
        <input type="submit" value="Submit">
    </form>

    <%@ include file="jdbc.jsp" %>
    <%
    //get values from form
    String[] user_info = new String[8];
    user_info[0] = request.getParameter("username");
    user_info[1] = request.getParameter("password");
    user_info[2] = request.getParameter("newPassword");
    user_info[3] = request.getParameter("address");
    user_info[4] = request.getParameter("city");
    user_info[5] = request.getParameter("state");
    user_info[6] = request.getParameter("postalCode");
    user_info[7] = request.getParameter("country");

    //Check all values are non-null
    boolean validInfo = true;
    for(int i = 0; i < user_info.length; i++){
        if(user_info[i] == null || user_info[i].equals("")){
            validInfo = false;
        }
    }

    //check current username and password are valid
    boolean validLogin = false;
    try{
        getConnection();
        Statement stmt = con.createStatement(); 			
        stmt.execute("USE orders");
        String SQL = "SELECT userid FROM customer WHERE userid = ? AND password = ?";
        PreparedStatement pst = con.prepareStatement(SQL);
        pst.setString(1, user_info[0]);
        pst.setString(2, user_info[1]);
        ResultSet rst = pst.executeQuery();
        if(rst.next()){
            validLogin = true;
        }
    } catch (SQLException ex) { out.println(ex); }
    finally{closeConnection();}

    //out.println(validInfo);
    //out.println(validLogin);

    //if values are null or username not unique display error message
    if(validInfo == false){
        out.println("Please fill in all fields.");
    } else if(validLogin == false){
        out.println("Your username or password are not associated with a current account. Please try again.");
    } else{
        try{
            getConnection();
            Statement stmt2 = con.createStatement(); 
            stmt2.execute("USE orders");
            String SQL = "UPDATE CUSTOMER SET password = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ? WHERE userid = ?";
            //String SQL = "INSERT INTO CUSTOMER (password, address, city, state, postalCode, country) VALUES (?,?,?,?,?,?)";
            PreparedStatement pst = con.prepareStatement(SQL);
            int j = 1;
            for(int i = 2; i < user_info.length; i++){
                pst.setString(j, user_info[i]);
                j++;
            }
            pst.setString(7, user_info[0]);
            int rst = pst.executeUpdate();
        } catch (SQLException ex) { out.println(ex); }
        finally{closeConnection();}
        out.println("Your account information has been updated.");
    }
    %>
    <h3 align="left"><a href="UserAccount.jsp">View Your Account</a></h3>
</body>