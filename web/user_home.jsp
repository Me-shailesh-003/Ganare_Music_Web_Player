<%-- 
    Document   : user_home
    Created on : 15-Jan-2024, 10:12:21 pm
    Author     : hp
--%>



<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.ganare.dbconnection.MyConnection"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title> Gaanare </title>
        <link href="styles/user_home.css" rel="stylesheet" type="text/css"/>
        <script src="slider.js" type="text/javascript"></script>
        <style>

            @import url('https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@100&family=Lemon&family=Salsa&display=swap');

            @import url('https://fonts.googleapis.com/css2?family=Lemon&family=Salsa&display=swap');



        </style>



        <script>

            function showUploadMessage() {
                alert(' File Upload Succesfully !! ');
            }


        </script>


    </head>

    <body >
        <%
            try {
                session = request.getSession(false);

                String name = (String) session.getAttribute("name");
                String email = (String) session.getAttribute("email");

                if (email != null) {
                    System.out.println("Welcome to Home");
                } else {
                    RequestDispatcher rd = request.getRequestDispatcher("index.html");
                    rd.include(request, response);
                    out.println("<script>loginFirst();</script>");
                }
            } catch (Exception e) {

                RequestDispatcher rd = request.getRequestDispatcher("index.html");
                rd.include(request, response);
                out.println("<script>loginFirst();</script>");

            }
        %>

        <header>


            <div class="search-bar" >
                <form action="search_filter.jsp">
                    <select name="filter" >
                        <option selected="selected" value="">Sorted By:</option>
                        <option value="song_name">Song Name</option>
                        <option value="singer_name">Singer Name</option>
                        <option value="album_name">Album Name</option>
                        <option value="language">Language</option>
                        <option value="release_year">Release Year</option>
                    </select>
                    <input type="text"   name="search"  placeholder="search any song" >
                    <input  type="submit" value="Search" >
                </form>    
            </div>

            <div class="header-content">
                <img src="images/web_images/logoGanare.png" alt="Welcome Image" style="width: 17%;  margin-left: 0%; padding-top: 3%;">
                <p> Where Melodies Reflect The Soul <p>
            </div>

            <div class="logout-button" >
                <form action="User_Logout" onsubmit="return confirm('Are you sure you want to logout?');">
                    <input type="submit" value="Logout"> 
                </form>
            </div>

        </header>

        <nav>
            <ul>
                <li><a href="#home">Home</a></li>
                <li><a href="#genres">Genres</a></li>
                <li><a href="#artists">Artists</a></li>
                <li><a href="#playlists">Playlists</a></li>
                <li><a href="#about">About Us</a></li>
                <li><a href="#contact">Contact</a></li>
                <li><a href="#liked">Liked Song</a></li>

            </ul>
        </nav>

        <section id="Home">
            <%    String name = (String) session.getAttribute("name");%>
            <h1>Welcome to Ganare : <%=name%></h1>
        </section>






        <section id="genres">
            <h2>Trending Songs</h2>

            <div class="spotifyPlaylists">

                <div class="cardContainer">


                    <%                        try {
                            ArrayList<Map<String, String>> songsList = new ArrayList<>();
                            Connection cn = MyConnection.createConnection();
                            Statement smt = cn.createStatement();
                            ResultSet rs = smt.executeQuery("SELECT * FROM song");

                            while (rs.next()) {
                                Map<String, String> songMap = new HashMap<>();
                                songMap.put("id", rs.getString(1));
                                songMap.put("songName", rs.getString(2));
                                songMap.put("singerName", rs.getString(3));
                                songMap.put("imageFileName", rs.getString(7));
                                songMap.put("audioFileName", rs.getString(8));
                                songsList.add(songMap);

                    %>



                    <div class="card ">

                        <a href='user_home.jsp?id=<%=songMap.get("id")%>'>
                            <% out.println("<img style='width: 150px; height: 150px;' src='images/Songs_image/" + songMap.get("imageFileName") + "'>");
                                out.println(" <p style=' color: white;  '>" + songMap.get("songName") + " </p>");
                                out.println(" <p style=' color: #e6cf12;  '>" + songMap.get("singerName") + " </p>");

                            %>
                            <div class="play">
                                <svg width="48" height="48" viewBox="0 0 48 48" fill="#00FF00" xmlns="http://www.w3.org/2000/svg">
                                <circle cx="24" cy="24" r="24" fill="#00FF00" />
                                <path d="M17 16.5L30 24L17 31.5V16.5Z" fill="#000000" />
                                </svg>
                            </div> </a>  
                    </div>


                    <%                        }
                            session = request.getSession(true);
                            session.setAttribute("songsList", songsList);
                            rs.close();
                            smt.close();
                            cn.close();
                        } catch (Exception e) {
                            out.println(e.getMessage());
                        }
                    %>
                </div>
        </section>



        <section id="artists">
            <h2>Featured Artists Playlists</h2>
        

            <div class="spotifyPlaylists">
                <div class="cardContainer">
                    <%
                        boolean hasPlaylists = false;

                        try {

                           
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gana_bajao", "shailesh", "");

                            String query = "SELECT playlist_id, name, image FROM artist_playlists";
                            PreparedStatement ps = cn.prepareStatement(query);
                            ResultSet rs = ps.executeQuery();

                            while (rs.next()) {
                                hasPlaylists = true;
                                int playlistId = rs.getInt("playlist_id");
                                String playlistName = rs.getString("name");
                                String artist_image = rs.getString("image");
                    %>

                    <div class="card">
                        <a href='show_admin_playlist.jsp?playlistName=<%= playlistName%>&playlistId=<%= playlistId%>&artistImage=<%= artist_image%>'>

                            <img style='width: 150px; height: 150px;' src='images/Songs_image/Artist_Images/<%=artist_image%>'>
                            <!--                            <img style="width: 150px; height: 150px;" src="images/playlists_image/Hot_Hits.jpg" alt="Playlist">-->
                            <p style="color: white;"><%= playlistName%></p>

                            <div class="play">
                                <svg width="48" height="48" viewBox="0 0 48 48" fill="#00FF00" xmlns="http://www.w3.org/2000/svg">
                                <circle cx="24" cy="24" r="24" fill="#00FF00" />
                                <path d="M17 16.5L30 24L17 31.5V16.5Z" fill="#000000" />
                                </svg>
                            </div>
                        </a>
                    </div>

                    <%
                            }

                            rs.close();
                            ps.close();
                            cn.close();

                        } catch (Exception e) {
                            out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
                        }
                    %>

                    <% if (!hasPlaylists) { %>
                    <p style='color: black; text-align: center; font-size: 18px;'>Here, Artist playlist is not available at this time.</p>
                    <% } %>

                </div>



                
        </section>

        <section id="playlists">
            <h2>Your Playlists</h2>

            <a href="create_playlist.jsp">
                <button class="create-playlist-btn">
                    <img src="images/buttons/playlists.png" alt="Create Playlist" style="width: 30px; height: 30px; vertical-align: middle; margin-right: 10px;"/>
                    Create a playlist
                </button>
            </a>


            <div class="spotifyPlaylists">
                <div class="cardContainer">
                    <%
                        boolean hasUserPlaylists = false;

                        try {
                            String userId = (String) session.getAttribute("userId"); 
                            if (userId == null) {
                                out.println("<p style='color:red;'>User ID not found in session. Please log in again.</p>");
                            } else {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gana_bajao", "shailesh", "");

                                String query = "SELECT playlist_id, name FROM user_playlists WHERE id = ?";
                                PreparedStatement ps = cn.prepareStatement(query);
                                ps.setString(1, userId);
                                ResultSet rs = ps.executeQuery();

                                while (rs.next()) {
                                    hasUserPlaylists = true;
                                    int playlistId = rs.getInt("playlist_id");
                                    String playlistName = rs.getString("name");
                    %>

                    <div class="card">
                        <a href='show_one_playlist.jsp?playlistName=<%= playlistName%>&playlistId=<%= playlistId%>'>

                            <img style="width: 150px; height: 150px;" src="images/playlists_image/Hot_Hits.jpg" alt="Playlist">
                            <p style="color: white;"><%= playlistName%></p>
                            <p style="color: #e6cf12;">Your Favourite Playlist</p>
                            <div class="play">
                                <svg width="48" height="48" viewBox="0 0 48 48" fill="#00FF00" xmlns="http://www.w3.org/2000/svg">
                                <circle cx="24" cy="24" r="24" fill="#00FF00" />
                                <path d="M17 16.5L30 24L17 31.5V16.5Z" fill="#000000" />
                                </svg>
                            </div>
                        </a>
                    </div>

                    <%
                                }

                                rs.close();
                                ps.close();
                                cn.close();
                            }
                        } catch (Exception e) {
                            out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
                        }
                    %>

                    <% if (!hasUserPlaylists) { %>
                    <p style="color: blue; text-align: center; font-size: 18px;">No playlists found. Please create one to get started.</p>
                    <% } %>
                </div>
            </div>

        </section>

        <section id="about">
            <h2>About Us</h2>
            <p>

                At Gaanare, we believe in the transformative power of music. Our platform is more than just a place to listen;
                it's a sanctuary for music lovers and enthusiasts alike. With a mission to bring the world of melodies closer to you, 
                Gaanare is your go-to destination for discovering, enjoying, and sharing the rhythm of life.
                <br>
                Artist Spotlight:
                Celebrate the artists who bring music to life. Our Artist Spotlight features delve into the stories behind the music,
                providing a deeper understanding of the creative minds shaping the industry.
                <br>
                Accessible Anywhere, Anytime:
                Whether you're at home, on the go, or exploring the world, Ganare is accessible anytime,
                anywhere. Take your favorite tunes with you and let the music be your companion.
                <br>
                Join us at Ganare and be part of a harmonious journey through the world of music. 
                Together, let's explore, experience, and embrace the extraordinary power of sound.
                <br>
                Feel the beat. Share the joy. Ganare - Where Music Lives.

            </p>
        </section>

        <section id="contact">
            <h2>Contact Us</h2>
            <p>Instagram: <a href="https://www.instagram.com/me_shailesh_003?igsh=OG8xc25lc3piZmJ0">Contact On@Instagram</a></p>
            <p>Phone: +91-00344334 </p>
            <br>

        </section>

        <section id="liked">
            <h2>Liked Song here</h2>
            <p>you liked a song of sidhu... </p>

            <br>
            <br>
            <br>


        </section>

        <div  class="footerDesign">
            <section id="contact">
                <h2>Contact Us</h2>

                <a href="mailto:meshailesh003@gmail.com"> <img src="./images/others/email.png" alt="gmail" style="width: 50px; height: 50px;">
                </a>
                <a href="https://www.instagram.com/me_shailesh_003?igsh=OG8xc25lc3piZmJ0"> <img src="./images/others/instagram.png" alt="instagram" style="width: 50px; height: 50px; padding-left: 30px;"> </a>

                <br>

            </section>


        </div>



        <%
            try {
                String songId = request.getParameter("id");
                System.out.println("Valueeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee" + songId);
                Connection cn = MyConnection.createConnection();
                Statement smt = cn.createStatement();
                ResultSet rs = smt.executeQuery("SELECT * FROM song WHERE id = " + songId);

                if (rs.next()) {

                    String songName = rs.getString(2);
                    String singerName = rs.getString(3);
                    String imageFileName = rs.getString(7);
                    String audioFileName = rs.getString(8);


        %>

        <div class="footer">
            <div class="player-container">
                <div class="player">

                    <div class="media-info">
                        <img src='images/Songs_image/<%= imageFileName%>' alt="Music Image" class="music-image">
                        <div class="track-info">
                            <p class="artist-name" style="height: 10.4px;"><%= singerName%></p>
                            <%

                            %>
                            <p style="color: #f1c105;" class="music-name"><%= songName%></p>

                        </div>
                    </div>

                    <div class="controls">

                        <img src="images/buttons/previous.png" class="prev-button" width='30' height='30' style="filter: brightness(0) invert(1);">
                        <img src="images/buttons/play.png" class="play-pause-button" width='30' height='30' style="filter: brightness(0) invert(1);">
                        <img src="images/buttons/next-button.png" class="next-button" width='30' height='30' style="filter: brightness(0) invert(1);">
                        <img src="images/buttons/loop.png" class="loop-button" width='30' height='30' style="filter: brightness(0) invert(1);">
                        <a href='Download_Songs?audioName="<%= audioFileName%>"'><img src="images/buttons/download.png" alt="download" width='30' height='30' style="filter: brightness(0) invert(1);"></a>

                        <script>
                            document.addEventListener('DOMContentLoaded', function () {
                                const audioPlayer = new Audio();
                                const playPauseButton = document.querySelector('.play-pause-button');
                                const prevButton = document.querySelector('.prev-button');
                                const nextButton = document.querySelector('.next-button');
                                const loopButton = document.querySelector('.loop-button');
                                const progressBar = document.querySelector('.progress-bar');

                                let isPlaying = false;
                                var currentTrackIndex = 0;

                            <%
                                session = request.getSession(true);
                                ArrayList<Map<String, String>> songsList = (ArrayList<Map<String, String>>) session.getAttribute("songsList");
                            %>
                                const trackList = [
                            <% for (Map<String, String> song : songsList) {%>
                                    {id: '<%= song.get("id")%>', artist: '<%= song.get("singerName")%>', title: '<%= song.get("songName")%>', source: 'songs/<%= song.get("audioFileName")%>', image: 'images/Songs_image/<%= song.get("imageFileName")%>'},
                            <% }%>

                                ];

                                const  userSongId = '<%= songId%>';
                            <% System.out.println("valueeeeeeeeeeee" + songId); %>
                                const songIndex = trackList.findIndex(track => track.id === userSongId);

                                if (songIndex !== -1)
                                {
                                    currentTrackIndex = songIndex;
                                } else {
                                    alert("Song not found in array");
                                }

                                loadTrack();

                                function loadTrack() {
                                    const currentTrack = trackList[currentTrackIndex];
                                    audioPlayer.src = currentTrack.source;

                                    document.querySelector('.music-image').src = currentTrack.image;
                                    document.querySelector('.artist-name').textContent = currentTrack.artist;
                                    document.querySelector('.music-name').textContent = currentTrack.title;

                                    audioPlayer.play();
                                    isPlaying = true;
                                    updatePlayPauseButtonIcon();
                                }

                                function updatePlayPauseButtonIcon() {

                                    if (isPlaying) {
                                        playPauseButton.src = 'images/buttons/pause.png';
                                    } else {
                                        playPauseButton.src = 'images/buttons/play.png';
                                    }
                                }

                                playPauseButton.addEventListener('click', togglePlayPause);
                                prevButton.addEventListener('click', playPrevious);
                                nextButton.addEventListener('click', playNext);
                                loopButton.addEventListener('click', toggleLoop);
                                progressBar.addEventListener('input', updateProgressBar);

                                audioPlayer.addEventListener('timeupdate', updateProgressBarOnTimeUpdate);

                                audioPlayer.addEventListener('ended', function () {

                                    playNext();
                                });

                                function togglePlayPause() {

                                    if (isPlaying) {
                                        audioPlayer.pause();
                                    } else {
                                        audioPlayer.play();
                                    }
                                    isPlaying = !isPlaying;
                                    updatePlayPauseButtonIcon();
                                }

                                function playPrevious() {
                                    currentTrackIndex = (currentTrackIndex - 1 + trackList.length) % trackList.length;
                                    loadTrack();
                                    if (isPlaying) {
                                        audioPlayer.play();
                                    }
                                }

                                function playNext() {
                                    currentTrackIndex = (currentTrackIndex + 1) % trackList.length;
                                    loadTrack();
                                    if (isPlaying) {
                                        audioPlayer.play();
                                    }
                                }

                                function toggleLoop() {
                                    audioPlayer.loop = !audioPlayer.loop;
                                    loopButton.classList.toggle('active', audioPlayer.loop);
                                }

                                function updateProgressBar() {
                                    const progress = progressBar.value / 100;
                                    audioPlayer.currentTime = progress * audioPlayer.duration;
                                }

                                function updateProgressBarOnTimeUpdate() {
                                    const progress = (audioPlayer.currentTime / audioPlayer.duration) * 100;
                                    progressBar.value = progress;
                                }
                            });
                        </script>
                    </div>

                    <input type="range" class="progress-bar" value="0" max="100">
                </div>
            </div>
            <%
                }
            %>
        </div>

        <%
                rs.close();
                smt.close();
                cn.close();
            } catch (Exception e) {
                out.println(e.getMessage());
            }
        %>
    </div>





</body>

</html>
