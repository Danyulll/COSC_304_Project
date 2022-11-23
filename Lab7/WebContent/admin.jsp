<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

<%
include file="jdbc.jsp"
include file="auth.jsp"
%>
<%
//TODO validate login info with auth.jsp

try 
	{
		getConnection();
		String sql = "";
		
	} 
	catch(SQLException ex) {
		out.println(ex);
	}
	finally
	{
		closeConnection();
	}
%>

</body>
</html>