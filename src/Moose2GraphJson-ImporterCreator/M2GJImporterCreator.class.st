"
If you parse a model of an unknow metamodel you can use me to import the metamodel before

you can set the prefix and the package name

"
Class {
	#name : #M2GJImporterCreator,
	#superclass : #NeoJSONReader,
	#instVars : [
		'entitiesMap',
		'relationMap',
		'builder',
		'prefix',
		'packageName'
	],
	#category : #'Moose2GraphJson-ImporterCreator'
}

{ #category : #importing }
M2GJImporterCreator >> builder [
	^ builder
]

{ #category : #importing }
M2GJImporterCreator >> defaultBuilder [
	^ FamixMetamodelBuilder
]

{ #category : #importing }
M2GJImporterCreator >> determineTypeOf: value [
	value isString ifTrue: [ ^ #String ].
	value isNumber ifTrue: [ ^ #Number ].
	value isBoolean ifTrue: [ ^ #Boolean ].
	^ #Object.
	
]

{ #category : #generate }
M2GJImporterCreator >> generate [
	"set moose model name"
	self builder configuration mooseModelName: self mooseModelName.
	self builder generate.
	(self class environment classNamed: self mooseModelName) resetMetamodel
]

{ #category : #importing }
M2GJImporterCreator >> import [
	self builder configuration prefix: self prefix.
	self builder configuration packageName: self packageName.
	entitiesMap := Dictionary new.
	self
		parseMapKeysDo: [ :key2 | 
			key2 = 'name'
				ifTrue: [ self parseValue ]
				ifFalse: [ key2 = 'nodes'
						ifTrue: [ self parseFamixEntities ]
						ifFalse: [ key2 = 'relationships'
								ifTrue: [ self parseFamixRelations ]
								ifFalse: [ Error signal: 'Key ' , key2 , ' should not exist' ] ] ] ]
]

{ #category : #importing }
M2GJImporterCreator >> initialize [
	super initialize.
	"relationMap is used to create only one dictionary when parsing parseFamixRelations"
	relationMap := SmallDictionary new.
	builder := self defaultBuilder new.
	self prefix: #'M2DJC'.
	self packageName: #'M2DGJC-Generated'
	
]

{ #category : #accessing }
M2GJImporterCreator >> mooseModelName [
	^ self prefix, 'Model'
]

{ #category : #accessing }
M2GJImporterCreator >> packageName [
	^ packageName
]

{ #category : #accessing }
M2GJImporterCreator >> packageName: anObject [
	packageName := anObject
]

{ #category : #importing }
M2GJImporterCreator >> parseFamixEntities [
	self parseListDo: [ self parseFamixEntity ]
]

{ #category : #importing }
M2GJImporterCreator >> parseFamixEntity [
	| entity id |
	self
		parseMapKeysDo: [ :key | 
			key = 'id' ifTrue: [ id := self parseValue ].
			key = 'labels'
				ifTrue: [ | list |
					list := self parseList.
					entity := self builder ensureClassNamed: (list anyOne substrings: '.') second ].
			key = 'properties' ifTrue: [ self parsePropertiesFor: entity ] ].
	entitiesMap at: id put: entity
]

{ #category : #importing }
M2GJImporterCreator >> parseFamixRelation [
	| map | 
	map := self parseMap.
	 relationMap at: (self resolveAssociationFrom: map) ifPresent: [ :collection | collection add: (map at: #type) ] ifAbsentPut: {(map at: #type)} asOrderedCollection .
]

{ #category : #importing }
M2GJImporterCreator >> parseFamixRelations [
	"fill list"

	self parseListDo: [ self parseFamixRelation ].
	"complete builder"
	relationMap associationsDo: [ :assoc | (assoc key key property: assoc value anyOne asSymbol) *-* assoc key value ]
]

{ #category : #importing }
M2GJImporterCreator >> parsePropertiesFor: entity [
	"parse the properties for entity"

	self parseMapKeysAndValuesDo: [ :key :value | 		
		entity property: key type: (self determineTypeOf: value) ]
]

{ #category : #accessing }
M2GJImporterCreator >> prefix [
	^ prefix
]

{ #category : #accessing }
M2GJImporterCreator >> prefix: aPrefix [
	prefix := aPrefix
]

{ #category : #importing }
M2GJImporterCreator >> relationMap [
	^ relationMap
]

{ #category : #importing }
M2GJImporterCreator >> resolveAssociationFrom: map [
	^ (entitiesMap at: (map at: #startNode)) -> (entitiesMap at: (map at: #endNode))
]
