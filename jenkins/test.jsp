<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Jenkins 연동 테스트</title>
</head>
<body>
    <h1>Jenkins 연동 테스트</h1>
    <%
        String jenkinsUrl = "http://localhost:8080/jenkins"; // Jenkins URL
        String result = "";

        try {
            URL url = new URL(jenkinsUrl + "/api/json");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(5000);
            connection.setReadTimeout(5000);
            int responseCode = connection.getResponseCode();

            if (responseCode == 200) {
                result = "Jenkins와의 연결이 성공적으로 이루어졌습니다!";
            } else {
                result = "Jenkins에 연결할 수 없습니다. 응답 코드: " + responseCode;
            }
        } catch (Exception e) {
            result = "오류 발생: " + e.getMessage();
        }
    %>
    <p><%= result %></p>
</body>
</html>
