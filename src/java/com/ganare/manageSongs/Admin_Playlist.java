package com.ganare.manageSongs;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/Admin_Playlist")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class Admin_Playlist extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "D:/Universal Web Project/Ganare/web/images/Songs_image/Artist_Images";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String playlistName = request.getParameter("playlistName");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        String adminId = (String) session.getAttribute("adminId");
        Part filePart = request.getPart("playlistImage");

        if (playlistName == null || email == null || filePart == null || filePart.getSize() == 0) {
            response.getWriter().println("Missing form fields or file.");
            return;
        }

        try {
            // Create upload directory if it doesn't exist
            File uploadDir = new File(UPLOAD_DIRECTORY);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String originalFileName = filePart.getSubmittedFileName();
            String fullPath = UPLOAD_DIRECTORY + File.separator + originalFileName;

            // Save the file to disk
            filePart.write(fullPath);
            String dbImageName = originalFileName;

            
            // Insert into database
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gana_bajao", "shailesh", "");
            String query = "INSERT INTO artist_playlists (admin_id, name, image) VALUES (?, ?, ?)";
            PreparedStatement stmt = cn.prepareStatement(query);
            stmt.setString(1, adminId);
            stmt.setString(2, playlistName);
            stmt.setString(3, dbImageName);
            
            stmt.executeUpdate();
            cn.close();

            
            session.setAttribute("playlistName", playlistName);
             session.setAttribute("adminId", adminId);

            
            response.sendRedirect("add_songs.jsp");

        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
