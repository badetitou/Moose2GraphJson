# Moose2GraphJson

I can export and import any MooseModel in a json format adapted for graph database

## Install

### Stable version

```smalltalk
Metacello new
  githubUser: 'badetitou' project: 'Moose2GraphJson' commitish: 'v1.0.0' path: 'src';
  baseline: 'Moose2GraphJson';
  load
```

### Last version

```smalltalk
Metacello new
  githubUser: 'badetitou' project: 'Moose2GraphJson' commitish: 'main' path: 'src';
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
CALL apoc.load.json('file:///test-graph.json') YIELD value
WITH value.nodes AS nodes, value.relationships AS rels
UNWIND nodes AS n
CALL apoc.create.node(n.labels, apoc.map.setKey(n.properties, 'id', n.id)) YIELD node
WITH rels, apoc.map.fromPairs(COLLECT([n.id, node])) AS nMap
UNWIND rels AS r
WITH r, nMap[TOSTRING(r.startNode)] AS startNode, nMap[TOSTRING(r.endNode)] AS endNode
WHERE startNode IS NOT NULL and endNode IS NOT NULL 
CALL apoc.create.relationship(startNode, r.type, r.properties, endNode) YIELD rel
RETURN rel
```

## JSON model format

## Goal

Import and Export Fame model the following format

```json
{
  "name":"modelName",
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
```
