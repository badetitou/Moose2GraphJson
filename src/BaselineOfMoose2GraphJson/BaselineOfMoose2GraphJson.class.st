Class {
	#name : #BaselineOfMoose2GraphJson,
	#superclass : #BaselineOf,
	#category : #BaselineOfMoose2GraphJson
}

{ #category : #baselines }
BaselineOfMoose2GraphJson >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			self defineDependencies: spec.
			self definePackages: spec.
			self defineGroups: spec ]
]

{ #category : #baselines }
BaselineOfMoose2GraphJson >> defineDependencies: spec [
	spec
		baseline: 'NeoJSON'
		with: [ spec
				repository: 'github://svenvc/NeoJSON/repository' ]
]

{ #category : #baselines }
BaselineOfMoose2GraphJson >> defineGroups: spec [

]

{ #category : #baselines }
BaselineOfMoose2GraphJson >> definePackages: spec [
	spec
		package: 'Moose2GraphJson-Exporter' with: [ spec requires: #('NeoJSON') ];
		package: 'Moose2GraphJson-Importer' with: [ spec requires: #('NeoJSON') ]
]
