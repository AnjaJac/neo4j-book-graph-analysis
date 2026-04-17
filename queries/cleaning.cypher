// ======================================================
// DATA CLEANING & GRAPH RECONSTRUCTION
// ======================================================

// This file documents all cleaning steps applied after
// detecting inconsistencies in the graph.

// ======================================================
// PROBLEM DETECTED
// ======================================================

// Duplicate User nodes were created due to repeated imports.
// This resulted in:
// - inflated number of users (~550k instead of ~270k)
// - inconsistent graph structure

// ======================================================
// STEP 1 — CREATE CLEAN USER NODES
// ======================================================
// Create a new set of users with unique userId values

MATCH (u:User)
WITH DISTINCT u.userId AS id, u.location AS location

CREATE (:UserClean {
    userId: id,
    location: location
});

// Verify new clean users
MATCH (u:UserClean)
RETURN count(u) AS cleanUsers;


// ======================================================
// STEP 2 — RECONNECT RELATIONSHIPS
// ======================================================
// Rebuild relationships from old users to new clean users

MATCH (old:User)-[r:RATED]->(b:Book)
WITH old, r, b

MATCH (new:UserClean)
WHERE new.userId = old.userId

MERGE (new)-[:RATED {
    rating: r.rating
}]->(b);

// Verify relationships are attached to UserClean
MATCH (:UserClean)-[r:RATED]->(:Book)
RETURN count(r) AS cleanRelationships;


// ======================================================
// STEP 3 — REMOVE OLD USERS
// ======================================================
// Remove duplicated user nodes and their relationships

MATCH (u:User)
DETACH DELETE u;

// Verify deletion
MATCH (u:User)
RETURN count(u) AS remainingOldUsers;


// ======================================================
// STEP 4 — RENAME CLEAN USERS
// ======================================================
// Replace UserClean label with User

MATCH (u:UserClean)
SET u:User
REMOVE u:UserClean;


// ======================================================
// STEP 5 — FINAL VALIDATION
// ======================================================

// Count users
MATCH (u:User)
RETURN count(u) AS totalUsers;

// Count books
MATCH (b:Book)
RETURN count(b) AS totalBooks;

// Count relationships
MATCH ()-[r:RATED]->()
RETURN count(r) AS totalRelationships;

// Check duplicate relationships
MATCH (u:User)-[r:RATED]->(b:Book)
WITH u, b, count(r) AS relCount
WHERE relCount > 1
RETURN count(*) AS duplicatePairs;