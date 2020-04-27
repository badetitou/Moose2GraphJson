# Moose2GraphJson

Project Under Development

## Goal

Import and Export Fame model the following format

```
{"graph": {
        "nodes": [
          {
            "id": "32496",
            "labels": [
              "Person"
            ],
            "properties": {
              "born": 1967,
              "name": "Carrie-Anne Moss"
            }
          },
          {
            "id": "32505",
            "labels": [
              "Movie"
            ],
            "properties": {
              "tagline": "Evil has its winning ways",
              "title": "The Devil's Advocate",
              "released": 1997
            }
          },
          {
            "id": "32494",
            "labels": [
              "Movie"
            ],
            "properties": {
              "tagline": "Welcome to the Real World",
              "title": "The Matrix",
              "released": 1999
            }
          },
          {
            "id": "32495",
            "labels": [
              "Person"
            ],
            "properties": {
              "born": 1964,
              "name": "Keanu Reeves"
            }
          }
        ],
        "relationships": [
          {
            "id": "83204",
            "type": "ACTED_IN",
            "startNode": "32495",
            "endNode": "32505",
            "properties": {
              "role": "Kevin Lomax"
            }
          },
          {
            "id": "83183",
            "type": "ACTED_IN",
            "startNode": "32496",
            "endNode": "32494",
            "properties": {
              "role": "Trinity"
            }
          },
          {
            "id": "83182",
            "type": "ACTED_IN",
            "startNode": "32495",
            "endNode": "32494",
            "properties": {
              "role": "Neo"
            }
          }
        ]
      }
    }
  } 
```


## Import in neo4j

You can load the generated json file with the 2 commands

```
CALL apoc.load.json("file:///test.json") YIELD value AS row
WITH row, row.graph.nodes AS nodes
UNWIND nodes AS node
CALL apoc.create.node(node.labels, node.properties) YIELD node AS n
SET n.id = node.id
```

and

```
CALL apoc.load.json("file:///test.json") YIELD value AS row
with row
UNWIND row.graph.relationships AS rel
MATCH (a) WHERE a.id = rel.endNode
MATCH (b) WHERE b.id = rel.startNode
CALL apoc.create.relationship(a, rel.type, rel.properties, b) YIELD rel AS r
return *
```