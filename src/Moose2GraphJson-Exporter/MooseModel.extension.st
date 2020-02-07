Extension { #name : #MooseModel }

{ #category : #'*Moose2GraphJson-Exporter' }
MooseModel >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeMooseModel: self
]
