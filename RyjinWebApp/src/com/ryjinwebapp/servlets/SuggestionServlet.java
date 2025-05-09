package com.ryjinwebapp.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/suggestion")
public class SuggestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("SuggestionServlet: " + request.getMethod() + " request received");

        // Set CORS headers
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        String contextPath = request.getContextPath();

        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            response.setHeader("Access-Control-Max-Age", "86400");
            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        if ("GET".equalsIgnoreCase(request.getMethod()) || request.getParameter("suggestion") == null) {
            // Render the form
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Ryjin - Suggestion Form</title>");
            out.println("<link rel='stylesheet' href='" + contextPath + "/style.css'>");
            out.println("<style>");
            out.println(".suggestion-container {");
            out.println("    max-width: 600px;");
            out.println("    margin: 4rem auto;");
            out.println("    background: linear-gradient(145deg, rgba(20,20,20,0.95), rgba(12,12,12,0.98));");
            out.println("    border-radius: 12px;");
            out.println("    padding: 3rem;");
            out.println("    box-shadow: 0 20px 40px rgba(0,0,0,0.5), 0 0 30px var(--gtr-glow);");
            out.println("    border: 1px solid var(--gtr-red);");
            out.println("    position: relative;");
            out.println("    overflow: hidden;");
            out.println("    animation: floatIn 0.8s ease-out forwards;");
            out.println("}");
            out.println(".suggestion-container::before {");
            out.println("    content: '';");
            out.println("    position: absolute;");
            out.println("    top: 0;");
            out.println("    left: 0;");
            out.println("    width: 100%;");
            out.println("    height: 4px;");
            out.println("    background: linear-gradient(90deg, transparent, var(--gtr-red), transparent);");
            out.println("    box-shadow: 0 0 15px var(--gtr-red);");
            out.println("}");
            out.println(".suggestion-header {");
            out.println("    text-align: center;");
            out.println("    margin-bottom: 2.5rem;");
            out.println("    position: relative;");
            out.println("}");
            out.println(".suggestion-header h1 {");
            out.println("    font-family: 'Orbitron', sans-serif;");
            out.println("    font-size: 2.5rem;");
            out.println("    color: var(--gtr-red);");
            out.println("    text-transform: uppercase;");
            out.println("    letter-spacing: 3px;");
            out.println("    margin-bottom: 1rem;");
            out.println("    text-shadow: 0 0 15px var(--gtr-red);");
            out.println("}");
            out.println(".suggestion-header p {");
            out.println("    color: var(--text-secondary);");
            out.println("    font-family: 'Rajdhani', sans-serif;");
            out.println("    font-size: 1.1rem;");
            out.println("    line-height: 1.6;");
            out.println("}");
            out.println(".form-group {");
            out.println("    margin-bottom: 2rem;");
            out.println("    position: relative;");
            out.println("}");
            out.println(".form-group label {");
            out.println("    display: block;");
            out.println("    margin-bottom: 0.75rem;");
            out.println("    color: var(--text-primary);");
            out.println("    font-family: 'Rajdhani', sans-serif;");
            out.println("    font-size: 1.2rem;");
            out.println("    letter-spacing: 1px;");
            out.println("    text-transform: uppercase;");
            out.println("}");
            out.println(".form-group input {");
            out.println("    width: 100%;");
            out.println("    padding: 1.2rem 1.5rem;");
            out.println("    background: rgba(20,20,20,0.8);");
            out.println("    border: 1px solid rgba(255,0,51,0.3);");
            out.println("    border-radius: 8px;");
            out.println("    color: var(--text-primary);");
            out.println("    font-family: 'Rajdhani', sans-serif;");
            out.println("    font-size: 1.1rem;");
            out.println("    transition: all 0.3s ease;");
            out.println("    box-shadow: inset 0 2px 8px rgba(0,0,0,0.3);");
            out.println("}");
            out.println(".form-group input:focus {");
            out.println("    outline: none;");
            out.println("    border-color: var(--gtr-red);");
            out.println("    box-shadow: inset 0 2px 4px rgba(0,0,0,0.2), 0 0 15px var(--gtr-glow);");
            out.println("    transform: translateY(-2px);");
            out.println("}");
            out.println(".button-group {");
            out.println("    display: flex;");
            out.println("    justify-content: space-between;");
            out.println("    gap: 1rem;");
            out.println("    margin-top: 2.5rem;");
            out.println("}");
            out.println(".btn {");
            out.println("    display: inline-block;");
            out.println("    padding: 1rem 2rem;");
            out.println("    background: linear-gradient(135deg, var(--gtr-red-dark), var(--gtr-red));");
            out.println("    color: white;");
            out.println("    text-decoration: none;");
            out.println("    border-radius: 8px;");
            out.println("    font-family: 'Orbitron', sans-serif;");
            out.println("    text-transform: uppercase;");
            out.println("    letter-spacing: 2px;");
            out.println("    transition: all 0.3s ease;");
            out.println("    box-shadow: 0 4px 20px rgba(255,0,51,0.5);");
            out.println("    border: 1px solid var(--gtr-red);");
            out.println("    position: relative;");
            out.println("    overflow: hidden;");
            out.println("    cursor: pointer;");
            out.println("}");
            out.println(".btn::before {");
            out.println("    content: '';");
            out.println("    position: absolute;");
            out.println("    top: 0;");
            out.println("    left: -100%;");
            out.println("    width: 100%;");
            out.println("    height: 100%;");
            out.println("    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);");
            out.println("    transition: transform 0.6s ease;");
            out.println("}");
            out.println(".btn:hover::before {");
            out.println("    transform: translateX(200%);");
            out.println("}");
            out.println(".btn:hover {");
            out.println("    transform: translateY(-3px) scale(1.05);");
            out.println("    box-shadow: 0 8px 30px var(--gtr-glow);");
            out.println("    background: linear-gradient(135deg, var(--gtr-red), var(--gtr-red-dark));");
            out.println("}");
            out.println(".btn-outline {");
            out.println("    background: transparent;");
            out.println("    border: 1px solid var(--gtr-red);");
            out.println("    color: var(--gtr-red);");
            out.println("    box-shadow: 0 0 10px rgba(255,0,51,0.2);");
            out.println("}");
            out.println(".btn-outline:hover {");
            out.println("    background: rgba(255,0,51,0.1);");
            out.println("    box-shadow: 0 0 20px var(--gtr-glow);");
            out.println("}");
            out.println("@keyframes floatIn {");
            out.println("    0% {");
            out.println("        opacity: 0;");
            out.println("        transform: translateY(50px) scale(0.9);");
            out.println("    }");
            out.println("    100% {");
            out.println("        opacity: 1;");
            out.println("        transform: translateY(0) scale(1);");
            out.println("    }");
            out.println("}");
            out.println("</style>");
            out.println("</head>");
            out.println("<body class='dark-theme'>");
            out.println("<div class='suggestion-container'>");
            out.println("    <div class='suggestion-header'>");
            out.println("        <h1>Submit Your Suggestion</h1>");
            out.println("        <p>Share your favorite cars, events, and track experiences</p>");
            out.println("    </div>");
            out.println("    <form action='" + contextPath + "/suggestion' method='post'>");
            out.println("        <div class='form-group'>");
            out.println("            <label for='suggestion'>Your suggestion:</label>");
            out.println("            <input type='text' id='suggestion' name='suggestion' required>");
            out.println("        </div>");
            out.println("        <div class='button-group'>");
            out.println("            <button type='submit' class='btn'>Submit</button>");
            out.println("        </div>");
            out.println("    </form>");
            out.println("</div>");
            out.println("</body>");
            out.println("</html>");
        } else {
            // Process form submission
            String suggestion = request.getParameter("suggestion");

            if (suggestion.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println("<!DOCTYPE html>");
                out.println("<html><head><title>Error</title>");
                out.println("<link rel='stylesheet' href='" + contextPath + "/style.css'></head>");
                out.println("<body class='dark-theme'><div class='container'>");
                out.println("<h2>Error: Empty suggestion</h2>");
                out.println("<p><a href='" + contextPath + "/index.html'>Return to homepage</a></p>");
                out.println("</div></body></html>");
            } else {
                out.println("<!DOCTYPE html>");
                out.println("<html><head><title>Thank You</title>");
                out.println("<link rel='stylesheet' href='" + contextPath + "/style.css'>");
                out.println("<style>");
                out.println(".thank-you-container {");
                out.println("    max-width: 600px;");
                out.println("    margin: 4rem auto;");
                out.println("    background: linear-gradient(145deg, rgba(20,20,20,0.95), rgba(12,12,12,0.98));");
                out.println("    border-radius: 12px;");
                out.println("    padding: 3rem;");
                out.println("    box-shadow: 0 20px 40px rgba(0,0,0,0.5), 0 0 30px var(--gtr-glow);");
                out.println("    border: 1px solid var(--gtr-red);");
                out.println("    position: relative;");
                out.println("    overflow: hidden;");
                out.println("    animation: floatIn 0.8s ease-out forwards;");
                out.println("}");
                out.println(".thank-you-container::before {");
                out.println("    content: '';");
                out.println("    position: absolute;");
                out.println("    top: 0;");
                out.println("    left: 0;");
                out.println("    width: 100%;");
                out.println("    height: 4px;");
                out.println("    background: linear-gradient(90deg, transparent, var(--gtr-red), transparent);");
                out.println("    box-shadow: 0 0 15px var(--gtr-red);");
                out.println("}");
                out.println(".thank-you-icon {");
                out.println("    font-size: 4rem;");
                out.println("    color: var(--gtr-red);");
                out.println("    text-align: center;");
                out.println("    margin: 0 auto 1.5rem;");
                out.println("    text-shadow: 0 0 20px var(--gtr-red);");
                out.println("    animation: pulse 2s infinite alternate;");
                out.println("    cursor: pointer;");
                out.println("    transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);");
                out.println("    transform-style: preserve-3d;");
                out.println("    perspective: 1000px;");
                out.println("    display: flex;");
                out.println("    align-items: center;");
                out.println("    justify-content: center;");
                out.println("    width: 6rem;");
                out.println("    height: 6rem;");
                out.println("    border-radius: 50%;");
                out.println("    background: rgba(255,0,51,0.1);");
                out.println("    border: 2px solid var(--gtr-red);");
                out.println("    box-shadow: 0 0 20px rgba(255,0,51,0.3);");
                out.println("}");
                out.println(".thank-you-icon:hover {");
                out.println("    transform: translateY(-5px) rotateX(10deg) scale(1.1);");
                out.println("    box-shadow: 0 10px 30px var(--gtr-glow), 0 0 40px rgba(255,0,51,0.4);");
                out.println("    background: rgba(255,0,51,0.2);");
                out.println("    text-shadow: 0 0 30px var(--gtr-red), 0 0 40px rgba(255,0,51,0.7);");
                out.println("}");
                out.println(".thank-you-icon:active {");
                out.println("    transform: translateY(-2px) rotateX(5deg) scale(0.95);");
                out.println("    box-shadow: 0 5px 15px var(--gtr-glow);");
                out.println("}");
                out.println(".thank-you-title {");
                out.println("    font-family: 'Orbitron', sans-serif;");
                out.println("    font-size: 2.5rem;");
                out.println("    color: var(--gtr-red);");
                out.println("    text-align: center;");
                out.println("    margin-bottom: 1.5rem;");
                out.println("    text-transform: uppercase;");
                out.println("    letter-spacing: 3px;");
                out.println("    text-shadow: 0 0 15px var(--gtr-red);");
                out.println("}");
                out.println(".suggestion-box {");
                out.println("    background: rgba(20,20,20,0.8);");
                out.println("    border: 1px solid rgba(255,0,51,0.3);");
                out.println("    border-radius: 8px;");
                out.println("    padding: 1.5rem;");
                out.println("    margin: 2rem 0;");
                out.println("    position: relative;");
                out.println("    overflow: hidden;");
                out.println("}");
                out.println(".suggestion-box::before {");
                out.println("    content: '';");
                out.println("    position: absolute;");
                out.println("    top: -50%;");
                out.println("    left: -50%;");
                out.println("    width: 200%;");
                out.println("    height: 200%;");
                out.println("    background: linear-gradient(to bottom right, transparent 45%, var(--gtr-red) 50%, transparent 55%);");
                out.println("    opacity: 0.1;");
                out.println("    transform: rotate(45deg);");
                out.println("    animation: shine 6s infinite;");
                out.println("}");
                out.println(".suggestion-text {");
                out.println("    font-family: 'Rajdhani', sans-serif;");
                out.println("    font-size: 1.2rem;");
                out.println("    color: var(--text-primary);");
                out.println("    line-height: 1.6;");
                out.println("    position: relative;");
                out.println("    z-index: 1;");
                out.println("}");
                out.println("@keyframes pulse {");
                out.println("    from { text-shadow: 0 0 10px var(--gtr-red); }");
                out.println("    to { text-shadow: 0 0 20px var(--gtr-red), 0 0 30px rgba(255,0,51,0.7); }");
                out.println("}");
                out.println("@keyframes shine {");
                out.println("    0% { transform: translateX(-100%) rotate(45deg); }");
                out.println("    100% { transform: translateX(100%) rotate(45deg); }");
                out.println("}");
                out.println("</style>");
                out.println("</head>");
                out.println("<body class='dark-theme'>");
                out.println("<div class='thank-you-container'>");
                out.println("    <div class='thank-you-icon' onclick='window.close()'>✓</div>");
                out.println("    <h1 class='thank-you-title'>Thank You!</h1>");
                out.println("    <div class='suggestion-box'>");
                out.println("        <p class='suggestion-text'>We received your suggestion: <strong>" + suggestion + "</strong></p>");
                out.println("    </div>");
                out.println("</div>");
                out.println("</body></html>");
            }
        }
    }

    private void logRequestDetails(HttpServletRequest request) {
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Context Path: " + request.getContextPath());
        System.out.println("Servlet Path: " + request.getServletPath());
        System.out.println("Path Info: " + request.getPathInfo());
        System.out.println("Query String: " + request.getQueryString());

        System.out.println("Headers:");
        Enumeration<String> headerNames = request.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String headerName = headerNames.nextElement();
            System.out.println("  " + headerName + ": " + request.getHeader(headerName));
        }

        System.out.println("Parameters:");
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            System.out.println("  " + paramName + ": " + request.getParameter(paramName));
        }
    }
}