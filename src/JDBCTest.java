package com.jikexueyuan.jdbc;

import java.sql.DriverManager;
import java.sql.ResultSet;




public class JDBCTest {
	public static void main(String[] args) {
		String sql = "select * from vacuum;";
		java.sql.Connection connect =null;
		java.sql.Statement state=null;
		ResultSet result=null;
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			connect=DriverManager.getConnection("jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf-8", "root", "123456");
			state=connect.createStatement();
			result=state.executeQuery(sql);
			while(result.next()) {
				System.out.print(result.getInt("id")+" ");
				System.out.print(result.getString("opra_man")+" ");
				System.out.print(result.getString("tube_name")+" ");
				System.out.println();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				result.close();
				state.close();
				connect.close();
			} catch (Exception e2) {
				
			}
		}
	}
}
