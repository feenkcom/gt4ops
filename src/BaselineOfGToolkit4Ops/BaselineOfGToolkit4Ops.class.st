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
				spec repository: 'github://j-brant/SmaCC:ce13715b369a87eac6c69ae90e46623eefc776e4/src' ].

		spec package: 'Gt4GitLab' with: [
			spec requires: #(#YAMLParser) ].
		spec package: 'Gt4GitHub' with: [
			spec requires: #(#YAMLParser) ].
	]
]
