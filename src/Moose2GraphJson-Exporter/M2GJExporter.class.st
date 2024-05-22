Class {
	#name : #M2GJExporter,
	#superclass : #NeoJSONWriter,
	#category : #'Moose2GraphJson-Exporter'
}

{ #category : #writing }
M2GJExporter >> propertiesOfToExport: entity [

	^ entity allDeclaredProperties reject: [ :property |
		  property isDerived or: [
			  property hasOpposite or: [
				  (entity propertyNamed: property name ifAbsent: [ nil ]) isNil
					  or: [
						  property type name = #Object or: [
							  (entity propertyNamed: property name) isCollection and: [
								  (entity propertyNamed: property name) isEmpty ] ] ] ] ] ]
]

{ #category : #writing }
M2GJExporter >> relationsToExport: aMooseModel [

	| col |
	col := OrderedCollection new.
	aMooseModel entities do: [ :entity |
		entity allDeclaredProperties
			reject: [ :property |
				property isDerived or: [
					property hasOpposite not or: [
						(entity propertyNamed: property name ifAbsent: [ nil ]) isNil ] ] ]
			thenDo: [ :property |
				(entity propertyNamed: property name) isCollection
					ifTrue: [
						(entity propertyNamed: property name) do: [ :value |
							col add: {
									entity.
									property.
									value } ] ]
					ifFalse: [
						col add: {
								entity.
								property.
								(entity propertyNamed: property name) } ] ] ].
	^ col
]

{ #category : #writing }
M2GJExporter >> writeMooseEntityProperties: entity [
	self
		writeMapStreamingDo: [ :jsonMapWriter | 
			jsonMapWriter writeKey: 'id' value: entity mooseID.
			jsonMapWriter writeKey: 'labels' value: {entity mooseDescription fullName}.
			self mapElementSeparator.
			self encodeKey: 'properties'.
			self
				writeMapStreamingDo:
					[ :secondJsonMapWriter | (self propertiesOfToExport: entity) do: [ :property | secondJsonMapWriter writeKey: property name value: (entity propertyNamed: property name) ] ] ]
]

{ #category : #writing }
M2GJExporter >> writeMooseEntityRelation: entity [
	self
		writeMapStreamingDo: [ :jsonMapWriter | 
			jsonMapWriter writeKey: 'type' value: entity second name.
			jsonMapWriter writeKey: 'startNode' value: entity first mooseID.
			jsonMapWriter writeKey: 'endNode' value: entity third mooseID.
			jsonMapWriter writeKey: 'properties' value: {} asDictionary ]
]

{ #category : #writing }
M2GJExporter >> writeMooseModel: aMooseModel [
	writeStream nextPut: ${.
	self
		writeStreamingDo: [ :jsonMapWriter | 
			jsonMapWriter writeKey: 'name' value: aMooseModel name.
			self mapElementSeparator.
			self writeNodesOf: aMooseModel.
			self mapElementSeparator.
			self writeRelationshipsOf: aMooseModel.
			writeStream nextPut: $} ].
	writeStream flush; close.
]

{ #category : #writing }
M2GJExporter >> writeNodesOf: aMooseModel [
	self encodeKey: 'nodes'.
	self writePropertiesDo: [ :jsonMapWriter | aMooseModel entities do: [ :entity | jsonMapWriter writeElement: entity ] ]
]

{ #category : #writing }
M2GJExporter >> writePropertiesDo: block [
	| mapWriter |
	writeStream nextPut: $[.
	mapWriter := M2GJStreamingPropertiesWriter on: self.
	self indentedDo: [ block value: mapWriter ].
	mapWriter wasUsed ifTrue: [ self newlineIndent ] ifFalse: [ self prettyPrintSpace ].
	writeStream nextPut: $]
]

{ #category : #writing }
M2GJExporter >> writeRelationsDo: block [
	| mapWriter |
	writeStream nextPut: $[.
	mapWriter := M2GJStreamingRelationsWriter on: self.
	self indentedDo: [ block value: mapWriter ].
	mapWriter wasUsed ifTrue: [ self newlineIndent ] ifFalse: [ self prettyPrintSpace ].
	writeStream nextPut: $]
]

{ #category : #writing }
M2GJExporter >> writeRelationshipsOf: aMooseModel [
	self encodeKey: 'relationships'.
	self writeRelationsDo: [ :jsonMapWriter | (self relationsToExport: aMooseModel) do: [ :entity | jsonMapWriter writeElement: entity ] ]
]
