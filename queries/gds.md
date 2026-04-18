## Step 1: Graph Projection

### Query Structure

- `gds.graph.project`  
  Creates an in-memory graph for analysis.

- `'bookGraph'`  
  Name of the projected graph.

- `['User', 'Book']`  
  Specifies node labels included in the projection.

- `RATED`  
  Specifies relationship type.

- `properties: 'rating'`  
  Includes relationship property for use in algorithms.

### Purpose

Graph projection is required before running any GDS algorithm.

It allows:
- faster computation
- isolated analysis
- efficient algorithm execution

## Step 2: PageRank

### Query Structure

- `gds.pageRank.stream`  
  Runs PageRank algorithm on projected graph.

- `nodeId, score`  
  Returns node identifier and importance score.

- `gds.util.asNode(nodeId)`  
  Converts internal ID to actual node.

- `ORDER BY score DESC`  
  Sorts nodes by importance.

### Purpose

PageRank identifies the most important nodes in the graph.

In this context:
- highlights popular books
- detects influential nodes in the network
## Step 3: Louvain Community Detection

### Query Structure

- `gds.louvain.stream`  
  Runs community detection algorithm.

- `communityId`  
  Identifier of detected community.

- `count(*)`  
  Number of nodes in each community.

### Purpose

Louvain identifies clusters of nodes that are more densely connected internally.

It helps to:
- detect user groups with similar preferences
- identify communities in the graph
### Community Visualization

Louvain results were written back to the graph using the `write` mode.

Each node was assigned a `community` property, allowing visualization of detected clusters.

Nodes were then visualized and colored by community, revealing:
- distinct groups of users and books
- localized clusters of interactions
- structural segmentation of the graph

This confirms the presence of communities identified by the Louvain algorithm.
### Interpretation of Louvain Communities

The visualization reveals distinct clusters of users and books, representing communities detected by the Louvain algorithm.

Within each community:
- users tend to interact with a similar subset of books
- connections are denser compared to the rest of the graph

Additionally, variation in user connectivity is observed:
- some users act as hubs, connected to multiple books
- others are weakly connected, interacting with only a single book

This suggests:
- the presence of both highly active and minimally active users
- localized clusters of shared preferences

Overall, the graph exhibits a modular structure with multiple communities, 
confirming earlier findings from exploratory analysis.
The presence of multiple small communities instead of a single dominant one 
indicates a fragmented graph structure, which is typical in sparse recommendation datasets.
## Step 4: Node Similarity

### Query Structure

- `gds.nodeSimilarity.stream`  
  Computes similarity between nodes.

- `similarity`  
  Measures how similar two nodes are.

- Filtering for User nodes  
  Ensures meaningful comparison.

### Purpose

This algorithm identifies users with similar preferences.

It is useful for:
- recommendation systems
- collaborative filtering