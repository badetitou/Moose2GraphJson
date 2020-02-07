Class {
	#name : #M2GJStreamingRelationsWriter,
	#superclass : #NeoJSONStreamingWriter,
	#category : #'Moose2GraphJson-Exporter'
}

{ #category : #writing }
M2GJStreamingRelationsWriter >> writeElement: value [
	first 
		ifTrue: [ 
			jsonWriter newlineIndent. 
			first := false ]
		ifFalse: [ 
			jsonWriter listElementSeparator ].
	jsonWriter writeMooseEntityRelation: value 
]
