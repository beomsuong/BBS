// BserApi.java
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONArray;
import org.json.JSONObject;

public class BserApi {
    public static String getFirstGame() {
        String apiKey = "uGok1BSIkw5DlPJxXxnpe6SZIo8X9Fbe5IxnjlTf"; // API Key
        String urlString = "https://open-api.bser.io/v1/user/games/418355"; // URL
        URL url;
        StringBuilder sb = new StringBuilder();

        try {
            url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("x-api-key", apiKey);

            BufferedReader br;
            br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            br.close();

            JSONObject responseJson = new JSONObject(sb.toString());
            JSONArray userGames = responseJson.getJSONArray("userGames");
            return userGames.getJSONObject(0).toString();

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
