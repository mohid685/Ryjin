<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Java console logging
    System.out.println("=== Racing World Page Loaded ===");
    System.out.println("GET Request received at: " + new java.util.Date());
    System.out.println("User Agent: " + request.getHeader("User-Agent"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Racing World - Ryjin</title>
    <link rel="stylesheet" href="./style.css">
    <link href="https://fonts.googleapis.com/css2?family=Rajdhani:wght@500;700&family=Orbitron:wght@700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #ff0000;
            --text-color: #ffffff;
            --border-color: #333333;
            --glow-color: rgba(255, 0, 0, 0.5);
            --bg-color: #121212;
        }

        body.dark-theme {
            background-color: var(--bg-color);
            color: var(--text-color);
            font-family: 'Rajdhani', sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 0;
        }

        .racing-world-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .section {
            background: linear-gradient(145deg, #1a1a1a, #2a2a2a);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 0 20px var(--glow-color);
        }

        .section-title {
            font-family: 'Orbitron', sans-serif;
            color: var(--primary-color);
            font-size: 1.8rem;
            margin-bottom: 20px;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .content-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .card {
            background: rgba(26, 26, 26, 0.8);
            border: 1px solid var(--border-color);
            border-radius: 6px;
            padding: 15px;
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px var(--glow-color);
        }

        .card-title {
            color: var(--text-color);
            font-size: 1.2rem;
            margin-bottom: 10px;
            font-family: 'Orbitron', sans-serif;
        }

        .card-content {
            color: #ccc;
            font-size: 0.9rem;
            line-height: 1.5;
        }

        .news-item {
            border-left: 3px solid var(--primary-color);
            padding-left: 15px;
            margin-bottom: 15px;
        }

        .news-date {
            color: #666;
            font-size: 0.8rem;
            margin-bottom: 5px;
        }

        .standings-table {
            width: 100%;
            border-collapse: collapse;
        }

        .standings-table th,
        .standings-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }

        .standings-table th {
            color: var(--primary-color);
            font-family: 'Orbitron', sans-serif;
        }

        .back-btn {
            background: linear-gradient(145deg, #ff0000, #cc0000);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-family: 'Orbitron', sans-serif;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px var(--glow-color);
        }

        .back-btn i {
            font-size: 1.2rem;
        }

        .back-btn.close-btn {
            background: linear-gradient(145deg, #cc0000, #ff0000);
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
        }

        .back-btn.close-btn:hover {
            background: linear-gradient(145deg, #ff0000, #cc0000);
        }

        .loading {
            text-align: center;
            padding: 20px;
            color: var(--text-color);
        }

        .error {
            color: #ff3333;
            text-align: center;
            padding: 20px;
        }

        /* News Slider Styles */
        .news-slider {
            position: relative;
            overflow: hidden;
            height: 600px;
            background: rgba(26, 26, 26, 0.8);
            border-radius: 8px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }

        .news-slide {
            position: absolute;
            width: 100%;
            height: 100%;
            opacity: 0;
            transform: translateX(100%);
            transition: all 0.7s cubic-bezier(0.65, 0, 0.35, 1);
            padding: 30px;
            background: linear-gradient(145deg, #1a1a1a, #2a2a2a);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            display: flex;
            flex-direction: column;
        }

        .news-slide.active {
            opacity: 1;
            transform: translateX(0);
            z-index: 2;
        }

        .news-slide.prev {
            transform: translateX(-100%);
            z-index: 1;
        }

        .news-slide.next {
            transform: translateX(100%);
            z-index: 1;
        }

        .news-slide.exiting {
            transform: translateX(-100%);
            opacity: 0;
            transition: all 0.7s cubic-bezier(0.65, 0, 0.35, 1);
        }

        .news-content {
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .news-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--primary-color);
        }

        .news-date {
            color: var(--primary-color);
            font-family: 'Orbitron', sans-serif;
            font-size: 0.9rem;
            letter-spacing: 1px;
        }

        .news-category {
            background: rgba(255, 0, 0, 0.2);
            color: var(--primary-color);
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.8rem;
            text-transform: uppercase;
            font-weight: bold;
            letter-spacing: 1px;
        }

        .news-title {
            font-family: 'Orbitron', sans-serif;
            font-size: 2rem;
            color: var(--text-color);
            margin-bottom: 20px;
            line-height: 1.4;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
        }

        .news-summary {
            color: #ccc;
            font-size: 1.1rem;
            line-height: 1.7;
            flex-grow: 1;
            margin-bottom: 20px;
        }

        .news-image {
            height: 300px;
            background-size: cover;
            background-position: center;
            border-radius: 6px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5);
            position: relative;
            overflow: hidden;
        }

        .news-image::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 60%;
            background: linear-gradient(to top, rgba(0, 0, 0, 0.8), transparent);
        }

        .news-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: auto;
            padding-top: 15px;
            border-top: 1px solid var(--border-color);
        }

        .news-source {
            color: #888;
            font-size: 0.9rem;
            font-style: italic;
        }

        .news-tags {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .news-tag {
            background: rgba(255, 0, 0, 0.1);
            color: var(--primary-color);
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            border: 1px solid rgba(255, 0, 0, 0.3);
        }

        .slider-controls {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 10px;
            z-index: 10;
        }

        .slider-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            cursor: pointer;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .slider-dot.active {
            background: var(--primary-color);
            box-shadow: 0 0 10px var(--glow-color);
            transform: scale(1.2);
        }

        .slider-arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(0, 0, 0, 0.5);
            color: var(--text-color);
            border: none;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            z-index: 10;
            border: 1px solid rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(5px);
        }

        .slider-arrow:hover {
            background: var(--primary-color);
            box-shadow: 0 0 15px var(--glow-color);
            transform: translateY(-50%) scale(1.1);
        }

        .slider-prev {
            left: 25px;
        }

        .slider-next {
            right: 25px;
        }

        .read-more {
            display: inline-block;
            background: rgba(255, 0, 0, 0.2);
            color: var(--primary-color);
            padding: 8px 20px;
            border-radius: 20px;
            text-decoration: none;
            font-size: 0.9rem;
            margin-top: 15px;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 0, 0, 0.3);
        }

        .read-more:hover {
            background: rgba(255, 0, 0, 0.3);
            transform: translateY(-2px);
            box-shadow: 0 2px 10px rgba(255, 0, 0, 0.2);
        }

        /* Animation for news ticker */
        @keyframes slideInFromRight {
            0% {
                transform: translateX(100%);
                opacity: 0;
            }
            100% {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes slideOutToLeft {
            0% {
                transform: translateX(0);
                opacity: 1;
            }
            100% {
                transform: translateX(-100%);
                opacity: 0;
            }
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .news-slider {
                height: 650px;
            }
            
            .news-title {
                font-size: 1.6rem;
            }
            
            .news-summary {
                font-size: 1rem;
            }
            
            .news-image {
                height: 200px;
            }
            
            .slider-arrow {
                width: 40px;
                height: 40px;
            }
        }

        @media (max-width: 480px) {
            .news-slider {
                height: 700px;
            }
            
            .news-title {
                font-size: 1.4rem;
            }
            
            .news-summary {
                font-size: 0.9rem;
            }
            
            .news-image {
                height: 150px;
            }
            
            .news-footer {
                flex-direction: column;
                gap: 10px;
                align-items: flex-start;
            }
            
            .news-tags {
                justify-content: flex-start;
                width: 100%;
            }
        }
    </style>
</head>
<body class="dark-theme">
    <div class="racing-world-container">
        <button class="back-btn close-btn" onclick="window.close()">
            <i class="fas fa-times"></i> Close Window
        </button>

        <div class="section">
            <h2 class="section-title">Latest Racing News</h2>
            <div id="newsContent" class="news-slider">
                <!-- Slide 1 -->
                <div class="news-slide active" data-slide="1">
                    <div class="news-content">
                        <div class="news-header">
                            <span class="news-date">MARCH 15, 2024</span>
                            <span class="news-category">FORMULA 1</span>
                        </div>
                        <div class="news-image" style="background-image: url('https://unsplash.com/photos/red-ferrari-car-on-gray-concrete-floor-fycKCUH24Ck');"></div>
                        <h3 class="news-title">Hamilton Announces Shock Move to Ferrari for 2025 Season</h3>
                        <p class="news-summary">Seven-time world champion Lewis Hamilton will join Ferrari in 2025, ending his successful partnership with Mercedes after 12 seasons. This historic move marks one of the biggest driver transfers in Formula 1 history. Hamilton signed a multi-year contract with the Italian team, replacing Carlos Sainz. The announcement sent shockwaves through the motorsport world, with fans and analysts speculating about the implications for both teams.</p>
                        
                        <div class="news-footer">
                            <!-- <span class="news-source">Motorsport Weekly • 15 min ago</span> -->
                            <div class="news-tags">
                                <span class="news-tag">Hamilton</span>
                                <span class="news-tag">Ferrari</span>
                                <span class="news-tag">2025 Season</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Slide 2 -->
                <div class="news-slide" data-slide="2">
                    <div class="news-content">
                        <div class="news-header">
                            <span class="news-date">MARCH 14, 2024</span>
                            <span class="news-category">ENDURANCE</span>
                        </div>
                        <div class="news-image" style="background-image: url('https://unsplash.com/photos/black-car-in-grayscale-photography-vQVWIsIBafA')"></div>
                        <h3 class="news-title">Porsche Dominates Le Mans 24 Hours for Third Consecutive Year</h3>
                        <p class="news-summary">Porsche's 963 LMDh secured a 1-2 finish at the 2024 24 Hours of Le Mans, continuing their dominance in the Hypercar class. The German manufacturer's strategic brilliance and driver lineup proved unbeatable as they overcame fierce competition from Toyota and Ferrari in the final hours. The winning car, driven by an international trio of drivers, completed 385 laps of the Circuit de la Sarthe, setting a new distance record for the current regulations.</p>
                        
                        <div class="news-footer">
                            <!-- <span class="news-source">Endurance Central • 2 hours ago</span> -->
                            <div class="news-tags">
                                <span class="news-tag">Le Mans</span>
                                <span class="news-tag">Porsche</span>
                                <span class="news-tag">Hypercar</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Slide 3 -->
                <div class="news-slide" data-slide="3">
                    <div class="news-content">
                        <div class="news-header">
                            <span class="news-date">MARCH 13, 2024</span>
                            <span class="news-category">TECHNOLOGY</span>
                        </div>
                        <div class="news-image" style="background-image: url('https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80')"></div>
                        <h3 class="news-title">Godzilla Roars Again: Nissan GT-R R35 Unleashes Next-Level Performance</h3>
                        <p class="news-summary">Nissan's legendary GT-R R35 returns with a groundbreaking active aerodynamics system designed to redefine high-performance driving. This cutting-edge technology adjusts in real-time to road and track conditions, offering up to a 15% improvement in aerodynamic efficiency. Early testing reveals notable gains in cornering stability and straight-line speed. Utilizing a network of advanced sensors and AI-driven algorithms, the system predicts optimal aero settings before each turn, giving the GT-R R35 a renewed edge in the supercar arena.</p>
                        
                        <div class="news-footer">
                            <!-- <span class="news-source">Tech Racing • 5 hours ago</span> -->
                            <div class="news-tags">
                                <span class="news-tag">Ferrari</span>
                                <span class="news-tag">Aerodynamics</span>
                                <span class="news-tag">Innovation</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Slide 4 -->
                <div class="news-slide" data-slide="4">
                    <div class="news-content">
                        <div class="news-header">
                            <span class="news-date">MARCH 12, 2024</span>
                            <span class="news-category">FORMULA 1</span>
                        </div>
                        <div class="news-image" style="background-image: url('https://images.unsplash.com/photo-1543351611-58f69d7c1781?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1374&q=80')"></div>
                        <h3 class="news-title">Red Bull Announces RB20 with Groundbreaking Design</h3>
                        <p class="news-summary">Red Bull Racing has unveiled their 2024 challenger, the RB20, featuring radical aerodynamic concepts that break from conventional design. The car shows extreme sidepod solutions and a unique front wing design that team principal Christian Horner claims will "redefine F1 aerodynamics". The RB20 builds on the dominant RB19 platform but introduces several innovative features that could extend Red Bull's competitive advantage into the new season.</p>
                        
                        <div class="news-footer">
                            <!-- <span class="news-source">F1 Today • Yesterday</span> -->
                            <div class="news-tags">
                                <span class="news-tag">Red Bull</span>
                                <span class="news-tag">RB20</span>
                                <span class="news-tag">Car Launch</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Slide 5 -->
                <div class="news-slide" data-slide="5">
                    <div class="news-content">
                        <div class="news-header">
                            <span class="news-date">MARCH 11, 2024</span>
                            <span class="news-category">INDYCAR</span>
                        </div>
                        <div class="news-image" style="background-image: url('https://unsplash.com/photos/a-red-and-white-sports-car-on-display-FBZke4rUUeo')"></div>
                        <h3 class="news-title">IndyCar Reveals Hybrid Unit for 2024 Season</h3>
                        <p class="news-summary">The NTT IndyCar Series has officially revealed its hybrid power unit that will debut mid-season in 2024. The system combines a 2.2-liter twin-turbocharged V6 engine with an energy recovery system, delivering an additional 60 horsepower for limited periods during each lap. This marks IndyCar's first major powertrain evolution in over a decade and is seen as a crucial step in keeping the series technologically relevant while maintaining its traditional racing characteristics.</p>
                        
                        <div class="news-footer">
                            <!-- <span class="news-source">IndyCar News • 2 days ago</span> -->
                            <div class="news-tags">
                                <span class="news-tag">IndyCar</span>
                                <span class="news-tag">Hybrid</span>
                                <span class="news-tag">Technology</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Slide 6 - New Slide -->
                <div class="news-slide" data-slide="6">
                    <div class="news-content">
                        <div class="news-header">
                            <span class="news-date">MARCH 10, 2024</span>
                            <span class="news-category">FORMULA 1</span>
                        </div>
                        <div class="news-image" style="background-image: url('https://images.unsplash.com/photo-1605559424843-9e4c228bf1c2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1528&q=80')"></div>
                        <h3 class="news-title">Verstappen Dominates Season Opener in Bahrain</h3>
                        <p class="news-summary">Max Verstappen began his title defense in dominant fashion, leading every lap of the Bahrain Grand Prix to take victory by over 20 seconds. The Red Bull driver showed ominous pace throughout the weekend, securing pole position and the fastest lap to complete a perfect start to the season. Teammate Sergio Pérez made it a 1-2 finish for Red Bull, while Ferrari's Carlos Sainz rounded out the podium in third.</p>
                        
                        <div class="news-footer">
                            <!-- <span class="news-source">F1 Racing • 3 days ago</span> -->
                            <div class="news-tags">
                                <span class="news-tag">Verstappen</span>
                                <span class="news-tag">Red Bull</span>
                                <span class="news-tag">Bahrain GP</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Slide 7 - New Slide -->
                <div class="news-slide" data-slide="7">
                    <div class="news-content">
                        <div class="news-header">
                            <span class="news-date">MARCH 9, 2024</span>
                            <span class="news-category">RALLY</span>
                        </div>
                        <div class="news-image" style="background-image: url('https://images.unsplash.com/photo-1514316703785-1745a5433d2b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80')"></div>
                        <h3 class="news-title">Ogier Claims Dramatic Monte Carlo Victory</h3>
                        <p class="news-summary">Sébastien Ogier secured his ninth Rallye Monte-Carlo victory in a thrilling final-day battle with Kalle Rovanperä. The eight-time world champion overcame treacherous icy conditions and a late charge from his Toyota teammate to win by just 5.2 seconds. The victory marks Ogier's first win in his part-time campaign for 2024, demonstrating his enduring mastery of the iconic mountain roads.</p>
                        
                        <div class="news-footer">
                            <!-- <span class="news-source">Rally Sport • 4 days ago</span> -->
                            <div class="news-tags">
                                <span class="news-tag">Ogier</span>
                                <span class="news-tag">Monte Carlo</span>
                                <span class="news-tag">WRC</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <button class="slider-arrow slider-prev">
                    <i class="fas fa-chevron-left"></i>
                </button>
                <button class="slider-arrow slider-next">
                    <i class="fas fa-chevron-right"></i>
                </button>
                <div class="slider-controls">
                    <div class="slider-dot active" data-slide="1"></div>
                    <div class="slider-dot" data-slide="2"></div>
                    <div class="slider-dot" data-slide="3"></div>
                    <div class="slider-dot" data-slide="4"></div>
                    <div class="slider-dot" data-slide="5"></div>
                    <div class="slider-dot" data-slide="6"></div>
                    <div class="slider-dot" data-slide="7"></div>
                </div>
            </div>
        </div>

        <div class="section">
            <h2 class="section-title">Popular Racing Movies</h2>
            <div class="content-grid">
                <div class="card">
                    <h3 class="card-title">Rush (2013)</h3>
                    <p class="card-content">The epic rivalry between Formula 1 drivers James Hunt and Niki Lauda during the 1976 season.</p>
                </div>
                <div class="card">
                    <h3 class="card-title">Ford v Ferrari (2019)</h3>
                    <p class="card-content">The true story of the battle between Ford and Ferrari at the 1966 24 Hours of Le Mans.</p>
                </div>
                <div class="card">
                    <h3 class="card-title">Senna (2010)</h3>
                    <p class="card-content">Documentary about the life and death of Brazilian Formula 1 champion Ayrton Senna.</p>
                </div>
                <div class="card">
                    <h3 class="card-title">Le Mans '66 (2019)</h3>
                    <p class="card-content">American car designer Carroll Shelby and driver Ken Miles battle corporate interference to build a revolutionary race car for Ford.</p>
                </div>
                <div class="card">
                    <h3 class="card-title">Grand Prix (1966)</h3>
                    <p class="card-content">Classic film following several Formula One drivers through a championship season, featuring spectacular racing footage.</p>
                </div>
                <div class="card">
                    <h3 class="card-title">Days of Thunder (1990)</h3>
                    <p class="card-content">Tom Cruise stars as a hotshot rookie NASCAR driver trying to make his mark in the sport.</p>
                </div>
            </div>
        </div>

        <div class="section">
            <h2 class="section-title">Current Racing Events</h2>
            <div id="eventsContent" class="content-grid">
                <div class="card">
                    <h3 class="card-title">Formula 1: Saudi Arabian GP</h3>
                    <p class="card-content">
                        <strong>Date:</strong> March 17-19, 2024<br>
                        <strong>Location:</strong> Jeddah Corniche Circuit<br>
                        <strong>Current Leader:</strong> Max Verstappen (Red Bull)
                    </p>
                </div>
                <div class="card">
                    <h3 class="card-title">MotoGP: Qatar Grand Prix</h3>
                    <p class="card-content">
                        <strong>Date:</strong> March 15-17, 2024<br>
                        <strong>Location:</strong> Losail International Circuit<br>
                        <strong>Current Leader:</strong> Francesco Bagnaia (Ducati)
                    </p>
                </div>
                <div class="card">
                    <h3 class="card-title">NASCAR: Food City 500</h3>
                    <p class="card-content">
                        <strong>Date:</strong> March 17, 2024<br>
                        <strong>Location:</strong> Bristol Motor Speedway<br>
                        <strong>Current Leader:</strong> Kyle Larson (Hendrick Motorsports)
                    </p>
                </div>
                <div class="card">
                    <h3 class="card-title">WEC: 1000 Miles of Sebring</h3>
                    <p class="card-content">
                        <strong>Date:</strong> March 15-16, 2024<br>
                        <strong>Location:</strong> Sebring International Raceway<br>
                        <strong>Current Leader:</strong> Toyota Gazoo Racing
                    </p>
                </div>
                <div class="card">
                    <h3 class="card-title">IndyCar: Firestone Grand Prix</h3>
                    <p class="card-content">
                        <strong>Date:</strong> March 22-24, 2024<br>
                        <strong>Location:</strong> Streets of St. Petersburg<br>
                        <strong>Defending Champion:</strong> Marcus Ericsson (Chip Ganassi Racing)
                    </p>
                </div>
                <div class="card">
                    <h3 class="card-title">WRC: Rally Sweden</h3>
                    <p class="card-content">
                        <strong>Date:</strong> February 29 - March 3, 2024<br>
                        <strong>Location:</strong> Umeå, Sweden<br>
                        <strong>Winner:</strong> Kalle Rovanperä (Toyota Gazoo Racing)
                    </p>
                </div>
            </div>
        </div>

        <div class="section">
            <h2 class="section-title">Championship Standings</h2>
            <div class="standings-tabs">
                <div class="tabs">
                    <button class="tab-button active" data-series="f1">Formula 1</button>
                    <button class="tab-button" data-series="motogp">MotoGP</button>
                    <button class="tab-button" data-series="wec">WEC</button>
                    <button class="tab-button" data-series="nascar">NASCAR</button>
                </div>
                <div id="f1-standings" class="standings-content active">
                    <table class="standings-table">
                        <thead>
                            <tr>
                                <th>Pos</th>
                                <th>Driver</th>
                                <th>Team</th>
                                <th>Points</th>
                                <th>Wins</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>Max Verstappen</td>
                                <td>Red Bull Racing</td>
                                <td>51</td>
                                <td>2</td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>Sergio Pérez</td>
                                <td>Red Bull Racing</td>
                                <td>36</td>
                                <td>0</td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td>Charles Leclerc</td>
                                <td>Ferrari</td>
                                <td>28</td>
                                <td>0</td>
                            </tr>
                            <tr>
                                <td>4</td>
                                <td>Carlos Sainz</td>
                                <td>Ferrari</td>
                                <td>24</td>
                                <td>0</td>
                            </tr>
                            <tr>
                                <td>5</td>
                                <td>George Russell</td>
                                <td>Mercedes</td>
                                <td>18</td>
                                <td>0</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div id="motogp-standings" class="standings-content">
                    <table class="standings-table">
                        <thead>
                            <tr>
                                <th>Pos</th>
                                <th>Rider</th>
                                <th>Team</th>
                                <th>Points</th>
                                <th>Wins</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>Francesco Bagnaia</td>
                                <td>Ducati Lenovo</td>
                                <td>45</td>
                                <td>1</td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>Brad Binder</td>
                                <td>Red Bull KTM</td>
                                <td>36</td>
                                <td>0</td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td>Jorge Martín</td>
                                <td>Pramac Racing</td>
                                <td>28</td>
                                <td>0</td>
                            </tr>
                            <tr>
                                <td>4</td>
                                <td>Marc Márquez</td>
                                <td>Gresini Racing</td>
                                <td>24</td>
                                <td>0</td>
                            </tr>
                            <tr>
                                <td>5</td>
                                <td>Enea Bastianini</td>
                                <td>Ducati Lenovo</td>
                                <td>20</td>
                                <td>0</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div id="wec-standings" class="standings-content">
                    <table class="standings-table">
                        <thead>
                            <tr>
                                <th>Pos</th>
                                <th>Team</th>
                                <th>Manufacturer</th>
                                <th>Points</th>
                                <th>Wins</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>Toyota Gazoo Racing</td>
                                <td>Toyota</td>
                                <td>38</td>
                                <td>1</td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>Porsche Penske Motorsport</td>
                                <td>Porsche</td>
                                <td>27</td>
                                <td>0</td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td>Ferrari AF Corse</td>
                                <td>Ferrari</td>
                                <td>23</td>
                                <td>0</td>
                            </tr>
                            <tr>
                                <td>4</td>
                                <td>Cadillac Racing</td>
                                <td>Cadillac</td>
                                <td>18</td>
                                <td>0</td>
                            </tr>
                            <tr>
                                <td>5</td>
                                <td>Peugeot TotalEnergies</td>
                                <td>Peugeot</td>
                                <td>15</td>
                                <td>0</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div id="nascar-standings" class="standings-content">
                    <table class="standings-table">
                        <thead>
                            <tr>
                                <th>Pos</th>
                                <th>Driver</th>
                                <th>Team</th>
                                <th>Points</th>
                                <th>Wins</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>Kyle Larson</td>
                                <td>Hendrick Motorsports</td>
                                <td>185</td>
                                <td>1</td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>Ryan Blaney</td>
                                <td>Team Penske</td>
                                <td>178</td>
                                <td>0</td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td>William Byron</td>
                                <td>Hendrick Motorsports</td>
                                <td>172</td>
                                <td>1</td>
                            </tr>
                            <tr>
                                <td>4</td>
                                <td>Martin Truex Jr.</td>
                                <td>Joe Gibbs Racing</td>
                                <td>165</td>
                                <td>0</td>
                            </tr>
                            <tr>
                                <td>5</td>
                                <td>Denny Hamlin</td>
                                <td>Joe Gibbs Racing</td>
                                <td>158</td>
                                <td>1</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Enhanced News Slider Functionality
        document.addEventListener('DOMContentLoaded', function() {
            const slider = document.querySelector('.news-slider');
            const slides = Array.from(slider.querySelectorAll('.news-slide'));
            const dots = Array.from(slider.querySelectorAll('.slider-dot'));
            const prevBtn = slider.querySelector('.slider-prev');
            const nextBtn = slider.querySelector('.slider-next');
            let currentSlide = 0;
            let slideInterval;
            let isAnimating = false;
            const slideCount = slides.length;

            // Initialize slider
            function initSlider() {
                // Set initial positions
                slides.forEach((slide, index) => {
                    if (index === 0) {
                        slide.classList.add('active');
                    } else {
                        slide.classList.add('next');
                    }
                });
                
                // Start auto-sliding
                startSlideInterval();
                
                // Pause on hover
                slider.addEventListener('mouseenter', pauseSlider);
                slider.addEventListener('mouseleave', resumeSlider);
            }

            // Show specific slide with animation
            function goToSlide(index) {
                if (isAnimating || index === currentSlide) return;
                
                isAnimating = true;
                const direction = index > currentSlide ? 'right' : 'left';
                const currentActive = slides[currentSlide];
                const nextActive = slides[index];
                
                // Update current slide classes
                currentActive.classList.remove('active');
                currentActive.classList.add('exiting');
                
                // Prepare next slide
                nextActive.classList.remove('prev', 'next');
                nextActive.classList.add(direction === 'right' ? 'next' : 'prev');
                
                // Update dots
                updateDots(index);
                
                // After a brief delay to allow CSS to register changes
                setTimeout(() => {
                    currentActive.classList.remove('exiting');
                    currentActive.classList.add(direction === 'right' ? 'prev' : 'next');
                    
                    nextActive.classList.remove('prev', 'next');
                    nextActive.classList.add('active');
                    
                    currentSlide = index;
                    isAnimating = false;
                }, 50);
            }

            // Next slide with animation
            function nextSlide() {
                const nextIndex = (currentSlide + 1) % slideCount;
                goToSlide(nextIndex);
            }

            // Previous slide with animation
            function prevSlide() {
                const prevIndex = (currentSlide - 1 + slideCount) % slideCount;
                goToSlide(prevIndex);
            }

            // Update navigation dots
            function updateDots(index) {
                dots.forEach(dot => dot.classList.remove('active'));
                dots[index].classList.add('active');
            }

            // Start automatic sliding
            function startSlideInterval() {
                if (slideInterval) clearInterval(slideInterval);
                slideInterval = setInterval(nextSlide, 6000);
            }

            // Pause slider
            function pauseSlider() {
                clearInterval(slideInterval);
            }

            // Resume slider
            function resumeSlider() {
                startSlideInterval();
            }

            // Event Listeners
            nextBtn.addEventListener('click', () => {
                pauseSlider();
                nextSlide();
                resumeSlider();
            });

            prevBtn.addEventListener('click', () => {
                pauseSlider();
                prevSlide();
                resumeSlider();
            });

            dots.forEach((dot, index) => {
                dot.addEventListener('click', () => {
                    if (index !== currentSlide) {
                        pauseSlider();
                        goToSlide(index);
                        resumeSlider();
                    }
                });
            });

            // Keyboard navigation
            document.addEventListener('keydown', (e) => {
                if (e.key === 'ArrowRight') {
                    pauseSlider();
                    nextSlide();
                    resumeSlider();
                } else if (e.key === 'ArrowLeft') {
                    pauseSlider();
                    prevSlide();
                    resumeSlider();
                }
            });

            // Tab functionality for standings
            const tabButtons = document.querySelectorAll('.tab-button');
            const standingsContents = document.querySelectorAll('.standings-content');
            
            tabButtons.forEach(button => {
                button.addEventListener('click', () => {
                    // Remove active class from all buttons and contents
                    tabButtons.forEach(btn => btn.classList.remove('active'));
                    standingsContents.forEach(content => content.classList.remove('active'));
                    
                    // Add active class to clicked button and corresponding content
                    button.classList.add('active');
                    const series = button.getAttribute('data-series');
                    document.getElementById(`${series}-standings`).classList.add('active');
                });
            });

            // Initialize the slider
            initSlider();
        });

        // Mock data for API responses
        const mockData = {
            news: [
                {
                    date: "2024-03-15",
                    title: "Max Verstappen Wins Australian Grand Prix",
                    content: "Red Bull's Max Verstappen dominated the Australian Grand Prix, securing his second win of the season."
                },
                {
                    date: "2024-03-14",
                    title: "New F1 Regulations Announced",
                    content: "Formula 1 announces major regulation changes for the 2025 season, focusing on sustainability."
                },
                {
                    date: "2024-03-13",
                    title: "Ferrari Unveils New Car Design",
                    content: "Ferrari reveals revolutionary aerodynamic package for the upcoming Monaco Grand Prix."
                }
            ],
            events: [
                {
                    name: "Monaco Grand Prix 2024",
                    date: "May 26, 2024",
                    location: "Monte Carlo, Monaco",
                    series: "Formula 1"
                },
                {
                    name: "24 Hours of Le Mans",
                    date: "June 15-16, 2024",
                    location: "Le Mans, France",
                    series: "WEC"
                },
                {
                    name: "Indianapolis 500",
                    date: "May 28, 2024",
                    location: "Indianapolis, USA",
                    series: "IndyCar"
                }
            ],
            standings: [
                { position: 1, driver: "Max Verstappen", points: 75, wins: 3 },
                { position: 2, driver: "Charles Leclerc", points: 65, wins: 1 },
                { position: 3, driver: "Lewis Hamilton", points: 55, wins: 0 },
                { position: 4, driver: "Lando Norris", points: 45, wins: 0 },
                { position: 5, driver: "Carlos Sainz", points: 40, wins: 0 }
            ]
        };

        // Function to fetch racing news
        async function fetchRacingNews() {
            console.log('Fetching racing news...');
            try {
                // Simulate API delay
                await new Promise(resolve => setTimeout(resolve, 500));
                
                // Log to Java console
                console.log('GET /api/racing/news');
                console.log('Response received for /api/racing/news');
                
                console.log('Racing News Response:', mockData.news);
                displayNews(mockData.news);
            } catch (error) {
                console.error('Error fetching racing news:', error);
                console.log('Error in /api/racing/news request');
                document.getElementById('newsContent').innerHTML = 
                    '<div class="error">Failed to load news. Please try again later.</div>';
            }
        }

        // Function to fetch racing events
        async function fetchRacingEvents() {
            console.log('Fetching racing events...');
            try {
                // Simulate API delay
                await new Promise(resolve => setTimeout(resolve, 700));
                
                // Log to Java console
                console.log('GET /api/racing/events');
                console.log('Response received for /api/racing/events');
                
                console.log('Racing Events Response:', mockData.events);
                displayEvents(mockData.events);
            } catch (error) {
                console.error('Error fetching racing events:', error);
                console.log('Error in /api/racing/events request');
                document.getElementById('eventsContent').innerHTML = 
                    '<div class="error">Failed to load events. Please try again later.</div>';
            }
        }

        // Function to fetch standings
        async function fetchStandings() {
            console.log('Fetching championship standings...');
            try {
                // Simulate API delay
                await new Promise(resolve => setTimeout(resolve, 900));
                
                // Log to Java console
                console.log('GET /api/racing/standings');
                console.log('Response received for /api/racing/standings');
                
                console.log('Standings Response:', mockData.standings);
                displayStandings(mockData.standings);
            } catch (error) {
                console.error('Error fetching standings:', error);
                console.log('Error in /api/racing/standings request');
                document.getElementById('standingsContent').innerHTML = 
                    '<div class="error">Failed to load standings. Please try again later.</div>';
            }
        }

        // Display functions
        function displayNews(news) {
            console.log('Displaying news:', news);
            // This function is now redundant as we're using the hardcoded slider
        }

        function displayEvents(events) {
            console.log('Displaying events:', events);
            // This function is now redundant as we're using hardcoded events
        }

        function displayStandings(standings) {
            console.log('Displaying standings:', standings);
            // This function is now redundant as we're using hardcoded standings
        }

        // Initialize the page
        document.addEventListener('DOMContentLoaded', () => {
            console.log('Racing World page loaded, fetching data...');
            console.log('Page initialization started');
            
            // Fetch data for other sections
            fetchRacingEvents();
            fetchStandings();
            console.log('All API requests initiated');
        });
    </script>
</body>
</html>