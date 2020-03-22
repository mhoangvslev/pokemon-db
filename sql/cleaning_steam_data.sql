-- Keep the needed column
COPY steam_data(ResponseName, DLCCount, RecommendationCount, SteamSpyOwners, SteamSpyPlayersEstimate, AchievementCount, AchievementHighlightedCount)
FROM '/dataset/steam_data.csv' DELIMITER ',' CSV HEADER;