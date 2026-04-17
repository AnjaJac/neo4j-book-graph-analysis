# Neo4j Book Graph Analysis

##  Project Overview

The goal of this project is to apply graph database modeling and graph algorithms using Neo4j on a real-world dataset.

The project includes:
- Selecting a suitable dataset
- Designing a graph model
- Importing and cleaning data
- Performing exploratory analysis (next step)
- Applying graph algorithms (next step)

---

##  Dataset

We used the **Book-Crossing dataset**, which contains:

- Books (`Books.csv`)
- Users (`Users.csv`)
- Ratings (`Ratings.csv`)

### Dataset Characteristics:
- ~270,000 books
- ~270,000 users
- ~1,000,000 ratings (raw)

---

##  Why this dataset?

This dataset is ideal for graph modeling because it naturally represents relationships:

- Users interact with books
- Ratings form connections between entities
- Suitable for community detection and similarity analysis

---

##  Graph Model

### Nodes:
- `User`
  - userId
  - location

- `Book`
  - isbn
  - title
  - author

### Relationships:
- `(:User)-[:RATED {rating}]->(:Book)`

---

##  Setup

- Installed Neo4j Desktop
- Created a new database instance
- Installed Graph Data Science (GDS) plugin
- Copied dataset into Neo4j `import/` folder

---

## 🚨 Challenges Encountered & Solutions

### 1. CSV Parsing Errors (Quotes Issue)

**Problem:**
Neo4j failed to load CSV files due to malformed quotes:

**Solution:**
Cleaned CSV files using terminal:

```bash
sed 's/""/"/g' Ratings.csv | sed 's/"//g' > Ratings_clean.csv
sed 's/""/"/g' Books.csv | sed 's/"//g' > Books_clean.csv
```
### 2. Column Name Issues

**Problem:**
Columns like Book-Title caused syntax errors.

**Solution:**
Used index-based access:
```bash 
row[1]  // Book title
row[2]  // Author
```
### 3. Slow Relationship Import

**Problem:**
Initial relationship import was extremely slow and caused long execution times.

**Solution:**
Created indexes for faster matching:
```bash
CREATE INDEX user_id_index FOR (u:User) ON (u.userId);
CREATE INDEX book_isbn_index FOR (b:Book) ON (b.isbn);
```
### 4. Neo4j Version Compatibility

** Problem:**
USING PERIODIC COMMIT and CALL ... IN TRANSACTIONS caused syntax errors.

**Solution:**
Used simpler batch approach with LIMIT and manual execution.

### 5. Duplicate Relationships

**Problem:**
Multiple identical relationships were created during repeated imports.

**Solution:**
Removed duplicates:
```bash
MATCH (u:User)-[r:RATED]->(b:Book)
WITH u, b, collect(r) AS rels
WHERE size(rels) > 1
FOREACH (r IN tail(rels) | DELETE r);
```
### Prohect Structure
neo4j-book-graph-analysis/
│
├── data/
├── queries/
├── docs/
├── README.md

