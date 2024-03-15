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

}
