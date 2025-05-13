package com.ryjinwebapp.servlets;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/race-data")
public class RaceDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        try {
            // Try multiple possible paths for the text file
            String[] possiblePaths = {
                getServletContext().getRealPath("/raceData.txt"),  // Tomcat deployed path
                "C:\\web dev-25\\RyjinWebApp\\raceData.txt",      // Development path
                "raceData.txt"                                     // Relative path
            };

            String filePath = null;
            for (String path : possiblePaths) {
                if (Files.exists(Paths.get(path))) {
                    filePath = path;
                    break;
                }
            }

            if (filePath == null) {
                throw new IOException("raceData.txt not found in any of the expected locations");
            }

            System.out.println("Reading from file: " + filePath); // Debug log

            // Read the file content
            List<String> lines = Files.readAllLines(Paths.get(filePath));
            
            // Process the data
            Map<String, List<Map<String, String>>> processedData = processTextData(lines);
            
            // Convert to simple text format for response
            StringBuilder responseText = new StringBuilder();
            
            // Add drivers section
            responseText.append("DRIVERS\n");
            for (Map<String, String> driver : processedData.get("drivers")) {
                responseText.append("Driver: ").append(driver.get("driver")).append("\n");
                responseText.append("Nationality: ").append(driver.get("nationality")).append("\n");
                responseText.append("Date of Birth: ").append(driver.get("date of birth")).append("\n\n");
            }
            
            // Add teams section
            responseText.append("TEAMS\n");
            for (Map<String, String> team : processedData.get("teams")) {
                responseText.append("Team: ").append(team.get("team")).append("\n");
                responseText.append("World Championships: ").append(team.get("world championships")).append("\n");
                responseText.append("Base: ").append(team.get("base")).append("\n\n");
            }

            // Send the processed data as response
            response.getWriter().write(responseText.toString());

        } catch (Exception e) {
            response.getWriter().write("Error: " + e.getMessage());
            e.printStackTrace(); // Debug log
        }
    }

    private Map<String, List<Map<String, String>>> processTextData(List<String> lines) {
        Map<String, List<Map<String, String>>> result = new HashMap<>();
        List<Map<String, String>> drivers = new ArrayList<>();
        List<Map<String, String>> teams = new ArrayList<>();
        
        String currentSection = "";
        Map<String, String> currentObject = null;
        
        for (String line : lines) {
            line = line.trim();
            
            // Skip empty lines
            if (line.isEmpty()) continue;
            
            // Check for section headers
            if (line.equals("[DRIVERS]")) {
                currentSection = "DRIVERS";
                continue;
            } else if (line.equals("[TEAMS]")) {
                currentSection = "TEAMS";
                continue;
            }
            
            // Parse data lines
            if (line.contains(":")) {
                String[] parts = line.split(":", 2);
                String key = parts[0].trim();
                String value = parts[1].trim();
                
                if (currentSection.equals("DRIVERS")) {
                    if (key.equals("Driver")) {
                        if (currentObject != null) {
                            drivers.add(currentObject);
                        }
                        currentObject = new HashMap<>();
                    }
                    if (currentObject != null) {
                        currentObject.put(key.toLowerCase(), value);
                    }
                } else if (currentSection.equals("TEAMS")) {
                    if (key.equals("Team")) {
                        if (currentObject != null) {
                            teams.add(currentObject);
                        }
                        currentObject = new HashMap<>();
                    }
                    if (currentObject != null) {
                        currentObject.put(key.toLowerCase(), value);
                    }
                }
            }
        }
        
        // Add the last object
        if (currentObject != null) {
            if (currentSection.equals("DRIVERS")) {
                drivers.add(currentObject);
            } else if (currentSection.equals("TEAMS")) {
                teams.add(currentObject);
            }
        }
        
        result.put("drivers", drivers);
        result.put("teams", teams);
        
        return result;
    }
} 