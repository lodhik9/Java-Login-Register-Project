# Login-Register-Project

This is a web application built using **Java Servlets**, **JSP**, and **JDBC**. It allows users to register, login, and access a welcome page after successful authentication. The application uses a MySQL database to store user credentials.

---

### 1. Technologies Used

---

- Java
- Servlets
- JSP
- JDBC
- MySQL
- HTML
- CSS

---

### 2. Getting Started

---

To run this application locally, you'll need a Java Development Environment (JDK), a web server like Apache Tomcat, and a MySQL server.

1. Clone the repository or download the source code.
2. Import the project into your preferred Java IDE (e.g., Eclipse, IntelliJ IDEA).
3. Set up a MySQL database and update the database connection details in `DBUtil.java`.
4. Configure the web server to deploy the application.
5. Run the application and access it through the configured URL (e.g., `http://localhost:8080/LoginRegisterApp`).

---

### 3. Usage

---

1. On the main page, click the "Register" link to create a new user account.
2. After registration, you can log in using your credentials.
3. Upon successful login, you'll be redirected to the welcome page.
4. You can log out from the welcome page using the "LOGOUT" link.

---

### 4. Features

---

- User registration with username, email, and password.
- User authentication and login.
- Secure logout functionality.
- User-friendly interface with input fields and navigation links.

---

### 5.File Structure and Code

---

- `User.java`: Java class representing a user entity.

_[src/main/java/com/company/dao/User.java](src/main/java/com/company/dao/User.java)_

```java
package com.company.dao;

public class User {

	private String username;
	private String password;
	private String email;

	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}

}

```

- `UserDao.java`: Interface defining methods for user operations.

_[src/main/java/com/company/dao/UserDao.java](src/main/java/com/company/dao/UserDao.java)_

```java
package com.company.dao;

public interface UserDao {

	boolean isValidUser(String username, String password);

	boolean addUser(User user);
}

```

- `UserDaoImp.java`: Implementation of the `UserDao` interface using JDBC.

_[src/main/java/com/company/dao/UserDaoImp.java](src/main/java/com/company/dao/UserDaoImp.java)_

```java
package com.company.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.company.util.DBUtil;

public class UserDaoImp implements UserDao{

	@Override
	public boolean isValidUser(String username, String password) {
		String query = "SELECT * FROM users WHERE username = ? AND password = ?";
		try(Connection connection = DBUtil.getConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(query)){

			preparedStatement.setString(1, username);
			preparedStatement.setString(2, password);

			ResultSet resultSet = preparedStatement.executeQuery();

			//System.out.println("Query ran");

			// it will return true
			return resultSet.next();

		}catch(SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	@Override
	public boolean addUser(User user) {
		String query = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
		try(Connection connection = DBUtil.getConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(query)){

			preparedStatement.setString(1, user.getUsername());
			preparedStatement.setString(2, user.getPassword());
			preparedStatement.setString(3, user.getEmail());

//			It gives: How many rows are inserted and effected
			int rows = preparedStatement.executeUpdate();

			System.out.println("User added");
			return rows>0;


		}catch(SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

}
```

- `LoginServlet.java`: Servlet handling user login requests.

_[src/main/java/com/company/servlet/LoginServlet.java](src/main/java/com/company/servlet/LoginServlet.java)_

```java
package com.company.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import com.company.dao.UserDao;
import com.company.dao.UserDaoImp;

/**
 * Servlet implementation class LoginServlet
 */
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static UserDao userDao = new UserDaoImp();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//System.out.println("here");
		String username = request.getParameter("username");
		String password = request.getParameter("password");

//		if(username.equals("lodhi")) {
//			response.sendRedirect("welcome.jsp");
//			System.out.println("Equals");
//
//		}

		if(userDao.isValidUser(username, password)) {
			HttpSession session = request.getSession();
			session.setAttribute("username", username);
			response.sendRedirect("welcome.jsp");

		}else {
			response.sendRedirect("login.jsp?error=1");
			System.out.println("Error");
		}

	}

}

```

