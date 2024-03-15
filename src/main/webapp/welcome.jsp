<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Lodhi's App</title>
<link rel="stylesheet" type="text/css" href="style.css" />
</head>
<body>
    <!-- In order to write Java Code -->
    <%
        // Retrieve the session object
        HttpSession session1 = request.getSession(false);

        // Check if the session is not null and the username attribute is set
        if (session1 != null && session1.getAttribute("username") != null) {
            // Get the username from the session
            String username = (String) session1.getAttribute("username");
    %>


<div class="container">
  	<h1>Welcome,! <%= username %> </h1>
    <p>We're delighted to have you on our platform. 🌟</p>
    <h3>Explore, learn, and connect with our vibrant community! 🚀</h3>
    <p>Feel free to stay as long as you like, and when you're ready,</p> 
       you can <a href="LogoutServlet">LOGOUT</a> securely.
</div>

<%
        }else{
        	response.sendRedirect("login.jsp");
        }
%>
</body>
</html>