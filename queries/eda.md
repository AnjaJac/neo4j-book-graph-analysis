## Query 1: Dataset Overview

### Query Structure

- `MATCH (n)`  
  Matches all nodes in the graph regardless of label.

- `labels(n)`  
  Returns the label(s) assigned to each node (e.g., User, Book).

- `count(*)`  
  Counts the number of nodes for each label.

- `RETURN labels(n), count(*)`  
  Groups nodes by label and returns the total count per label.

### Purpose

This query is used to understand the overall composition of the graph, specifically:
- how many nodes exist for each entity type
- whether the dataset is balanced or skewed
## Query 2: Total Relationships

### Query Structure

- `MATCH ()-[r:RATED]->()`  
  Matches all relationships of type `RATED` between any nodes.

- `r`  
  Represents the relationship variable.

- `count(r)`  
  Counts the total number of relationships.

- `RETURN count(r)`  
  Returns the total number of `RATED` relationships in the graph.

### Purpose

This query measures the size of the interaction network:
- how many user-to-book interactions exist
- how dense the graph is in terms of relationships

This helps in understanding:
- the level of connectivity in the graph
- whether the dataset is sparse or dense
## Query 3: Most Rated Books

### Query Structure

- `MATCH (b:Book)<-[r:RATED]-()`  
  Matches all incoming `RATED` relationships to Book nodes.

- `b:Book`  
  Specifies that we are working with Book nodes.

- `count(r)`  
  Counts how many times each book has been rated.

- `RETURN b.title AS book, count(r) AS ratings`  
  Returns the book title along with the number of ratings it received.

- `ORDER BY ratings DESC`  
  Sorts books by number of ratings in descending order (most popular first).

- `LIMIT 10`  
  Restricts output to the top 10 most rated books.

### Purpose

This query identifies the most popular books in the dataset based on user interaction.

It helps to:
- detect highly engaged items
- understand which books dominate user attention
- provide insight into popularity distribution within the graph
## Query 4: Most Active Users

### Query Structure

- `MATCH (u:User)-[r:RATED]->()`  
  Matches all outgoing `RATED` relationships from User nodes.

- `u:User`  
  Specifies that we are analyzing User nodes.

- `count(r)`  
  Counts how many ratings each user has made.

- `RETURN u.userId AS user, count(r) AS ratings`  
  Returns the user identifier along with the number of ratings they created.

- `ORDER BY ratings DESC`  
  Sorts users by activity level (most active first).

- `LIMIT 10`  
  Returns only the top 10 most active users.

### Purpose

This query identifies the most active users in the system.

It helps to:
- detect power users
- understand user engagement patterns
- observe whether activity is evenly distributed or concentrated among a few users
## Query 5: Rating Distribution

### Query Structure

- `MATCH ()-[r:RATED]->()`  
  Matches all `RATED` relationships in the graph.

- `r.rating`  
  Accesses the rating property stored on each relationship.

- `count(*)`  
  Counts how many times each rating value appears.

- `RETURN r.rating AS rating, count(*) AS count`  
  Returns each rating value along with its frequency.

- `ORDER BY rating`  
  Sorts the results in ascending order of rating values.

### Purpose

This query analyzes how ratings are distributed across the dataset.

It helps to:
- identify common rating values
- detect bias (e.g., many high or low ratings)
- understand user rating behavior
## Query 6: Highest Rated Books

### Query Structure

- `MATCH (b:Book)<-[r:RATED]-()`  
  Matches all ratings connected to Book nodes.

- `avg(r.rating)`  
  Calculates the average rating for each book.

- `count(r)`  
  Counts how many ratings each book has received.

- `WITH b, avg(r.rating) AS avgRating, count(r) AS numRatings`  
  Prepares aggregated values for each book.

- `WHERE numRatings > 5`  
  Filters out books with too few ratings to avoid unreliable averages.

- `RETURN b.title AS book, avgRating, numRatings`  
  Returns book title, average rating, and number of ratings.

- `ORDER BY avgRating DESC`  
  Sorts books by highest average rating.

- `LIMIT 10`  
  Returns top 10 highest-rated books.

### Purpose

This query identifies the highest-rated books based on user ratings.

It helps to:
- find top-performing books
- avoid bias from books with very few ratings
- understand quality trends in the dataset
## Query 7: Graph Visualization (High Ratings)

### Query Structure

- `MATCH (u:User)-[r:RATED]->(b:Book)`  
  Matches user-book relationships.

- `WHERE r.rating >= 8`  
  Filters only strong positive interactions.

- `RETURN u, r, b`  
  Returns full graph structure for visualization.

- `LIMIT 50`  
  Limits results for readable graph display.

### Purpose

This query visualizes the graph focusing on strong user preferences.

It helps to:
- reveal clusters of users and books
- observe how users group around similar items
- prepare for community detection algorithms
## Query 8: User Similarity (Common Books)

### Query Structure

- `MATCH (u1:User)-[:RATED]->(b:Book)<-[:RATED]-(u2:User)`  
  Finds pairs of users connected through shared books.

- `u1 <> u2`  
  Ensures different users are compared.

- `count(b)`  
  Counts how many books both users rated.

- `WHERE commonBooks >= 3`  
  Filters meaningful overlaps.

- `RETURN user pairs and commonBooks`  
  Shows similarity strength between users.

### Purpose

This query identifies users with similar preferences.

It helps to:
- detect user similarity patterns
- understand shared behavior
- prepare for node similarity algorithms
## Query 9: High-Engagement Subgraph

### Query Structure

- `MATCH (u:User)-[r:RATED]->(b:Book)`  
  Matches all user-book interactions.

- `WHERE r.rating >= 8`  
  Filters only strong positive interactions.

- `WITH b, count(r) AS highRatings`  
  Aggregates number of high ratings per book.

- `ORDER BY highRatings DESC LIMIT 3`  
  Selects top 3 most highly rated books.

- `MATCH (b)<-[r:RATED]-(u:User)`  
  Expands back to users connected to those books.

- `RETURN u, r, b LIMIT 100`  
  Returns a manageable subgraph for visualization.

### Purpose

This query extracts a dense and meaningful subgraph centered around highly rated books.

It helps to:
- reveal clusters of users with similar preferences
- highlight highly engaging parts of the graph
- provide a visual foundation for community detection and similarity algorithms

### Insight Potential

The resulting subgraph often shows:
- tightly connected groups of users
- shared interest patterns
- hubs (popular books)

This structure is important for:
- Louvain community detection
- Node similarity analysis