/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ganare.dbconnection;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 *
 * @author hp
 */
public class MyConnection {
    
   public static Connection createConnection()
    { 
        Connection cn = null;
        
        
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/gana_bajao", "shailesh", "");
            
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        return cn;
        
    }
    
}
