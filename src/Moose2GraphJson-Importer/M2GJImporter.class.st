Class {
	#name : #M2GJImporter,
	#superclass : #NeoJSONReader,
	#instVars : [
		'model'
	],
	#category : #'Moose2GraphJson-Importer'
}

{ #category : #importing }
M2GJImporter >> import [
	
]

{ #category : #accessing }
M2GJImporter >> model [
	^ model
]

{ #category : #accessing }
M2GJImporter >> model: anObject [
	model := anObject
]
