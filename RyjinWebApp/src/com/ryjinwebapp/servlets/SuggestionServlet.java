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

    @Override
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
            out.println("</head>");
            out.println("<body class='dark-theme'>");
            out.println("<div class='container'>");
            out.println("<h1>Submit Your Suggestion</h1>");
            out.println("<form action='" + contextPath + "/suggestion' method='post'>");
            out.println("<div class='form-group'>");
            out.println("<label for='suggestion'>Your suggestion:</label>");
            out.println("<input type='text' id='suggestion' name='suggestion' required>");
            out.println("</div>");
            out.println("<button type='submit' class='btn btn-primary'>Submit</button>");
            out.println("</form>");
            out.println("<div style='margin-top: 20px;'>");
            out.println("<a href='" + contextPath + "/index.html' style='color: blue;'>Back to Home</a>");
            out.println("</div>");
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
                out.println("<link rel='stylesheet' href='" + contextPath + "/style.css'></head>");
                out.println("<body class='dark-theme'><div class='container'>");
                out.println("<h2>Thank you!</h2>");
                out.println("<p>We received your suggestion: " + suggestion + "</p>");
                out.println("<p><a href='" + contextPath + "/index.html'>Return to homepage</a></p>");
                out.println("</div></body></html>");
            }
        }
    }

//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        // Handle GET requests (e.g., when clicking the suggestion link)
//        System.out.println("SuggestionServlet: GET request received");
//        logRequestDetails(request);
//        System.out.println("\n\n========= GET REQUEST DETAILS =========");
//        System.out.println("Request URL: " + request.getRequestURL());
//        System.out.println("Context Path: " + request.getContextPath());
//        System.out.println("Servlet Path: " + request.getServletPath());
//        System.out.println("Path Info: " + request.getPathInfo());
//        System.out.println("Query String: " + request.getQueryString());
//        System.out.println("==================================\n");
//
//        response.setContentType("text/html");
//        PrintWriter out = response.getWriter();
//
//        String contextPath = request.getContextPath();
//        out.println("<!DOCTYPE html>");
//        out.println("<html>");
//        out.println("<head>");
//        out.println("<title>Ryjin - Suggestion Form</title>");
//        out.println("<link rel='stylesheet' href='" + contextPath + "/style.css'>");
//        out.println("</head>");
//        out.println("<body class='dark-theme'>");
//        out.println("<div class='container'>");
//        out.println("<h1>Submit Your Suggestion</h1>");
//        out.println("<form action='" + contextPath + "/suggestion' method='post'>");
//        out.println("<div class='form-group'>");
//        out.println("<label for='suggestion'>Your suggestion:</label>");
//        out.println("<input type='text' id='suggestion' name='suggestion' required>");
//        out.println("</div>");
//        out.println("<button type='submit' class='btn btn-primary'>Submit</button>");
//        out.println("</form>");
//        out.println("<div style='margin-top: 20px;'>");
//        out.println("<a href='" + contextPath + "/index.html' style='color: blue;'>Back to Home</a>");
//        out.println("</div>");
//        out.println("</div>");
//        out.println("</body>");
//        out.println("</html>");
//
//
//
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        System.out.println("SuggestionServlet: POST request received");
//
//        // Set CORS headers
//        response.setHeader("Access-Control-Allow-Origin", "*");
//        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
//        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
//
//        // Get the suggestion parameter
//        String suggestion = request.getParameter("suggestion");
//
//        response.setContentType("text/html");
//        PrintWriter out = response.getWriter();
//
//        String contextPath = request.getContextPath();
//
//        if (suggestion == null || suggestion.trim().isEmpty()) {
//            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
//            out.println("<!DOCTYPE html>");
//            out.println("<html><head><title>Error</title>");
//            out.println("<link rel='stylesheet' href='" + contextPath + "/style.css'></head>");
//            out.println("<body class='dark-theme'><div class='container'>");
//            out.println("<h2>Error: Empty suggestion</h2>");
//            out.println("<p><a href='" + contextPath + "/index.html'>Return to homepage</a></p>");
//            out.println("</div></body></html>");
//        } else {
//            // Return full HTML response
//            out.println("<!DOCTYPE html>");
//            out.println("<html><head><title>Thank You</title>");
//            out.println("<link rel='stylesheet' href='" + contextPath + "/style.css'></head>");
//            out.println("<body class='dark-theme'><div class='container'>");
//            out.println("<h2>Thank you!</h2>");
//            out.println("<p>We received your suggestion: " + suggestion + "</p>");
//            out.println("<p><a href='" + contextPath + "/index.html'>Return to homepage</a></p>");
//            out.println("</div></body></html>");
//        }
//    }
//
//    @Override
//    protected void doOptions(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        // Handle CORS preflight requests
//        System.out.println("SuggestionServlet: OPTIONS request received");
//
//        response.setHeader("Access-Control-Allow-Origin", "*");
//        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
//        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
//        response.setHeader("Access-Control-Max-Age", "86400");
//        response.setStatus(HttpServletResponse.SC_OK);
//    }

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