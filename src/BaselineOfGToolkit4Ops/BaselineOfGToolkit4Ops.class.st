Class {
	#name : #BaselineOfGToolkit4Ops,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4Ops
}

{ #category : #baseline }
BaselineOfGToolkit4Ops >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'YAMLParser' with: [
				spec repository: 'github://j-brant/SmaCC:002450820e55dac98fb3164e856ecc69a2edd101/src' ].

		spec package: 'Gt4GitLab' with: [
			spec requires: #(#YAMLParser) ].
		spec package: 'Gt4GitHub' with: [
			spec requires: #(#YAMLParser) ].
	]
]
