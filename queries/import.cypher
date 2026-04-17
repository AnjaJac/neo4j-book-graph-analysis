// ======================================================
// NEO4J BOOK GRAPH PROJECT — FULL IMPORT PIPELINE
// ======================================================

// IMPORTANT:
// Before running this file, CSV files must be cleaned in terminal:
//
// sed 's/""/"/g' Books.csv | sed 's/"//g' > Books_clean.csv
// sed 's/""/"/g' Ratings.csv | sed 's/"//g' > Ratings_clean.csv
//
// Reason:
// Neo4j cannot parse malformed quotes in CSV files.

// ======================================================
// STEP 1 — CREATE INDEXES (CRITICAL FOR PERFORMANCE)
// ======================================================

CREATE INDEX user_id_index IF NOT EXISTS
FOR (u:User) ON (u.userId);

CREATE INDEX book_isbn_index IF NOT EXISTS
FOR (b:Book) ON (b.isbn);

// ======================================================
// STEP 2 — IMPORT BOOKS
// ======================================================
// NOTE:
// Using index-based access instead of headers because:
// - Column names contain special characters (e.g. Book-Title)
// - Header parsing caused issues earlier

LOAD CSV FROM 'file:///Books_clean.csv' AS row
FIELDTERMINATOR ';'
WITH row
WHERE row[0] <> 'ISBN'

CREATE (:Book {
    isbn: row[0],
    title: trim(row[1]),
    author: trim(row[2])
});

// ======================================================
// STEP 3 — IMPORT USERS
// ======================================================

LOAD CSV FROM 'file:///Users.csv' AS row
FIELDTERMINATOR ';'
WITH row
WHERE row[0] <> 'User-ID'

CREATE (:User {
    userId: toInteger(row[0]),
    location: row[1]
});

// ======================================================
// STEP 4 — IMPORT RELATIONSHIPS
// ======================================================
// NOTE:
// MATCH is efficient due to indexes
// MERGE prevents duplicate relationships

LOAD CSV FROM 'file:///Ratings_clean.csv' AS row
FIELDTERMINATOR ';'
WITH row
WHERE row[0] <> 'User-ID'
  AND row[1] IS NOT NULL

MATCH (u:User {userId: toInteger(row[0])})
MATCH (b:Book {isbn: row[1]})

MERGE (u)-[:RATED {
    rating: toInteger(row[2])
}]->(b);

// ======================================================
// STEP 5 — CLEAN DUPLICATES (SAFETY STEP)
// ======================================================
// In case multiple imports were run accidentally

MATCH (u:User)-[r:RATED]->(b:Book)
WITH u, b, collect(r) AS rels
WHERE size(rels) > 1

FOREACH (r IN tail(rels) | DELETE r);

// ======================================================
// STEP 6 — VALIDATION
// ======================================================

// Count nodes
MATCH (n)
RETURN labels(n), count(*) AS count;

// Count relationships
MATCH ()-[r:RATED]->()
RETURN count(r) AS totalRelationships;

// Check duplicates (should be 0)
MATCH (u:User)-[r:RATED]->(b:Book)
WITH u, b, count(r) AS relCount
WHERE relCount > 1
RETURN count(*) AS duplicatePairs;

// Sample graph
MATCH (u:User)-[r:RATED]->(b:Book)
RETURN u, r, b
LIMIT 20;