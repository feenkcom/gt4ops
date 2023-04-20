Class {
	#name : #GtGitLabStage,
	#superclass : #Object,
	#instVars : [
		'jobs',
		'previousStage',
		'nextStage',
		'name',
		'ast',
		'pipeline'
	],
	#category : #'Gt4GitLab-Model'
}

{ #category : #accessing }
GtGitLabStage >> addJob: aJob [
	jobs add: aJob
]

{ #category : #accessing }
GtGitLabStage >> ast [
	^ ast
]

{ #category : #accessing }
GtGitLabStage >> ast: aNode [
	ast := aNode
]

{ #category : #accessing }
GtGitLabStage >> gtDisplayOn: stream [
	stream nextPutAll: name
]

{ #category : #accessing }
GtGitLabStage >> gtJobsFor: aView [
	<gtView>
	^ aView tree
		title: 'Jobs';
		items: [ jobs ];
		children: [ :each | (each isKindOf: GtGitLabJob) ifTrue: [ each scripts ] ifFalse: [ #() ] ];
		itemText: [ :each | 
			(each isString ifTrue: [ each ] ifFalse: [ each name ]) asRopedText
				glamorousRegularFont ]
]

{ #category : #initialization }
GtGitLabStage >> initialize [
	super initialize.
	jobs := OrderedCollection new
]

{ #category : #accessing }
GtGitLabStage >> jobs [
	^ jobs
]

{ #category : #accessing }
GtGitLabStage >> jobs: anObject [
	jobs := anObject
]

{ #category : #accessing }
GtGitLabStage >> name [
	^ name
]

{ #category : #accessing }
GtGitLabStage >> name: aString [
	name := aString
]

{ #category : #accessing }
GtGitLabStage >> nextStage [
	^ nextStage
]

{ #category : #accessing }
GtGitLabStage >> nextStage: aStage [
	nextStage := aStage
]

{ #category : #accessing }
GtGitLabStage >> pipeline [
	^ pipeline
]

{ #category : #accessing }
GtGitLabStage >> pipeline: aPipeline [
	pipeline := aPipeline
]

{ #category : #accessing }
GtGitLabStage >> previousStage [
	^ previousStage
]

{ #category : #accessing }
GtGitLabStage >> previousStage: aStage [
	previousStage ifNotNil: [ previousStage nextStage: nil ].
	previousStage := aStage.
	previousStage ifNotNil: [ previousStage nextStage: self ]
]

{ #category : #accessing }
GtGitLabStage >> removeJob: aJob [
	jobs remove: aJob ifAbsent: [  ]
]
