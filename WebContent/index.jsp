<!DOCTYPE html>
<html>
<head>
        <title>Hydrobottle Main Page</title>
</head>
<body>
<h1 align="center">Welcome to Ray's Grocery</h1>

<h2 align="center"><a href="login.jsp">Login</a></h2>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<h2 align="center"><a href="logout.jsp">Log out</a></h2>

<H1 align="center">
<%
String username = (String)session.getAttribute("authenticatedUser");
if(username != null){
    out.println(String.format("Signed in as: %s", username));
}
%>
</H1>
</body>
</head>