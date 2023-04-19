Class {
	#name : #GtGitLabJob,
	#superclass : #Object,
	#instVars : [
		'scripts',
		'stage',
		'name',
		'ast'
	],
	#category : #'Gt4GitLab-Model'
}

{ #category : #accessing }
GtGitLabJob >> addScript: aString [
	scripts add: aString
]

{ #category : #accessing }
GtGitLabJob >> ast [
	^ ast
]

{ #category : #accessing }
GtGitLabJob >> ast: aNode [
	ast := aNode
]

{ #category : #accessing }
GtGitLabJob >> gtAstViewFor: aView [
	<gtView>
	ast ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Source';
		priority: 10;
		object: [ ast ];
		view: #gtSourceFor:
]

{ #category : #accessing }
GtGitLabJob >> gtDisplayOn: stream [
	stream nextPutAll: name
]

{ #category : #accessing }
GtGitLabJob >> gtScriptsFor: aView [
	<gtView>
	^ aView list
		title: 'Scripts';
		items: [ scripts ]
]

{ #category : #initialization }
GtGitLabJob >> initialize [
	super initialize.
	scripts := OrderedCollection new
]

{ #category : #accessing }
GtGitLabJob >> name [
	^ name
]

{ #category : #accessing }
GtGitLabJob >> name: aString [
	name := aString
]

{ #category : #accessing }
GtGitLabJob >> scripts [
	^ scripts
]

{ #category : #accessing }
GtGitLabJob >> scripts: anObject [
	scripts := anObject
]

{ #category : #accessing }
GtGitLabJob >> stage [
	^ stage
]

{ #category : #accessing }
GtGitLabJob >> stage: aStage [
	stage ifNotNil: [ stage removeJob: self ].
	stage := aStage.
	stage ifNotNil: [ stage addJob: self ]
]
