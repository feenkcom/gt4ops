Class {
	#name : #GtGitHubWorkflows,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#instVars : [
		'directory'
	],
	#category : #'Gt4GitHub-Model'
}

{ #category : #accessing }
GtGitHubWorkflows >> directory [
	^ directory
]

{ #category : #accessing }
GtGitHubWorkflows >> directory: aFileReference [
	directory := aFileReference
]

{ #category : #accessing }
GtGitHubWorkflows >> gtWorkflowsView: aView [
	<gtView>
	^ aView list
		title: 'Workflows';
		items: [ self items ]
]

{ #category : #accessing }
GtGitHubWorkflows >> workflows [
	^ self items
]
