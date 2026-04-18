// Query 1: Graph projection
CALL gds.graph.project(
  'bookGraph',
  ['User', 'Book'],
  {
    RATED: {
      properties: 'rating'
    }
  }
);
// Query 2: Page Rank
CALL gds.pageRank.stream('bookGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).title AS book, score
ORDER BY score DESC
LIMIT 10;

// Query 3: Louvain community detection algorithm
CALL gds.louvain.stream('bookGraph')
YIELD nodeId, communityId
RETURN communityId, count(*) AS size
ORDER BY size DESC
LIMIT 10;

//Query 4: Write communities to nodes
CALL gds.louvain.write('bookGraph', {
  writeProperty: 'community'
});

//Query 5: Visualize communities
MATCH (u:User)-[r:RATED]->(b:Book)
WHERE u.community IS NOT NULL
RETURN u, r, b
LIMIT 100;

// Query 6: One community
MATCH (n)
WITH n.community AS c, count(*) AS size
ORDER BY size DESC
LIMIT 1

MATCH (u:User)-[r:RATED]->(b:Book)
WHERE u.community = c
RETURN u, r, b
LIMIT 100;
//Query 7: Node Similarity
CALL gds.nodeSimilarity.stream('bookGraph')
YIELD node1, node2, similarity

WITH gds.util.asNode(node1) AS u1,
     gds.util.asNode(node2) AS u2,
     similarity

WHERE u1:User AND u2:User

RETURN u1.userId AS user1, u2.userId AS user2, similarity
ORDER BY similarity DESC
LIMIT 10;