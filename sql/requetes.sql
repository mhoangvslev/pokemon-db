-- 1) Nombre de ventes de jeux vidéos en Europe par type et par année, avec des sous totaux par : Type, Année, Type et année, total général
SELECT G.genre, G.release_year, sum(F.eu_sales)
FROM Game G, Fact F
WHERE G.game_id = F.game_id
GROUP BY CUBE (G.genre, G.release_year)
ORDER BY(sum(F.eu_sales)) DESC

-- 2) Quels sont les publishers les plus réussis en 2010? de tous les temps?
SELECT p.publisher_name, SUM(f.na_sales) as na_sales, SUM(f.jp_sales) as jp_sales, SUM(f.eu_sales) eu_sales, SUM(f.other_sales) as other_sales, SUM(f.global_sales) as global_sales
FROM Publisher p, Fact f, Game g
WHERE p.publisher_id = f.publisher_id AND f.game_id = g.game_id AND extract(YEAR FROM g.release_year) = 2010
GROUP BY ROLLUP (p.publisher_name)
ORDER BY global_sales DESC
LIMIT 10

SELECT p.publisher_name, SUM(f.na_sales) as na_sales, SUM(f.jp_sales) as jp_sales, SUM(f.eu_sales) eu_sales, SUM(f.other_sales) as other_sales, SUM(f.global_sales) as global_sales
FROM Publisher p, Fact f
WHERE p.publisher_id = f.publisher_id
GROUP BY ROLLUP (p.publisher_name)
ORDER BY global_sales DESC
LIMIT 10

-- 3)Breakdown des revenus de Activision (Publisher) par ses studios en 2010? depuis sa création? 
SELECT p.publisher_name, d.developer_name, SUM(f.global_sales) as global_sales
FROM Publisher p, Fact f, Developer d, Game g
WHERE p.publisher_id = f.publisher_id AND f.developer_id = d.developer_id 
	AND f.game_id = g.game_id 
      AND extract(year from g.release_year) = 2010 -- Supp pour tous les temps
	AND p.publisher_name = 'Activision'
GROUP BY ROLLUP (p.publisher_name, d.developer_name)
ORDER BY global_sales DESC


-- 4) Breakdown des revenus de Ubisoft (Developer) par ses produits en 2010? depuis sa création? 
SELECT d.developer_name, g.title, SUM(f.global_sales) as global_sales
FROM Fact f, Developer d, Game g
WHERE f.developer_id = d.developer_id
	AND f.game_id = g.game_id 
	AND extract(year from g.release_year) = 2010
	AND lower(d.developer_name) = 'ubisoft'
GROUP BY ROLLUP (d.developer_name, g.title)
ORDER BY global_sales DESC


-- 5) Breakdown des revenus de Ubisoft (Developer) par les genres de jeux-vidéo en 2010? depuis sa création? 
SELECT d.developer_name, g.genre, SUM(f.global_sales) as global_sales
FROM Fact f, Developer d, Game g
WHERE f.developer_id = d.developer_id
	AND f.game_id = g.game_id 
	AND extract(year from g.release_year) = 2010
	AND lower(d.developer_name) = 'ubisoft'
GROUP BY ROLLUP (d.developer_name, g.genre)
ORDER BY global_sales DESC


-- 6) Quels sont les genres qui génèrent le plus de revenu pour les 10 meilleurs développeur en 2010? Breakdown par genre, par dev puis sum.
WITH game_sales_per_genre AS (
	SELECT g.genre, d.developer_name, f.global_sales
	FROM Fact f, Developer d, Game g
	WHERE f.developer_id = d.developer_id
		AND f.game_id = g.game_id 
		AND extract(year from g.release_year) = 2010
	ORDER BY f.global_sales DESC
	LIMIT 10
) 	SELECT genre, developer_name, SUM(global_sales) as global_sales
	FROM game_sales_per_genre
	GROUP BY CUBE(genre, developer_name)
	ORDER BY genre


-- 7) Quelles sont les genres de jeux favoris de professionnels ? Amateurs ?
SELECT TRUNC(AVG(F.critic_score),2) AS score_pro, G.title, P.platform_name
FROM Fact F, Game G, platform P
WHERE F.game_id = G.game_id
      AND F.platform_id = P.platform_id
      AND F.critic_score IS NOT NULL
GROUP BY (G.title,P.platform_name)
ORDER BY score_pro DESC
LIMIT 10;


-- 8) Les nombres de ventes par plateforme ainsi qu’un total, ainsi que le jeu le plus vendu pour chacune des plateformes.
SELECT SUM(F.Global_sales), P.platform_name
FROM Platform P, Fact F
WHERE P.platform_id = F.platform_id
GROUP BY ROLLUP(P.platform_name)
Order by SUM(F.Global_sales) DESC

SELECT P.platform_name, G.title, F.global_sales
FROM Platform P, Game G, Fact F
WHERE F.game_id = G.game_id
AND F.platform_id = P.platform_id
AND F.global_sales = (SELECT MAX(F.global_sales) 
                      FROM Fact F 
                      WHERE F.platform_id = P.platform_id)
GROUP BY P.platform_name, G.title, F.global_sales
ORDER BY F.global_sales DESC


-- 9) Plateforme qui a sorti les meilleurs jeux (ou un ranking rank())
WITH platform_rank AS (
  SELECT P.platform_name as platform_name, TRUNC(AVG(F.critic_score),2) AS score
  FROM Fact F, Game G, platform P
  WHERE F.game_id = G.game_id
  AND F.platform_id = P.platform_id
  AND F.critic_score IS NOT NULL
  GROUP BY P.platform_name
) SELECT platform_name, score, dense_rank() OVER (ORDER BY score DESC) rank_number 
	FROM platform_rank


-- 10) Moyenne des critiques par Publisher, par Developer, et par binôme Developer/Publisher
SELECT P.publisher_name, D.developer_name, AVG(F.critic_score) as score
FROM Publisher P, Fact F, Developer D
WHERE P.publisher_id = F.publisher_id AND D.developer_id = F.developer_id and F.critic_score >= 0
GROUP BY GROUPING SETS(P.publisher_name, D.developer_name, (P.publisher_name, D.developer_name))
ORDER BY score DESC