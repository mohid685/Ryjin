<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.nio.file.Path" %>
<!DOCTYPE html>
<html>
<head>
    <title>Race Data Visualization</title>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/CountUp.js/2.0.8/countUp.min.js"></script>
    <style>
        :root {
            --primary-color: #ff0000;
            --secondary-color: #1a1a1a;
            --accent-color: #ff3333;
            --accent-blue: #00ccff;
            --accent-yellow: #ffcc00;
            --text-color: #ffffff;
            --dark-bg: #0a0a0a;
            --card-bg: #1a1a1a;
            --border-color: #333;
            --glow-color: rgba(255, 0, 0, 0.3);
            --blue-glow: rgba(0, 204, 255, 0.3);
            --yellow-glow: rgba(255, 204, 0, 0.3);
        }

        body {
            background-color: var(--dark-bg);
            color: var(--text-color);
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            background-image: 
                radial-gradient(circle at 10% 20%, rgba(255, 0, 0, 0.05) 0%, transparent 50%),
                radial-gradient(circle at 90% 80%, rgba(0, 204, 255, 0.05) 0%, transparent 50%);
        }

        .header {
            text-align: center;
            padding: 30px 20px;
            background: linear-gradient(90deg, rgba(26,26,26,0.95) 0%, rgba(10,10,10,0.98) 50%, rgba(26,26,26,0.95) 100%);
            border-bottom: 2px solid var(--border-color);
            box-shadow: 0 0 25px var(--glow-color);
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--primary-color), transparent);
            animation: scanline 4s linear infinite;
        }

        @keyframes scanline {
            0% { left: -100%; }
            100% { left: 100%; }
        }

        .header h1 {
            color: var(--primary-color);
            font-family: 'Orbitron', sans-serif;
            text-shadow: 0 0 15px var(--glow-color);
            margin: 0;
            font-size: 2.5rem;
            letter-spacing: 3px;
            position: relative;
            display: inline-block;
        }

        .header h1::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 100%;
            height: 2px;
            background: var(--primary-color);
            box-shadow: 0 0 10px var(--glow-color);
        }

        .dashboard {
            max-width: 1600px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .stats-bar {
            display: flex;
            justify-content: space-around;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 20px;
        }

        .stat-card {
            background: var(--card-bg);
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            min-width: 150px;
            flex: 1;
            box-shadow: 0 0 15px rgba(255, 0, 0, 0.15);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0 20px var(--glow-color);
        }

        .stat-card.blue {
            box-shadow: 0 0 15px var(--blue-glow);
        }
        
        .stat-card.blue:hover {
            box-shadow: 0 0 20px var(--blue-glow);
        }
        
        .stat-card.yellow {
            box-shadow: 0 0 15px var(--yellow-glow);
        }
        
        .stat-card.yellow:hover {
            box-shadow: 0 0 20px var(--yellow-glow);
        }

        .stat-value {
            font-size: 2.2rem;
            font-weight: 700;
            margin: 10px 0;
            font-family: 'Orbitron', sans-serif;
            background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .stat-card.blue .stat-value {
            background: linear-gradient(90deg, var(--accent-blue), #0099cc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .stat-card.yellow .stat-value {
            background: linear-gradient(90deg, var(--accent-yellow), #cc9900);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .stat-label {
            font-size: 0.9rem;
            color: #bbb;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .graph-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .graph {
            background: var(--card-bg);
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 0 15px var(--glow-color);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .graph::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, transparent, var(--primary-color), transparent);
        }

        .graph:hover {
            transform: translateY(-5px);
            box-shadow: 0 0 25px var(--glow-color);
        }

        .graph.blue {
            box-shadow: 0 0 15px var(--blue-glow);
        }
        
        .graph.blue:hover {
            box-shadow: 0 0 25px var(--blue-glow);
        }
        
        .graph.blue::before {
            background: linear-gradient(90deg, transparent, var(--accent-blue), transparent);
        }
        
        .graph.yellow {
            box-shadow: 0 0 15px var(--yellow-glow);
        }
        
        .graph.yellow:hover {
            box-shadow: 0 0 25px var(--yellow-glow);
        }
        
        .graph.yellow::before {
            background: linear-gradient(90deg, transparent, var(--accent-yellow), transparent);
        }

        .graph-title {
            color: var(--primary-color);
            font-family: 'Orbitron', sans-serif;
            text-align: center;
            margin: 0 0 25px 0;
            font-size: 1.4rem;
            letter-spacing: 1px;
            text-shadow: 0 0 8px var(--glow-color);
            padding-bottom: 15px;
            border-bottom: 1px solid var(--border-color);
        }

        .graph.blue .graph-title {
            color: var(--accent-blue);
            text-shadow: 0 0 8px var(--blue-glow);
        }
        
        .graph.yellow .graph-title {
            color: var(--accent-yellow);
            text-shadow: 0 0 8px var(--yellow-glow);
        }

        .bar-container {
            margin-bottom: 15px;
        }

        .bar-label {
            color: var(--text-color);
            margin-bottom: 8px;
            display: flex;
            justify-content: space-between;
            font-size: 0.95rem;
        }

        .bar {
            height: 25px;
            background: var(--border-color);
            border-radius: 5px;
            overflow: hidden;
            box-shadow: inset 0 0 5px rgba(0,0,0,0.5);
            position: relative;
        }

        .bar-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
            border-radius: 5px;
            transition: width 1.2s cubic-bezier(0.22, 1, 0.36, 1);
            box-shadow: 0 0 10px var(--glow-color);
            position: relative;
        }

        .graph.blue .bar-fill {
            background: linear-gradient(90deg, var(--accent-blue), #0099cc);
            box-shadow: 0 0 10px var(--blue-glow);
        }
        
        .graph.yellow .bar-fill {
            background: linear-gradient(90deg, var(--accent-yellow), #cc9900);
            box-shadow: 0 0 10px var(--yellow-glow);
        }

        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
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
        }

        .two-columns {
            grid-column: span 2;
        }

        @media (max-width: 1200px) {
            .two-columns {
                grid-column: span 1;
            }
        }

        .driver-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }

        .driver-card {
            background: rgba(26, 26, 26, 0.7);
            border-radius: 8px;
            padding: 15px;
            text-align: center;
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .driver-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0 15px var(--glow-color);
            background: rgba(26, 26, 26, 0.9);
        }

        .driver-number {
            font-family: 'Orbitron', sans-serif;
            font-size: 1.8rem;
            color: var(--primary-color);
            margin: 0;
            text-shadow: 0 0 5px var(--glow-color);
        }

        .driver-name {
            font-weight: 500;
            margin: 10px 0 5px;
            font-size: 0.95rem;
        }

        .driver-nationality {
            font-size: 0.8rem;
            color: #aaa;
            margin: 0;
        }

        .legend {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 15px;
            margin-top: 20px;
        }

        .legend-item {
            display: flex;
            align-items: center;
            margin-right: 15px;
        }

        .legend-color {
            width: 15px;
            height: 15px;
            border-radius: 50%;
            margin-right: 8px;
        }

        .pie-tooltip {
            background: rgba(26, 26, 26, 0.95);
            border-radius: 5px;
            padding: 10px;
            border: 1px solid var(--border-color);
            font-family: 'Roboto', sans-serif;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.5);
        }

        .chart-container {
            height: 300px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>RACE DATA VISUALIZATION</h1>
    </div>

    <div class="dashboard">
        <div id="graphContainer" class="graph-container" style="display: none;">
            <!-- Graphs will be inserted here -->
        </div>

        <div id="driverContainer" class="graph-container" style="display: none;">
            <!-- Driver information will be inserted here -->
        </div>
    </div>

    <script>
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

        // Chart.js color palette
        const colors = [
            'rgba(255, 0, 0, 0.8)',
            'rgba(0, 204, 255, 0.8)',
            'rgba(255, 204, 0, 0.8)',
            'rgba(0, 255, 102, 0.8)',
            'rgba(153, 51, 255, 0.8)',
            'rgba(255, 102, 0, 0.8)',
            'rgba(0, 153, 204, 0.8)',
            'rgba(204, 0, 102, 0.8)',
            'rgba(102, 204, 0, 0.8)',
            'rgba(204, 102, 255, 0.8)',
            'rgba(255, 153, 0, 0.8)',
            'rgba(0, 102, 153, 0.8)',
        ];

        const borderColors = [
            'rgba(255, 0, 0, 1)',
            'rgba(0, 204, 255, 1)',
            'rgba(255, 204, 0, 1)',
            'rgba(0, 255, 102, 1)',
            'rgba(153, 51, 255, 1)',
            'rgba(255, 102, 0, 1)',
            'rgba(0, 153, 204, 1)',
            'rgba(204, 0, 102, 1)',
            'rgba(102, 204, 0, 1)',
            'rgba(204, 102, 255, 1)', 
            'rgba(255, 153, 0, 1)',
            'rgba(0, 102, 153, 1)',
        ];

        // Display data if loaded successfully
        if (raceData.error) {
            showError(raceData.error);
        } else {
            displayGraphs(raceData);
            displayDrivers(raceData);
        }

        function displayGraphs(data) {
            const container = document.getElementById('graphContainer');
            container.style.display = 'grid';

            // Drivers by Nationality Graph (Bar Chart)
            const nationalityGraph = createGraph('DRIVERS BY NATIONALITY', '');
            const nationalityCount = {};
            
            data.drivers.forEach(driver => {
                nationalityCount[driver.nationality] = (nationalityCount[driver.nationality] || 0) + 1;
            });

            Object.entries(nationalityCount)
                .sort((a, b) => a[0].localeCompare(b[0]))
                .forEach(([nationality, count]) => {
                    const percentage = (count * 100) / data.drivers.length;
                    addBar(nationalityGraph, nationality, count, percentage);
                });

            container.appendChild(nationalityGraph);

            // Teams by Championships Graph
            const championshipsGraph = createGraph('TEAMS BY CHAMPIONSHIPS', 'blue');
            const teams = [...data.teams].sort((a, b) => 
                parseInt(b.world_championships) - parseInt(a.world_championships));
            const maxChampionships = parseInt(teams[0].world_championships);

            teams.forEach(team => {
                const percentage = (parseInt(team.world_championships) * 100) / maxChampionships;
                addBar(championshipsGraph, team.name, team.world_championships, percentage, 'blue');
            });

            container.appendChild(championshipsGraph);

            // Drivers Age Distribution (Pie Chart)
            const ageGraph = createGraph('DRIVERS AGE DISTRIBUTION', 'yellow');
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
            ageCanvas.id = 'ageChart';
            const ageChartContainer = document.createElement('div');
            ageChartContainer.className = 'chart-container';
            ageChartContainer.appendChild(ageCanvas);
            ageGraph.appendChild(ageChartContainer);
            
            container.appendChild(ageGraph);

            // Initialize age distribution pie chart
            setTimeout(() => {
                createAgeDistributionPieChart(ageGroups);
            }, 100);
        }

        function createGraph(title, colorClass) {
            const graph = document.createElement('div');
            graph.className = `graph ${colorClass}`;
            
            const titleElement = document.createElement('h3');
            titleElement.className = 'graph-title';
            titleElement.textContent = title;
            
            graph.appendChild(titleElement);
            return graph;
        }

        function addBar(graph, label, value, percentage, colorClass) {
            const container = document.createElement('div');
            container.className = 'bar-container';

            const labelDiv = document.createElement('div');
            labelDiv.className = 'bar-label';
            
            const labelSpan = document.createElement('span');
            labelSpan.textContent = label;
            
            const valueSpan = document.createElement('span');
            valueSpan.textContent = value + ' (' + Math.round(percentage) + '%)';
            
            labelDiv.appendChild(labelSpan);
            labelDiv.appendChild(valueSpan);

            const bar = document.createElement('div');
            bar.className = 'bar';

            const fill = document.createElement('div');
            fill.className = `bar-fill ${colorClass ? colorClass : ''}`;
            fill.style.width = '0%';

            bar.appendChild(fill);
            container.appendChild(labelDiv);
            container.appendChild(bar);
            graph.appendChild(container);

            // Set the width after a small delay to trigger animation
            setTimeout(() => {
                fill.style.width = percentage + '%';
            }, 50);
        }

        function createAgeDistributionPieChart(ageGroups) {
            const ctx = document.getElementById('ageChart').getContext('2d');
            
            const labels = Object.keys(ageGroups);
            const data = labels.map(age => ageGroups[age]);
            
            new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: labels,
                    datasets: [{
                        data: data,
                        backgroundColor: [
                            'rgba(255, 204, 0, 0.8)',
                            'rgba(255, 153, 0, 0.8)',
                            'rgba(255, 102, 0, 0.8)',
                            'rgba(255, 51, 0, 0.8)'
                        ],
                        borderColor: [
                            'rgba(255, 204, 0, 1)',
                            'rgba(255, 153, 0, 1)',
                            'rgba(255, 102, 0, 1)',
                            'rgba(255, 51, 0, 1)'
                        ],
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                color: '#fff',
                                font: {
                                    family: 'Roboto',
                                    size: 12
                                },
                                padding: 15
                            }
                        },
                        tooltip: {
                            backgroundColor: 'rgba(26, 26, 26, 0.95)',
                            titleFont: {
                                family: 'Roboto',
                                size: 14,
                                weight: 'bold'
                            },
                            bodyFont: {
                                family: 'Roboto',
                                size: 13
                            },
                            borderColor: '#333',
                            borderWidth: 1
                        }
                    },
                    animation: {
                        animateScale: true,
                        animateRotate: true,
                        duration: 2000,
                        easing: 'easeOutQuart'
                    }
                }
            });
        }

        function showError(message) {
            const errorText = document.getElementById('errorText');
            const errorMessage = document.getElementById('errorMessage');
            errorText.textContent = message;
            errorMessage.style.display = 'block';
        }

        // Add glowing effect when scrolling
        window.addEventListener('scroll', function() {
            const elements = document.querySelectorAll('.graph');
            elements.forEach(el => {
                const rect = el.getBoundingClientRect();
                const isVisible = (
                    rect.top < window.innerHeight && 
                    rect.bottom >= 0
                );
                
                if (isVisible) {
                    el.style.opacity = '1';
                    el.style.transform = 'translateY(0)';
                }
            });
        });

        // Add initial animation on load
        document.addEventListener('DOMContentLoaded', function() {
            const graphs = document.querySelectorAll('.graph');
            graphs.forEach((graph, index) => {
                setTimeout(() => {
                    graph.style.opacity = '1';
                    graph.style.transform = 'translateY(0)';
                }, 100 * index);
            });
        });
    </script>
</body>
</html>