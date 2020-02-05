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
