# Moose2GraphJson

I can export any MooseModel in a json format adapted for graph database.

## Install

```smalltalk
Metacello new
  githubUser: 'badetitou' project: 'Moose2GraphJson' commitish: 'master' path: 'src';
  baseline: 'Moose2GraphJson';
  load
```

## Export a model

```smalltalk
'D:/test.json' asFileReference writeStreamDo: [ :stream | (M2GJExporter on: stream) writeMooseModel: aMooseModel ]
```

## Import a model

```smalltalk
(M2GJImporter on: 'D:/ref/to/model.json' asFileReference readStream) 
  model: MooseModel new;
  yourself.
importer import.
importer model name
```

## Import in neo4j

You can load the generated json file with this command

```db
CALL apoc.load.json('file:///test.json') YIELD value
WITH value.graph.nodes AS nodes, value.graph.relationships AS rels
UNWIND nodes AS n
CALL apoc.create.node(n.labels, apoc.map.setKey(n.properties, 'id', n.id)) YIELD node
WITH rels, COLLECT({id: n.id, node: node, labels:labels(node)}) AS nMap
UNWIND rels AS r
MATCH (w{id:r.startNode})
MATCH (y{id:r.endNode})
CALL apoc.create.relationship(w, r.type, r.properties, y) YIELD rel
RETURN rel
```

> In `value.graph.nodes`, please replace `graph`, by your model name (first element in the Json file)


## JSON model format

## Goal

Import and Export Fame model the following format

```json
{
    "modelName": {
        "nodes": [
            {
              "id": 3510982, 
              "labels": ["FAMIX.Class"],
              "properties": { "isStub": false, "isInterface": false, "numberOfLinesOfCode": 0, "name": "a" }
            },
            {
              "id": 3510983, 
              "labels": ["FAMIX.Attribute"],
              "properties": { "name": "a1", "hasClassScope": false, "numberOfLinesOfCode": -1, "isStub": false }
            },
            {
              "id": 3510984, 
              "labels": ["FAMIX.Attribute"],
              "properties": { "name": "a2", "hasClassScope": false, "numberOfLinesOfCode": -1, "isStub": false }
            }
        ],
        "relationships": [
            { "type": "parentType", "startNode": 3510983, "endNode": 3510982, "properties": {} },
            { "type": "parentType", "startNode": 3510984, "endNode": 3510982, "properties": {} }
        ]
    }
}
```
