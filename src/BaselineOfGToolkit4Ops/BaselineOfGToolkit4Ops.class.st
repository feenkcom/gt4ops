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
				spec repository: 'github://j-brant/SmaCC:25ab055db78eee98a1a1267ca2f137052c5b5f96/src' ].

		spec package: 'Gt4GitLab' with: [
			spec requires: #(#YAMLParser) ].
		spec package: 'Gt4GitHub' with: [
			spec requires: #(#YAMLParser) ].
	]
]
