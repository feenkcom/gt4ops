Class {
	#name : #GtGitHubImporter,
	#superclass : #Object,
	#instVars : [
		'jobs',
		'ast'
	],
	#category : #'Gt4GitHub-Importer'
}

{ #category : #importing }
GtGitHubImporter >> addJobDataFrom: aDictionary to: job [
	job ast: ((ast nodeForObject: aDictionary) ifNotNil: [ :node | node parent ]).
	aDictionary
		at: 'needs'
		ifPresent: [ :value | 
			value isString
				ifTrue: [ job addDependency: (self jobNamed: value) ]
				ifFalse: [ value isCollection
						ifTrue: [ value do: [ :each | job addDependency: (self jobNamed: each) ] ] ] ].
	aDictionary
		at: 'steps'
		ifPresent: [ :steps | steps do: [ :each | job addStep: (self createStepFrom: each) ] ]
]

{ #category : #importing }
GtGitHubImporter >> createStepFrom: aDictionary [
	| step |
	step := GtGitHubJobStep new.
	step ast: (ast nodeForObject: aDictionary).
	step name: (aDictionary at: 'name' ifAbsent: [  ]).
	step script: (aDictionary at: 'run' ifAbsent: [  ]).
	step action: (aDictionary at: 'uses' ifAbsent: [  ]).
	^ step
]

{ #category : #importing }
GtGitHubImporter >> importJobsFrom: aDictionary into: workflow [
	(aDictionary at: 'jobs' ifAbsent: [ #() ])
		keysAndValuesDo: [ :key :value | 
			| job |
			job := self jobNamed: key.
			self addJobDataFrom: value to: job.
			workflow addJob: job ]
]

{ #category : #importing }
GtGitHubImporter >> importTriggersFrom: aDictionary into: workflow [
	aDictionary
		at: 'on'
		ifPresent: [ :dict | 
			(dict isDictionary ifTrue: [ dict keys ] ifFalse: [ dict ])
				do: [ :each | 
					| event |
					event := GtGitHubEvent new.
					event name: each.
					event
						ast: ((ast nodeForObject: each)
								ifNotNil: [ :node | 
									(node parent isKindOf: YAMLMappingNode)
										ifTrue: [ node parent ]
										ifFalse: [ node ] ]).
					workflow addTrigger: event ] ]
]

{ #category : #importing }
GtGitHubImporter >> importWorkflow: aFileReference [
	| workflow obj |
	jobs := Dictionary new.
	ast := YAMLParser parseFile: aFileReference.
	obj := ast object.
	workflow := GtGitHubWorkflow new.
	workflow
		name: (obj at: 'name' ifAbsent: [ aFileReference basenameWithoutExtension ]).
	workflow ast: ast.
	self importJobsFrom: obj into: workflow.
	self importTriggersFrom: obj into: workflow.
	jobs := nil.
	^ workflow
]

{ #category : #importing }
GtGitHubImporter >> importWorkflows: aFileReference [
	| workflows |
	workflows := GtGitHubWorkflows new.
	workflows directory: aFileReference asFileReference.
	(workflows directory filesMatching: '*.yml;*.yaml')
		do: [ :each | workflows add: (self importWorkflow: each) ].
	^ workflows
]

{ #category : #importing }
GtGitHubImporter >> jobNamed: aString [
	^ jobs
		at: aString
		ifAbsentPut: [ GtGitHubJob new
				name: aString;
				yourself ]
]
