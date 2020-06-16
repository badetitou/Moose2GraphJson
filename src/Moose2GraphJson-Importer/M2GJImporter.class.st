Class {
	#name : #M2GJImporter,
	#superclass : #NeoJSONReader,
	#instVars : [
		'model',
		'entitiesMap',
		'relationMap'
	],
	#category : #'Moose2GraphJson-Importer'
}

{ #category : #importing }
M2GJImporter >> import [
	entitiesMap := Dictionary new.
	self
		parseMapKeysDo: [ :key | 
			model name: key.
			self
				parseMapKeysDo: [ :key2 | 
					key2 = 'nodes'
						ifTrue: [ self parseFamixEntities ]
						ifFalse: [ key2 = 'relationships'
								ifTrue: [ self parseFamixRelations ]
								ifFalse: [ Error signal: 'Key ' , key2 , ' should not exist' ] ] ] ]
]

{ #category : #importing }
M2GJImporter >> initialize [
	super initialize.
	"relationMap is used to create only one dictionary when parsing parseFamixRelations"
	relationMap := SmallDictionary new
]

{ #category : #accessing }
M2GJImporter >> metamodel [
	^ self model metamodel
]

{ #category : #accessing }
M2GJImporter >> model [
	^ model
]

{ #category : #accessing }
M2GJImporter >> model: anObject [
	model := anObject
]

{ #category : #importing }
M2GJImporter >> parseFamixEntities [
	self parseListDo: [ self parseFamixEntity ]
]

{ #category : #importing }
M2GJImporter >> parseFamixEntity [
	| id entity |
	self
		parseMapKeysDo: [ :key | 
			key = 'id' ifTrue: [ id := self parseValue ].
			key = 'labels'
				ifTrue: [ | list |
					list := self parseList.
					list anyOne.
					entity := (self metamodel elementNamed: list anyOne) createInstance.
					self model add: entity ].
			key = 'properties' ifTrue: [ self parsePropertiesFor: entity ] ].
	entitiesMap at: id put: entity
]

{ #category : #importing }
M2GJImporter >> parseFamixRelation [
	self parseMapKeysAndValuesDo: [ :key :value | self relationMap at: key put: value ].
	((entitiesMap at: (self relationMap at: #startNode)) mooseDescription propertyNamed: (self relationMap at: #type) asSymbol) isMultivalued
		ifTrue: [ ((entitiesMap at: (self relationMap at: #startNode)) perform: (self relationMap at: #type) asSymbol) add: (entitiesMap at: (self relationMap at: #endNode)) ]
		ifFalse: [ (entitiesMap at: (self relationMap at: #startNode))
				perform: (self relationMap at: #type) asSymbol asMutator
				with: (entitiesMap at: (self relationMap at: #endNode)) ]
]

{ #category : #importing }
M2GJImporter >> parseFamixRelations [
	self parseListDo: [ self parseFamixRelation ]
]

{ #category : #importing }
M2GJImporter >> parsePropertiesFor: entity [
	"parse the properties for entity"

	self parseMapKeysAndValuesDo: [ :key :value | entity perform: key asSymbol asMutator with: value ]
]

{ #category : #importing }
M2GJImporter >> relationMap [
	^ relationMap
]
