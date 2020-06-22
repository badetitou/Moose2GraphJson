"
If you parse a model of an unknow metamodel you can use me to import the metamodel before

you can set the prefix and the package name

"
Class {
	#name : #M2GJImporterCreator,
	#superclass : #NeoJSONReader,
	#instVars : [
		'model',
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

{ #category : #generate }
M2GJImporterCreator >> generate [
	self builder generate
]

{ #category : #importing }
M2GJImporterCreator >> import [
	entitiesMap := Dictionary new.
	self
		parseMapKeysDo: [ :key2 | 
			key2 = 'name'
				ifTrue: [ model name: self parseValue ]
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
	self packageName: #'M2DGJC-Generated'.
	
]

{ #category : #accessing }
M2GJImporterCreator >> metamodel [
	^ self model metamodel
]

{ #category : #accessing }
M2GJImporterCreator >> model [
	^ model
]

{ #category : #accessing }
M2GJImporterCreator >> model: anObject [
	model := anObject
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
	self parseMapKeysAndValuesDo: [ :key :value | self relationMap at: key put: value ].
]

{ #category : #importing }
M2GJImporterCreator >> parseFamixRelations [
	self parseListDo: [ self parseFamixRelation ]
]

{ #category : #importing }
M2GJImporterCreator >> parsePropertiesFor: entity [
	"parse the properties for entity"

	self parseMapKeysAndValuesDo: [ :key :value | entity property: key ]
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
