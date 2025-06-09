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
    <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;700&family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #ff3e3e;
            --text-color: #e0e0e0;
            --border-color: #1a1a1a;
            --glow-color: rgba(255, 62, 62, 0.3);
            --bg-color: #0a0a0a;
            --card-bg: rgba(15, 15, 15, 0.95);
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-color);
            font-family: 'Inter', sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        h2 {
            color: var(--primary-color);
            text-transform: uppercase;
            letter-spacing: 2px;
            margin-bottom: 20px;
            font-size: 2rem;
            font-weight: 700;
            text-shadow: 0 0 10px var(--glow-color);
        }

        .section {
            margin-bottom: 60px;
            background: var(--card-bg);
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
            border: 1px solid var(--border-color);
        }

        pre {
            background: rgba(10, 10, 10, 0.95);
            padding: 25px;
            border-radius: 8px;
            overflow-x: auto;
            border: 1px solid var(--border-color);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.5);
            margin-bottom: 20px;
            font-family: 'JetBrains Mono', monospace;
            font-size: 1.1rem;
            line-height: 1.5;
        }

        /* Enhanced JSON Syntax Highlighting */
        .json-key { color: #ff6b6b; font-weight: 600; }
        .json-string { color: #69db7c; }
        .json-number { color: #74c0fc; }
        .json-boolean { color: #ffd43b; }
        .json-null { color: #ffa8a8; }
        .json-property { color: #ff6b6b; }
        .json-value { color: #69db7c; }
        .json-bracket { color: #e0e0e0; }
        .json-comma { color: #e0e0e0; }

        /* News Slider Styles */
        .news-slider {
            position: relative;
            width: 100%;
            overflow: hidden;
            border-radius: 8px;
            height: 600px;
        }

        .news-slides-container {
            display: flex;
            transition: transform 0.5s ease-in-out;
            height: 100%;
            width: 100%;
        }

        .news-slide {
            min-width: 100%;
            flex-shrink: 0;
            opacity: 0;
            transition: opacity 0.5s ease;
            padding: 15px;
            box-sizing: border-box;
            position: absolute;
            width: 100%;
            height: 100%;
            left: 0;
            top: 0;
        }

        .news-slide.active {
            opacity: 1;
            z-index: 1;
        }

        .news-content {
            background: rgba(20, 20, 20, 0.8);
            border-radius: 8px;
            padding: 20px;
            height: 100%;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
        }

        .news-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 0.9rem;
            color: #aaa;
        }

        .news-image {
            height: 200px;
            background-size: cover;
            background-position: center;
            border-radius: 6px;
            margin-bottom: 15px;
        }

        .news-title {
            color: var(--primary-color);
            margin: 0 0 10px 0;
            font-size: 1.4rem;
        }

        .news-summary {
            margin: 0 0 15px 0;
            color: #ddd;
            line-height: 1.5;
        }

        .news-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .news-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .news-tag {
            background: rgba(255, 62, 62, 0.2);
            color: #ff6b6b;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
        }

        .slider-arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(0, 0, 0, 0.5);
            border: none;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
            z-index: 10;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .slider-arrow:hover {
            background: rgba(255, 62, 62, 0.8);
        }

        .slider-prev {
            left: 15px;
        }

        .slider-next {
            right: 15px;
        }

        .slider-controls {
            display: flex;
            justify-content: center;
            margin-top: 20px;
            gap: 10px;
        }

        .slider-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .slider-dot.active {
            background: var(--primary-color);
            transform: scale(1.2);
        }

        .back-btn {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            margin-bottom: 20px;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            background: #ff1e1e;
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
            
            .container {
                padding: 10px;
            }

            pre {
                font-size: 0.9rem;
                padding: 15px;
            }

            h2 {
                font-size: 1.5rem;
            }

            .news-image {
                height: 150px;
            }

            .news-title {
                font-size: 1.2rem;
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
                <div class="news-slides-container">
                    <!-- Slide 1 -->
                    <div class="news-slide" data-slide="1">
                        <div class="news-content">
                            <div class="news-header">
                                
                                <span class="news-category">FORMULA 1</span>
                            </div>
                            <div class="news-image" style="background-image: url('imgs/ferrari.jpg')"></div>
                            <h3 class="news-title">Hamilton Announces Shock Move to Ferrari for 2025 Season</h3>
                            <p class="news-summary">Seven-time world champion Lewis Hamilton will join Ferrari in 2025, ending his successful partnership with Mercedes after 12 seasons. This historic move marks one of the biggest driver transfers in Formula 1 history. Hamilton signed a multi-year contract with the Italian team, replacing Carlos Sainz. The announcement sent shockwaves through the motorsport world, with fans and analysts speculating about the implications for both teams.</p>
                            
                            <div class="news-footer">
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
                                
                                <span class="news-category">ENDURANCE</span>
                            </div>
                            <div class="news-image" style="background-image: url('imgs/josh-berquist-pjxe3p4u5aI-unsplash.jpg')"></div>
                            <h3 class="news-title">Porsche Dominates Le Mans 24 Hours for Third Consecutive Year</h3>
                            <p class="news-summary">Porsche's 963 LMDh secured a 1-2 finish at the 2024 24 Hours of Le Mans, continuing their dominance in the Hypercar class. The German manufacturer's strategic brilliance and driver lineup proved unbeatable as they overcame fierce competition from Toyota and Ferrari in the final hours. The winning car, driven by an international trio of drivers, completed 385 laps of the Circuit de la Sarthe, setting a new distance record for the current regulations.</p>
                            
                            <div class="news-footer">
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
                                
                                <span class="news-category">TECHNOLOGY</span>
                            </div>
                            <div class="news-image" style="background-image: url('https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80')"></div>
                            <h3 class="news-title">Godzilla Roars Again: Nissan GT-R R35 Unleashes Next-Level Performance</h3>
                            <p class="news-summary">Nissan's legendary GT-R R35 returns with a groundbreaking active aerodynamics system designed to redefine high-performance driving. This cutting-edge technology adjusts in real-time to road and track conditions, offering up to a 15% improvement in aerodynamic efficiency. Early testing reveals notable gains in cornering stability and straight-line speed. Utilizing a network of advanced sensors and AI-driven algorithms, the system predicts optimal aero settings before each turn, giving the GT-R R35 a renewed edge in the supercar arena.</p>
                            
                            <div class="news-footer">
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
                                
                                <span class="news-category">FORMULA 1</span>
                            </div>
                            <div class="news-image" style="background-image: url('imgs/rb.jpg')"></div>
                            <h3 class="news-title">Red Bull Announces RB20 with Groundbreaking Design</h3>
                            <p class="news-summary">Red Bull Racing has unveiled their 2024 challenger, the RB20, featuring radical aerodynamic concepts that break from conventional design. The car shows extreme sidepod solutions and a unique front wing design that team principal Christian Horner claims will "redefine F1 aerodynamics". The RB20 builds on the dominant RB19 platform but introduces several innovative features that could extend Red Bull's competitive advantage into the new season.</p>
                            
                            <div class="news-footer">
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
                                
                                <span class="news-category">INDYCAR</span>
                            </div>
                            <div class="news-image" style="background-image: url('imgs/sam-zlobin-FhgEO9QzQCc-unsplash.jpg')"></div>
                            <h3 class="news-title">IndyCar Reveals Hybrid Unit for 2024 Season</h3>
                            <p class="news-summary">The NTT IndyCar Series has officially revealed its hybrid power unit that will debut mid-season in 2024. The system combines a 2.2-liter twin-turbocharged V6 engine with an energy recovery system, delivering an additional 60 horsepower for limited periods during each lap. This marks IndyCar's first major powertrain evolution in over a decade and is seen as a crucial step in keeping the series technologically relevant while maintaining its traditional racing characteristics.</p>
                            
                            <div class="news-footer">
                                <div class="news-tags">
                                    <span class="news-tag">IndyCar</span>
                                    <span class="news-tag">Hybrid</span>
                                    <span class="news-tag">Technology</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Slide 6 -->
                    <div class="news-slide" data-slide="6">
                        <div class="news-content">
                            <div class="news-header">
                                
                                <span class="news-category">FORMULA 1</span>
                            </div>
                            <div class="news-image" style="background-image: url('https://images.unsplash.com/photo-1605559424843-9e4c228bf1c2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1528&q=80')"></div>
                            <h3 class="news-title">Verstappen Dominates Season Opener in Bahrain</h3>
                            <p class="news-summary">Max Verstappen began his title defense in dominant fashion, leading every lap of the Bahrain Grand Prix to take victory by over 20 seconds. The Red Bull driver showed ominous pace throughout the weekend, securing pole position and the fastest lap to complete a perfect start to the season. Teammate Sergio Pérez made it a 1-2 finish for Red Bull, while Ferrari's Carlos Sainz rounded out the podium in third.</p>
                            
                            <div class="news-footer">
                                <div class="news-tags">
                                    <span class="news-tag">Verstappen</span>
                                    <span class="news-tag">Red Bull</span>
                                    <span class="news-tag">Bahrain GP</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Slide 7 -->
                    <div class="news-slide" data-slide="7">
                        <div class="news-content">
                            <div class="news-header">
                                
                                <span class="news-category">RALLY</span>
                            </div>
                            <div class="news-image" style="background-image: url('imgs/rt.jpg')"></div>
                            <h3 class="news-title">Ogier Claims Dramatic Monte Carlo Victory</h3>
                            <p class="news-summary">Sébastien Ogier secured his ninth Rallye Monte-Carlo victory in a thrilling final-day battle with Kalle Rovanperä. The eight-time world champion overcame treacherous icy conditions and a late charge from his Toyota teammate to win by just 5.2 seconds. The victory marks Ogier's first win in his part-time campaign for 2024, demonstrating his enduring mastery of the iconic mountain roads.</p>
                            
                            <div class="news-footer">
                                <div class="news-tags">
                                    <span class="news-tag">Ogier</span>
                                    <span class="news-tag">Monte Carlo</span>
                                    <span class="news-tag">WRC</span>
                                </div>
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
            <h2 class="section-title">Racing Movies</h2>
            <pre id="moviesContent"></pre>
        </div>

        <div class="section">
            <h2 class="section-title">Famous Racing Circuits</h2>
            <pre id="circuitsContent"></pre>
        </div>
    </div>

    <script>
        const API_BASE_URL = 'http://localhost:3000/api/';

        // News slider functionality with smooth transitions
        document.addEventListener('DOMContentLoaded', function() {
            const slides = document.querySelectorAll('.news-slide');
            const dots = document.querySelectorAll('.slider-dot');
            const prevBtn = document.querySelector('.slider-prev');
            const nextBtn = document.querySelector('.slider-next');
            
            let currentIndex = 0;
            const slideCount = slides.length;
            let slideInterval;
            const slideDuration = 5000; // 5 seconds
            
            // Initialize slider
            function initSlider() {
                // Set initial active slide
                slides[0].classList.add('active');
                updateDots();
                startAutoSlide();
                
                // Event listeners for buttons
                prevBtn.addEventListener('click', goToPrevSlide);
                nextBtn.addEventListener('click', goToNextSlide);
                
                // Event listeners for dots
                dots.forEach((dot, index) => {
                    dot.addEventListener('click', () => goToSlide(index));
                });
                
                // Touch events for mobile swipe
                let touchStartX = 0;
                let touchEndX = 0;
                
                const slider = document.querySelector('.news-slider');
                slider.addEventListener('touchstart', function(e) {
                    touchStartX = e.changedTouches[0].screenX;
                    clearInterval(slideInterval);
                }, {passive: true});
                
                slider.addEventListener('touchend', function(e) {
                    touchEndX = e.changedTouches[0].screenX;
                    handleSwipe();
                    startAutoSlide();
                }, {passive: true});
            }
            
            function handleSwipe() {
                const difference = touchStartX - touchEndX;
                if (difference > 50) {
                    goToNextSlide(); // Swipe left
                } else if (difference < -50) {
                    goToPrevSlide(); // Swipe right
                }
            }
            
            function goToSlide(index) {
                // Remove active class from current slide
                slides[currentIndex].classList.remove('active');
                // Add active class to new slide
                slides[index].classList.add('active');
                currentIndex = index;
                updateDots();
                resetAutoSlide();
            }
            
            function goToPrevSlide() {
                const newIndex = (currentIndex - 1 + slideCount) % slideCount;
                goToSlide(newIndex);
            }
            
            function goToNextSlide() {
                const newIndex = (currentIndex + 1) % slideCount;
                goToSlide(newIndex);
            }
            
            function updateDots() {
                dots.forEach((dot, index) => {
                    if (index === currentIndex) {
                        dot.classList.add('active');
                    } else {
                        dot.classList.remove('active');
                    }
                });
            }
            
            function startAutoSlide() {
                slideInterval = setInterval(goToNextSlide, slideDuration);
            }
            
            function resetAutoSlide() {
                clearInterval(slideInterval);
                startAutoSlide();
            }
            
            initSlider();
        });

        function syntaxHighlight(json) {
            if (typeof json !== 'string') {
                json = JSON.stringify(json, null, 2);
            }
            
            json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
            
            return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
                let cls = 'json-number';
                if (/^"/.test(match)) {
                    if (/:$/.test(match)) {
                        cls = 'json-key';
                    } else {
                        cls = 'json-string';
                    }
                } else if (/true|false/.test(match)) {
                    cls = 'json-boolean';
                } else if (/null/.test(match)) {
                    cls = 'json-null';
                }
                return '<span class="' + cls + '">' + match + '</span>';
            });
        }

        async function fetchData(endpoint) {
            try {
                console.group(`Fetching ${endpoint} data`);
                console.time('Fetch duration');
                
                const response = await fetch(API_BASE_URL + endpoint);
                const data = await response.json();
                
                console.log('Raw data received:', data);
                console.log('Data structure:', {
                    type: typeof data,
                    isArray: Array.isArray(data),
                    length: Array.isArray(data) ? data.length : Object.keys(data).length
                });
                
                console.timeEnd('Fetch duration');
                console.groupEnd();
                
                return data;
            } catch (error) {
                console.error(`Error fetching ${endpoint}:`, error);
                throw error;
            }
        }

        async function initializePage() {
            try {
                console.group('Initializing Racing World Page');
                
                // Fetch and display movies data
                const moviesData = await fetchData('movies');
                const moviesContent = document.getElementById('moviesContent');
                if (moviesContent) {
                    moviesContent.innerHTML = syntaxHighlight(moviesData);
                    console.log('Movies data displayed successfully');
                }

                // Fetch and display circuits data
                const circuitsData = await fetchData('circuits');
                const circuitsContent = document.getElementById('circuitsContent');
                if (circuitsContent) {
                    circuitsContent.innerHTML = syntaxHighlight(circuitsData);
                    console.log('Circuits data displayed successfully');
                }

                console.groupEnd();
            } catch (error) {
                console.error('Error initializing page:', error);
                const moviesContent = document.getElementById('moviesContent');
                const circuitsContent = document.getElementById('circuitsContent');
                
                if (moviesContent) {
                    moviesContent.textContent = 'Error loading movie data';
                }
                if (circuitsContent) {
                    circuitsContent.textContent = 'Error loading circuit data';
                }
            }
        }

        // Wait for DOM to be fully loaded
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initializePage);
        } else {
            initializePage();
        }
    </script>
</body>
</html>