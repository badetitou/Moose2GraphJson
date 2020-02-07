Class {
	#name : #M2GJStreamingPropertiesWriter,
	#superclass : #NeoJSONStreamingWriter,
	#category : #'Moose2GraphJson-Exporter'
}

{ #category : #writing }
M2GJStreamingPropertiesWriter >> writeElement: value [
	first 
		ifTrue: [ 
			jsonWriter newlineIndent. 
			first := false ]
		ifFalse: [ 
			jsonWriter listElementSeparator ].
	jsonWriter writeMooseEntityProperties: value 
]
