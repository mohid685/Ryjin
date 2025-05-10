<%@ page import="org.json.JSONObject, org.json.JSONArray, java.io.File, java.nio.file.Files" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Read the race data file
    String filePath = application.getRealPath("/raceData.txt");
    String content = new String(Files.readAllBytes(new File(filePath).toPath()));
    JSONObject raceData = new JSONObject(content);

    // Extract drivers and teams
    JSONArray drivers = raceData.getJSONArray("drivers");
    JSONArray teams = raceData.getJSONArray("teams");

    // Helper function to count items by property
    function countByProperty(array, property) {
        Map<String, Integer> counts = new HashMap<>();
        for (int i = 0; i < array.length(); i++) {
            String value = array.getJSONObject(i).getString(property);
            counts.put(value, counts.getOrDefault(value, 0) + 1);
        }
        return counts;
    }

    // Get statistics
    Map<String, Integer> nationalityCount = countByProperty(drivers, "nationality");
    Map<String, Integer> teamDriverCount = countByProperty(teams, "name");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Race Data Statistics</title>
    <style>
        body {
            font-family: 'Rajdhani', sans-serif;
            background: #0a0a0a;
            color: #ffffff;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        h1, h2 {
            color: #ff0000;
            text-shadow: 0 0 10px rgba(255, 0, 0, 0.3);
            font-family: 'Orbitron', sans-serif;
        }
        .chart-container {
            background: #1a1a1a;
            border: 1px solid #333;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 0 20px rgba(255, 0, 0, 0.1);
        }
        .bar-chart {
            display: flex;
            height: 300px;
            align-items: flex-end;
            gap: 10px;
            margin-top: 20px;
        }
        .bar {
            flex: 1;
            background: linear-gradient(to top, #ff0000, #cc0000);
            position: relative;
            min-width: 30px;
            transition: height 0.5s ease;
        }
        .bar-label {
            position: absolute;
            bottom: -25px;
            left: 0;
            right: 0;
            text-align: center;
            font-size: 12px;
            color: #ccc;
        }
        .bar-value {
            position: absolute;
            top: -25px;
            left: 0;
            right: 0;
            text-align: center;
            font-size: 12px;
        }
        .pie-chart {
            width: 300px;
            height: 300px;
            border-radius: 50%;
            margin: 20px auto;
            position: relative;
            background: conic-gradient(
                <%
                String[] colors = {"#ff0000", "#cc0000", "#990000", "#660000", "#330000"};
                int colorIndex = 0;
                for (Map.Entry<String, Integer> entry : nationalityCount.entrySet()) {
                    double percentage = (entry.getValue() * 100.0) / drivers.length();
                    if (colorIndex > 0) out.print(", ");
                    out.print(colors[colorIndex % colors.length] + " " + (colorIndex == 0 ? "0" : "") + "% " + percentage + "%");
                    colorIndex++;
                }
                %>
            );
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        .stat-card {
            background: #1a1a1a;
            border: 1px solid #333;
            padding: 15px;
            text-align: center;
        }
        .stat-value {
            font-size: 2.5rem;
            color: #ff0000;
            margin: 10px 0;
            font-family: 'Orbitron', sans-serif;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #333;
            padding: 8px;
            text-align: left;
        }
        th {
            background: #ff0000;
            color: white;
        }
        tr:nth-child(even) {
            background: #1a1a1a;
        }
        tr:hover {
            background: #2a2a2a;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Race Data Statistics</h1>

        <div class="chart-container">
            <h2>Drivers by Nationality</h2>
            <div class="pie-chart"></div>
            <div class="stats-grid">
                <% for (Map.Entry<String, Integer> entry : nationalityCount.entrySet()) { %>
                    <div class="stat-card">
                        <h3><%= entry.getKey() %></h3>
                        <div class="stat-value"><%= entry.getValue() %></div>
                </div>
                <% } %>
            </div>
            </div>

        <div class="chart-container">
            <h2>Drivers per Team</h2>
            <div class="bar-chart">
                <% for (Map.Entry<String, Integer> entry : teamDriverCount.entrySet()) {
                    int height = entry.getValue() * 30; // Scale for visibility
                %>
                    <div class="bar" style="height: <%= height %>px;">
                        <div class="bar-value"><%= entry.getValue() %></div>
                        <div class="bar-label"><%= entry.getKey() %></div>
                </div>
                <% } %>
            </div>
            </div>

        <div class="chart-container">
            <h2>Teams Overview</h2>
            <table>
                <tr>
                    <th>Team</th>
                    <th>Base</th>
                    <th>Principal</th>
                    <th>Championships</th>
                    <th>Drivers</th>
                </tr>
                <% for (int i = 0; i < teams.length(); i++) {
                    JSONObject team = teams.getJSONObject(i);
                    JSONArray base = team.getJSONArray("base");
                    JSONArray teamDrivers = team.getJSONArray("drivers");
                %>
                    <tr>
                        <td><%= team.getString("name") %></td>
                        <td><%= base.getString(0) %>, <%= base.getString(1) %></td>
                        <td><%= team.getString("team_principal") %></td>
                        <td><%= team.getInt("world_championships") %></td>
                        <td>
                            <% for (int j = 0; j < teamDrivers.length(); j++) {
                                String driverId = teamDrivers.getString(j);
                                for (int k = 0; k < drivers.length(); k++) {
                                    JSONObject driver = drivers.getJSONObject(k);
                                    if (driver.getString("id").equals(driverId)) {
                                        out.print(driver.getString("full_name"));
                                        if (j < teamDrivers.length() - 1) out.print(", ");
                                        break;
                                    }
                                }
                            } %>
                        </td>
                    </tr>
                <% } %>
            </table>
        </div>
    </div>
</body>
</html>