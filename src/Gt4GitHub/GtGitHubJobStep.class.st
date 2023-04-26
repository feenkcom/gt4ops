Class {
	#name : #GtGitHubJobStep,
	#superclass : #Object,
	#instVars : [
		'name',
		'script',
		'ast',
		'job',
		'action'
	],
	#category : #'Gt4GitHub-Model'
}

{ #category : #accessing }
GtGitHubJobStep >> action [
	^ action
]

{ #category : #accessing }
GtGitHubJobStep >> action: aString [
	action := aString
]

{ #category : #accessing }
GtGitHubJobStep >> ast [
	^ ast
]

{ #category : #accessing }
GtGitHubJobStep >> ast: aNode [
	ast := aNode
]

{ #category : #views }
GtGitHubJobStep >> gtAstViewFor: aView [
	<gtView>
	ast ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Source';
		stencil: [ self workflow astView: self ]
]

{ #category : #accessing }
GtGitHubJobStep >> gtDisplayOn: aStream [
	name ifNotNil: [ ^ aStream << name ].
	script ifNotNil: [ ^ aStream << script ].
	action ifNotNil: [ ^ aStream << action ].
	^ super gtDisplayOn: aStream
]

{ #category : #accessing }
GtGitHubJobStep >> job [
	^ job
]

{ #category : #accessing }
GtGitHubJobStep >> job: aJob [
	job := aJob
]

{ #category : #accessing }
GtGitHubJobStep >> name [
	^ name
]

{ #category : #accessing }
GtGitHubJobStep >> name: aString [
	name := aString
]

{ #category : #accessing }
GtGitHubJobStep >> script [
	^ script
]

{ #category : #accessing }
GtGitHubJobStep >> script: aString [
	script := aString
]

{ #category : #accessing }
GtGitHubJobStep >> workflow [
	^ job workflow
]
