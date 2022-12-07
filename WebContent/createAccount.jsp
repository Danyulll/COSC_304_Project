<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Create Account</title>
</head>
<body>
    <h1><p1 style ="font-family:Courier New">Create a New User Account</h1></p1>
    <form method="get" action="createAccount.jsp">
        <h3><p1 style ="font-family:Courier New">Enter a username:</h3></p1>
        <input type="text" name="username" size="50" placeholder="Enter a Username">
        <h3><p1 style ="font-family:Courier New">Enter a password</h3></p1>
        <input type="text" name="password" size="50" placeholder="Enter password">
        <h3><p1 style ="font-family:Courier New">Enter your First Name:</h3></p1>
        <input type="text" name="firstName" size="50" placeholder="Enter your first name">
        <h3><p1 style ="font-family:Courier New">Enter Last Name:</h3></p1>
        <input type="text" name="lastName" size="50" placeholder="Enter your last name">
        <h3><p1 style ="font-family:Courier New">Enter your Email</h3></p1>
        <input type="text" name="email" size="50" placeholder="Enter your email">
        <h3><p1 style ="font-family:Courier New">Enter your Phone Number:</h3></p1>
        <input type="text" name="phoneNum" size="50" placeholder="Phone Number">
        <h3><p1 style ="font-family:Courier New">Enter your Street Address:</h3></p1>
        <input type="text" name="address" size="50" placeholder="Street Address">
        <h3><p1 style ="font-family:Courier New">Enter your City:</h3></p1>
        <input type="text" name="city" size="50" placeholder="City">
        <h3><p1 style ="font-family:Courier New">Enter your State::</h3></p1>
        <input type="text" name="state" size="50" placeholder="State">
        <h3><p1 style ="font-family:Courier New">Enter your Postal Code:</h3></p1>
        <input type="text" name="postalCode" size="50" placeholder="Postal Code">
        <h3><p1 style ="font-family:Courier New">Enter your Country:</h3></p1>
        <input type="text" name="country" size="50" placeholder="Country">
        <h3><p1 style ="font-family:Courier New">Press Submit Once all Fields are complete:</h3></p1>
        <input type="submit" value="Submit">
    </form>

    <%
    //get values from form
    String[] user_info = new String[11];
    user_info[0] = request.getParameter("username");
    user_info[1] = request.getParameter("password");
    user_info[2] = request.getParameter("firstName");
    user_info[3] = request.getParameter("lastName");
    user_info[4] = request.getParameter("email");
    user_info[5] = request.getParameter("phoneNum");
    user_info[6] = request.getParameter("address");
    user_info[7] = request.getParameter("city");
    user_info[8] = request.getParameter("state");
    user_info[9] = request.getParameter("postalCode");
    user_info[10] = request.getParameter("country");

    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phoneNumber = request.getParameter("phoneNum");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("country");

    //Check all values are non-null
    boolean validInfo = true;
    for(int i = 0; i < user_info.length; i++){
        if(user_info[i] == null || user_info[i].equals("")){
            validInfo = false;
        }
    }

    //check username is unique
    boolean uniqueusername = true;
    try{ 	
	    getConnection();
	    Statement stmt = con.createStatement(); 
	    stmt.execute("USE orders");
        String SQL = "SELECT userid FROM customer WHERE userid = ?";
        PreparedStatement pst = con.prepareStatement(SQL);
        pst.setString(1, username);
        ResultSet rst = pst.executeQuery();
        if(rst.next()){
            uniqueusername = false;
        }
    } catch (SQLException ex) { out.println(ex); }
    finally{closeConnection();}

    //out.println(validInfo);
    //out.println(uniqueusername);

    //if values are null or username not unique display error message
    if(validInfo == false){
        out.println("Please fill in all fields.");
    } else if(uniqueusername == false){
        out.println("Your username is already taken. Please enter another.");
    } else{
        try{
            getConnection();
            Statement stmt2 = con.createStatement(); 			
            stmt2.execute("USE orders");
            String SQL = "INSERT INTO CUSTOMER (userid, password, firstName, lastName, email, phonenum, address, city, state, postalCode, country) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
            PreparedStatement pst = con.prepareStatement(SQL);
            for(int i = 0; i < user_info.length; i++){
                pst.setString((i+1), user_info[i]);
            }
            int rst = pst.executeUpdate();
        } catch (SQLException ex) { out.println(ex); }
        finally{closeConnection();}
        out.println("Your account has been created!");
    }
        
    %>
    <h3 align="left"><a href="index.jsp">Back to Index</a></h3>
</body>