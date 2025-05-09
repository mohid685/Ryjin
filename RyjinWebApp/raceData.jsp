<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.nio.file.Path" %>
<!DOCTYPE html>
<html>
<head>
    <title>Race Data Visualization</title>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <style>
        :root {
            --primary-color: #ff0000;
            --secondary-color: #1a1a1a;
            --accent-color: #ff3333;
            --text-color: #ffffff;
            --dark-bg: #0a0a0a;
            --card-bg: #1a1a1a;
            --border-color: #333;
            --glow-color: rgba(255, 0, 0, 0.3);
        }

        body {
            background-color: var(--dark-bg);
            color: var(--text-color);
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 20px;
            min-height: 100vh;
            overflow-x: hidden;
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
            padding: 20px;
            background: var(--secondary-color);
            border-radius: 8px;
            box-shadow: 0 0 15px var(--glow-color);
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 0, 0, 0.2), transparent);
            animation: shine 3s infinite;
        }

        @keyframes shine {
            0% { left: -100%; }
            20%, 100% { left: 100%; }
        }

        .header h1 {
            color: var(--primary-color);
            font-family: 'Orbitron', sans-serif;
            text-shadow: 0 0 10px var(--glow-color);
            margin: 0;
            font-size: 2.2rem;
            letter-spacing: 2px;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .graph-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 25px;
            max-width: 1400px;
            margin: 0 auto;
            perspective: 1000px;
        }

        .graph {
            background: var(--card-bg);
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 0 15px var(--glow-color);
            border: 1px solid var(--border-color);
            transform-style: preserve-3d;
            transition: transform 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .graph:hover {
            transform: translateZ(20px) rotateX(5deg);
        }

        .graph::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, transparent, rgba(255, 0, 0, 0.1), transparent);
            animation: scan 2s linear infinite;
        }

        @keyframes scan {
            0% { transform: translateY(-100%); }
            100% { transform: translateY(100%); }
        }

        .graph-title {
            color: var(--primary-color);
            font-family: 'Orbitron', sans-serif;
            text-align: center;
            margin: 0 0 25px 0;
            font-size: 1.4rem;
            letter-spacing: 1px;
            text-shadow: 0 0 8px var(--glow-color);
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border-color);
            position: relative;
        }

        .graph-title::after {
            content: '';
            position: absolute;
            bottom: -1px;
            left: 0;
            width: 100%;
            height: 2px;
            background: var(--primary-color);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .graph:hover .graph-title::after {
            transform: scaleX(1);
        }

        .canvas-container {
            position: relative;
            width: 100%;
            height: 300px;
            margin-top: 20px;
        }

        .error-message {
            color: var(--accent-color);
            text-align: center;
            padding: 40px;
            font-family: 'Orbitron', sans-serif;
            border: 2px solid var(--accent-color);
            border-radius: 10px;
            max-width: 800px;
            margin: 50px auto;
            background: rgba(255, 51, 51, 0.05);
            box-shadow: 0 0 20px rgba(255, 0, 0, 0.2);
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .speed-lines {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
        }

        .speed-line {
            position: absolute;
            width: 100%;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--primary-color), transparent);
            opacity: 0.5;
            animation: speedLine 2s linear infinite;
        }

        @keyframes speedLine {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }
    </style>