- `LoginServlet.java`: Servlet handling user logout requests.

_[src/main/java/com/company/servlet/LogoutServlet.java](src/main/java/com/company/servlet/LogoutServlet.java)_

```java
package com.company.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet implementation class LogoutServlet
 */
public class LogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public LogoutServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve the session object
        HttpSession currentSession = request.getSession(false);
    	if(currentSession != null)
    	{
    		currentSession.invalidate();
    	}
    	response.sendRedirect("index.html");
	}

}

```

- `RegisterServlet.java`: Servlet handling user registration requests.

_[src/main/java/com/company/servlet/RegisterServlet.java](src/main/java/com/company/servlet/RegisterServlet.java)_

```java
package com.company.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.company.dao.User;
import com.company.dao.UserDao;
import com.company.dao.UserDaoImp;

/**
 * Servlet implementation class RegisterServlet
 */
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static UserDao userDao = new UserDaoImp();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public RegisterServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username = request.getParameter("username");
		String password = request.getParameter("email");
		String email = request.getParameter("password");

		User user = new User();
		user.setUsername(username);
		user.setPassword(password);
		user.setEmail(email);

		if(userDao.addUser(user)) {
			response.sendRedirect("login.jsp?registration=success");
		}else {
			response.sendRedirect("register.jsp?error=1");
		}
	}
}
```

- `DBUtil.java`: Utility class for establishing a database connection.

_[src/main/java/com/company/util/DBUtil.java](src/main/java/com/company/util/DBUtil.java)_

```java
package com.company.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

//class responsible for database connectivity
public class DBUtil {
	private static final String URL = "jdbc:mysql://localhost:3306/lodhi";
	private static final String USERNAME = "root";
	private static final String PASSWORD = "password";

//	Whenever this class loads on server, this loads
    static {
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
    	System.out.println("Connection Build");
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
```

- `index.html`: The main page with links to login and register.

  _[src/main/webapp/index.html](src/main/webapp/index.html)_

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Lodhi's App</title>
    <link rel="stylesheet" type="text/css" href="style.css" />
  </head>
  <body>
    <div class="container">
      <h1>Welcome!</h1>
      <h3>This project 💻 has been passionately 💖 crafted.</h3>
      <p>🔴 Frontend technologies used: HTML, CSS.</p>
      <p>🔴 Backend technologies used: JSP, Servlet, JDBC.</p>
      <p>
        Feel free to <span class="emoji">👋</span> Login or
        <span class="emoji">🚀</span> Register to get started!
      </p>

      <div class="links">
        <a href="login.jsp">Login</a>
        <a href="register.jsp">Register</a>
      </div>
    </div>
  </body>
</html>
```

- `login.jsp`: The login page.

  _[src/main/webapp/login.jsp](src/main/webapp/login.jsp)_

```jsp
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
```

- `register.jsp`: The registration page

  _[src/main/webapp/register.jsp](src/main/webapp/register.jsp)_

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register</title>
<link rel="stylesheet" type="text/css" href="login-register.css" />
</head>
<body>
<div class="container">
	<h1>Register</h1>
	<form action="RegisterServlet" method="post">
		<label for="username">Username:</label>
		<input type="text" id="username" name="username" required/><br>
		<label for="email">Email:</label>
		<input type="text" id="email" name="email" required/><br>
		<label for="password">Password:</label>
		<input type="text" id="password" name="password" required/><br>
		<button type="submit">Register</button>
	</form>

	<p><a href="index.html"> Back to Home</a></p>
</div>
</body>
</html>
```

- `welcome.jsp`: The welcome page displayed after successful login.

  _[src/main/webapp/welcome.jsp](src/main/webapp/welcome.jsp)_

```jsp
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
```

---

### 6.Contributing

---

Contributions are welcome! If you find any issues or have suggestions for improvement, please open an issue or submit a pull request.

---

### 7.License

---

This project is licensed under the [MIT License](LICENSE).
