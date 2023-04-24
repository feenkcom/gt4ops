Class {
	#name : #GtGitHubEvent,
	#superclass : #Object,
	#instVars : [
		'name',
		'ast',
		'workflow'
	],
	#category : #'Gt4GitHub-Model'
}

{ #category : #accessing }
GtGitHubEvent >> ast [
	^ ast
]

{ #category : #accessing }
GtGitHubEvent >> ast: aNode [
	ast := aNode
]

{ #category : #views }
GtGitHubEvent >> gtAstViewFor: aView [
	<gtView>
	ast ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Source';
		stencil: [ self workflow astView: self ]
]

{ #category : #accessing }
GtGitHubEvent >> gtDisplayOn: aStream [
	aStream << name
]

{ #category : #accessing }
GtGitHubEvent >> name [
	^ name
]

{ #category : #accessing }
GtGitHubEvent >> name: aString [
	name := aString
]

{ #category : #accessing }
GtGitHubEvent >> workflow [
	^ workflow
]

{ #category : #accessing }
GtGitHubEvent >> workflow: aWorkflow [
	workflow := aWorkflow
]