</head>
<body>
    <div class="speed-lines" id="speedLines"></div>
    
    <div class="header">
        <h1>RACE DATA VISUALIZATION</h1>
    </div>

    <div id="errorMessage" class="error-message" style="display: none;">
        <h2>ERROR LOADING RACE DATA</h2>
        <p id="errorText"></p>
    </div>

    <div id="graphContainer" class="graph-container" style="display: none;">
        <!-- Graphs will be inserted here -->
    </div>

    <script>
        // Create speed lines
        const speedLines = document.getElementById('speedLines');
        for (let i = 0; i < 10; i++) {
            const line = document.createElement('div');
            line.className = 'speed-line';
            line.style.top = `${Math.random() * 100}%`;
            line.style.animation = `speedLine ${1 + Math.random() * 2}s linear infinite`;
            speedLines.appendChild(line);
        }

        // Get the race data directly from the JSP
        const raceData = <%
            try {
                String realPath = application.getRealPath("/");
                Path filePath = Paths.get(realPath, "raceData.txt");
                String data = new String(Files.readAllBytes(filePath));
                out.print(data);
            } catch (Exception e) {
                out.print("{\"error\": \"Failed to load race data: " + e.getMessage() + "\"}");
            }
        %>;

        // Display graphs if data loaded successfully
        if (raceData.error) {
            showError(raceData.error);
        } else {
            displayGraphs(raceData);
        }

        function displayGraphs(data) {
            const container = document.getElementById('graphContainer');
            container.style.display = 'grid';

            // Drivers by Nationality (Pie Chart)
            const nationalityGraph = createGraph('DRIVERS BY NATIONALITY');
            const nationalityCount = {};
            
            data.drivers.forEach(driver => {
                nationalityCount[driver.nationality] = (nationalityCount[driver.nationality] || 0) + 1;
            });

            const nationalityCanvas = document.createElement('canvas');
            nationalityGraph.appendChild(nationalityCanvas);
            
            new Chart(nationalityCanvas, {
                type: 'pie',
                data: {
                    labels: Object.keys(nationalityCount),
                    datasets: [{
                        data: Object.values(nationalityCount),
                        backgroundColor: generateColors(Object.keys(nationalityCount).length)
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'right',
                            labels: {
                                color: '#ffffff',
                                font: {
                                    family: 'Orbitron'
                                }
                            }
                        }
                    }
                }
            });

            container.appendChild(nationalityGraph);

            // Teams by Championships (3D Bar Chart)
            const championshipsGraph = createGraph('TEAMS BY CHAMPIONSHIPS');
            const teams = [...data.teams].sort((a, b) => 
                parseInt(b.world_championships) - parseInt(a.world_championships));

            const championshipsCanvas = document.createElement('canvas');
            championshipsGraph.appendChild(championshipsCanvas);
            
            new Chart(championshipsCanvas, {
                type: 'bar',
                data: {
                    labels: teams.map(team => team.name),
                    datasets: [{
                        label: 'World Championships',
                        data: teams.map(team => team.world_championships),
                        backgroundColor: 'rgba(255, 0, 0, 0.7)',
                        borderColor: 'rgba(255, 0, 0, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(255, 255, 255, 0.1)'
                            },
                            ticks: {
                                color: '#ffffff'
                            }
                        },
                        x: {
                            grid: {
                                color: 'rgba(255, 255, 255, 0.1)'
                            },
                            ticks: {
                                color: '#ffffff'
                            }
                        }
                    }
                }
            });

            container.appendChild(championshipsGraph);

            // Drivers Age Distribution (Doughnut Chart)
            const ageGraph = createGraph('DRIVERS AGE DISTRIBUTION');
            const ageGroups = {
                '18-22': 0,
                '23-27': 0,
                '28-32': 0,
                '33+': 0
            };

            const currentYear = new Date().getFullYear();
            data.drivers.forEach(driver => {
                const birthYear = parseInt(driver.date_of_birth.substring(0, 4));
                const age = currentYear - birthYear;

                if (age >= 18 && age <= 22) ageGroups['18-22']++;
                else if (age <= 27) ageGroups['23-27']++;
                else if (age <= 32) ageGroups['28-32']++;
                else ageGroups['33+']++;
            });

            const ageCanvas = document.createElement('canvas');
            ageGraph.appendChild(ageCanvas);
            
            new Chart(ageCanvas, {
                type: 'doughnut',
                data: {
                    labels: Object.keys(ageGroups).map(group => group + ' years'),
                    datasets: [{
                        data: Object.values(ageGroups),
                        backgroundColor: generateColors(Object.keys(ageGroups).length)
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'right',
                            labels: {
                                color: '#ffffff',
                                font: {
                                    family: 'Orbitron'
                                }
                            }
                        }
                    }
                }
            });

            container.appendChild(ageGraph);
        }

        function createGraph(title) {
            const graph = document.createElement('div');
            graph.className = 'graph';
            
            const titleElement = document.createElement('h3');
            titleElement.className = 'graph-title';
            titleElement.textContent = title;
            
            graph.appendChild(titleElement);
            return graph;
        }

        function generateColors(count) {
            const colors = [];
            for (let i = 0; i < count; i++) {
                const hue = (i * 360 / count) % 360;
                colors.push(`hsla(${hue}, 100%, 50%, 0.7)`);
            }
            return colors;
        }

        function showError(message) {
            const errorText = document.getElementById('errorText');
            const errorMessage = document.getElementById('errorMessage');
            errorText.textContent = message;
            errorMessage.style.display = 'block';
        }
    </script>
</body>
</html> 