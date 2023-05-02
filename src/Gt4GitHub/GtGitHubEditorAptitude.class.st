Class {
	#name : #GtGitHubEditorAptitude,
	#superclass : #BrGlamorousCodeEditorAptitude,
	#instVars : [
		'completionController'
	],
	#category : #'Gt4GitHub-Aptitudes'
}

{ #category : #initialization }
GtGitHubEditorAptitude >> initialize [
	| controller |
	super initialize.
	self
		addChange: (BrLookChange new
				up: [ :e | 
					| completion |
					self styler: GtGitHubWorkflowStyler new.
					widget viewModel styler: styler.
					completion := GtGitHubCompletionStrategy new.
					controller := GtCompletionController on: widget strategy: completion.
					controller install ];
				down: [ :e | controller ifNotNil: [ controller uninstall ] ];
				yourself)
]
