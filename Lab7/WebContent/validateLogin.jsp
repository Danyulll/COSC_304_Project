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
String validateLogin(JspWriter out,HttpServletRequest request,
HttpSession session) throws IOException
{
String username = request.getParameter("username");
String password = request.getParameter("password");
String retStr = null;
if(username == null || password == null)
return null;
if((username.length() == 0) || (password.length() == 0))
return null;
// Should make a database connection here and check password
// Here just hard-coding password
if (username.equals("test") && password.equals("test"))
retStr = username;
if(retStr != null)
{ session.removeAttribute("loginMessage");
session.setAttribute("authenticatedUser",username);
}
else
session.setAttribute("loginMessage","Failed login.");
return retStr;
}
%>