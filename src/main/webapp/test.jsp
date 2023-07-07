<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.net.URL"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="org.json.JSONException"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.Comparator"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
    <%
    String url = "https://open-api.bser.io/v1/games/25383466";
    String acceptHeader = "application/json";
    String apiKeyHeader = "uGok1BSIkw5DlPJxXxnpe6SZIo8X9Fbe5IxnjlTf";

    StringBuilder response2 = new StringBuilder();

    try {
        URL urlObj = new URL(url);
        HttpURLConnection conn = (HttpURLConnection) urlObj.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("accept", acceptHeader);
        conn.setRequestProperty("x-api-key", apiKeyHeader);

        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String inputLine;

        while ((inputLine = in.readLine()) != null) {
            response2.append(inputLine);
        }

        in.close();
        conn.disconnect();
    } catch (Exception e) {
        e.printStackTrace();
    }

    // JSON 데이터에서 "userGames" 배열의 각 항목의 "nickname", "gameRank", "teamNumber"를 출력합니다.
    try {
        String jsonData = response2.toString();
        JSONObject jsonObject = new JSONObject(jsonData);

        // JSON 객체에 "userGames" 키가 있고, 그 값이 배열인지 확인합니다.
        if (jsonObject.has("userGames") && jsonObject.get("userGames") instanceof JSONArray) {
            JSONArray userGames = jsonObject.getJSONArray("userGames");

            ArrayList<JSONObject> list = new ArrayList<>();
            for (int i = 0; i < userGames.length(); i++) {
                list.add(userGames.getJSONObject(i));
            }

            Collections.sort(list, new Comparator<JSONObject>() {
                @Override
                public int compare(JSONObject a, JSONObject b) {
                    int valA = 0;
                    int valB = 0;
                    try {
                        valA = a.getInt("gameRank");
                        valB = b.getInt("gameRank");
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    return Integer.compare(valA, valB);
                }
            });

           
    %>
    <div class="container">
        <div class="row">
            <table class="table table-striped"
                style="text-align: center; border: 1px solid #dddddd;">
                <thead>
                    <tr>
                        <th style="background-color: #eeeeee; text-align: center">닉</th>
                        <th style="background-color: #eeeeee; text-align: center">등수</th>
                        <th style="background-color: #eeeeee; text-align: center">팀번호</th>
                    </tr>
                </thead>
                <tbody><% for (JSONObject userGame : list) {%> 
                    <tr>
                        <td><%=userGame.getString("nickname")%></td>
                        <td><%=userGame.getInt("gameRank")%></td>
                        <td><%=userGame.getInt("teamNumber")%></td>
                         <%
            }
                %>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <%
            
        }
    } catch (JSONException e) {
        out.println(e.toString());
    }
    %>
</body>
</html>
