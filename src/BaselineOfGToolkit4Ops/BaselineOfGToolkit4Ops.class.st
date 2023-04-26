Class {
	#name : #BaselineOfGToolkit4Ops,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4Ops
}

{ #category : #baselines }
BaselineOfGToolkit4Ops >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'YAMLParser' with: [ spec repository: 'github://j-brant/SmaCC' ];
				package: 'Gt4GitLab' with: [ spec requires: 'YAMLParser' ];
				package: 'Gt4GitHub' with: [ spec requires: 'YAMLParser' ] ]
]
