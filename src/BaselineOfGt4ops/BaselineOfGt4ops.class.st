Class {
	#name : #BaselineOfGt4ops,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4ops
}

{ #category : #baselines }
BaselineOfGt4ops >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'SmaCC_YAML' with: [ spec repository: 'github://j-brant/SmaCC' ];
				package: 'Gt4GitLab' with: [ spec requires: 'SmaCC_YAML' ] ]
]
