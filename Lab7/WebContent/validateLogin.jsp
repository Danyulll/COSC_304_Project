<%@ page import="java.sql.*" %>
<%@ page language="java" import="java.io.*" %>
<%
String authenticatedUser = null;
session = request.getSession(true);// May create new session
try{
authenticatedUser = validateLogin(out,request,session);
}
catch(IOException e) { out.println(e); }
if (authenticatedUser != null)
response.sendRedirect("order.jsp"); // Success
else
response.sendRedirect("checkout.jsp"); // Failed login
// Redirect back to login page with a message
%>
<%!
String validateLogin(JspWriter out, HttpServletRequest request, HttpSession session) throws IOException {
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String retStr = null;
    if(username == null || password == null) return null;
    if((username.length() == 0) || (password.length() == 0)) return null;

    // Server connection information
    String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
    String uid = "SA";
    String pw = "YourStrong@Passw0rd";
    
    // Try-catch for connection
    try(
    Connection con = DriverManager.getConnection(url, uid, pw);
    Statement stmt = con.createStatement(); ){
        // Select userid and their passwords
        String SQL = "SELECT userid, password FROM customer";
        ResultSet rst = stmt.executeQuery(SQL);

        //Check if login information is valid
        while(rst.next()){
            if (username.equals(rst.getString("userid")) && password.equals(rst.getString("password"))) retStr = username;
        }

        //Return Result
        if(retStr != null){ 
            session.removeAttribute("loginMessage");
            session.setAttribute("authenticatedUser",username);
            return retStr;
        } else {
            session.setAttribute("loginMessage","Failed login.");
            return retStr;
        }
        // Connection automatically closed
    } catch(SQLException ex) {out.println(ex);}
    return retStr;
}
%>