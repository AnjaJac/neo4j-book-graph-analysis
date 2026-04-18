// Query 1
MATCH (n)
RETURN labels(n), count(*);

//Query 2
MATCH ()-[r:RATED]->()
RETURN count(r) AS totalRatings;

// Query 3
MATCH (b:Book)<-[r:RATED]-()
RETURN b.title AS book, count(r) AS ratings
ORDER BY ratings DESC
LIMIT 10;
// Query 4
MATCH (u:User)-[r:RATED]->()
RETURN u.userId AS user, count(r) AS ratings
ORDER BY ratings DESC
LIMIT 10;
// Query 5
MATCH ()-[r:RATED]->()
RETURN r.rating AS rating, count(*) AS count
ORDER BY rating;
//Query 6
MATCH (b:Book)<-[r:RATED]-()
WITH b, avg(r.rating) AS avgRating, count(r) AS numRatings
WHERE numRatings > 5
RETURN b.title AS book, avgRating, numRatings
ORDER BY avgRating DESC
LIMIT 10;

// Query 7
MATCH (u:User)-[r:RATED]->(b:Book)
WHERE r.rating >= 8
RETURN u, r, b
LIMIT 50;

// Query 8
MATCH (u1:User)-[:RATED]->(b:Book)<-[:RATED]-(u2:User)
WHERE u1 <> u2
WITH u1, u2, count(b) AS commonBooks
WHERE commonBooks >= 3
RETURN u1.userId AS user1, u2.userId AS user2, commonBooks
ORDER BY commonBooks DESC
LIMIT 10;

// Query 9
MATCH (u:User)-[r:RATED]->(b:Book)
WHERE r.rating >= 8

WITH b, count(r) AS highRatings
ORDER BY highRatings DESC
LIMIT 3

MATCH (b)<-[r:RATED]-(u:User)
WHERE r.rating >= 8

RETURN u, r, b
LIMIT 100;