Class {
	#name : #GtGitHubJob,
	#superclass : #Object,
	#instVars : [
		'name',
		'steps',
		'dependencies',
		'ast',
		'workflow'
	],
	#category : #'Gt4GitHub-Model'
}

{ #category : #accessing }
GtGitHubJob >> addDependency: aJob [
	dependencies add: aJob
]

{ #category : #accessing }
GtGitHubJob >> addStep: aStep [
	steps add: aStep.
	aStep job: self
]

{ #category : #accessing }
GtGitHubJob >> ast [
	^ ast
]

{ #category : #accessing }
GtGitHubJob >> ast: anObject [
	ast := anObject
]

{ #category : #accessing }
GtGitHubJob >> dependencies [
	^ dependencies
]

{ #category : #accessing }
GtGitHubJob >> dependencies: anObject [
	dependencies := anObject
]

{ #category : #views }
GtGitHubJob >> gtAstViewFor: aView [
	<gtView>
	ast ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Source';
		stencil: [ self workflow astView: self ]
]

{ #category : #printing }
GtGitHubJob >> gtDisplayOn: aStream [
	aStream << name
]

{ #category : #views }
GtGitHubJob >> gtStepsViewFor: aView [
	<gtView>
	^ aView list
		title: 'Steps';
		items: [ steps ]
]

{ #category : #initialization }
GtGitHubJob >> initialize [
	super initialize.
	steps := OrderedCollection new.
	dependencies := OrderedCollection new
]

{ #category : #accessing }
GtGitHubJob >> name [
	^ name
]

{ #category : #accessing }
GtGitHubJob >> name: aString [
	name := aString
]

{ #category : #accessing }
GtGitHubJob >> removeStep: aStep [
	steps remove: aStep ifAbsent: [  ].
	aStep job: nil
]

{ #category : #accessing }
GtGitHubJob >> steps [
	^ steps
]

{ #category : #accessing }
GtGitHubJob >> steps: anObject [
	steps := anObject
]

{ #category : #accessing }
GtGitHubJob >> workflow [
	^ workflow
]

{ #category : #accessing }
GtGitHubJob >> workflow: aWorkflow [
	workflow := aWorkflow
]
