<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
<link rel="stylesheet" type="text/css" href="login-register.css" />
</head>
<body>
<div class="container">
	<h1>Login</h1>
	<form action="LoginServlet" method="post">
		<label for="username">Username:</label>
		<input type="text" id="username" name="username" required/><br>
		<label for="password">Password:</label>
		<input type="text" id="password" name="password" required/><br>
		<button type="submit">Login</button>
	</form>
	
	<p><a href="index.html"> Back to Home</a></p>
	
	<% String error = request.getParameter("error");
	if(error != null && error.equals("1")){%>
		<p style="color: red;">Invalid Username or Passowrd.</p>
	<%}
	%>
	
	<% String rs = request.getParameter("registration");
	if(rs != null && rs.equals("success")) {%>
	<p style="color: green;">Your registration is successful</p>
	<% } %>
</div>
</body>
</html>