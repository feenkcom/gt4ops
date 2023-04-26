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
	aDictionary isDictionary ifFalse: [ ^ self ].
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
		ifPresent: [ :steps | 
			(steps isString not and: [ steps isCollection ])
				ifTrue: [ steps do: [ :each | job addStep: (self createStepFrom: each) ] ] ]
]

{ #category : #importing }
GtGitHubImporter >> createStepFrom: aDictionary [
	| step |
	step := GtGitHubJobStep new.
	aDictionary isDictionary ifFalse: [ ^ step ].
	step ast: (ast nodeForObject: aDictionary).
	step name: (aDictionary at: 'name' ifAbsent: [  ]).
	step script: (aDictionary at: 'run' ifAbsent: [  ]).
	step action: (aDictionary at: 'uses' ifAbsent: [  ]).
	^ step
]

{ #category : #importing }
GtGitHubImporter >> createWorkflow [
	| obj workflow |
	workflow := GtGitHubWorkflow new.
	ast isErrorNode ifTrue: [ ^ workflow ].
	obj := ast object.
	workflow ast: ast.
	jobs := Dictionary new.
	self importJobsFrom: obj into: workflow.
	self importTriggersFrom: obj into: workflow.
	jobs := nil.
	^ workflow
]

{ #category : #importing }
GtGitHubImporter >> importJobsFrom: aDictionary into: workflow [
	aDictionary isDictionary ifFalse: [ ^ self ].
	((aDictionary
		at: 'jobs'
		ifPresent: [ :dict | dict isDictionary ifTrue: [ dict ] ]
		ifAbsent: [  ]) ifNil: [ #() ])
		keysAndValuesDo: [ :key :value | 
			| job |
			job := self jobNamed: key.
			self addJobDataFrom: value to: job.
			workflow addJob: job ]
]

{ #category : #importing }
GtGitHubImporter >> importTriggersFrom: aDictionary into: workflow [
	aDictionary isDictionary ifFalse: [ ^ self ].
	aDictionary
		at: 'on'
		ifPresent: [ :dict | 
			(dict isDictionary
				ifTrue: [ dict keys ]
				ifFalse: [ (dict isString not and: [ dict isCollection ])
						ifTrue: [ dict ]
						ifFalse: [ #() ] ])
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
GtGitHubImporter >> importWorkflowAST: anAST [
	ast := anAST.
	^ self createWorkflow
]

{ #category : #importing }
GtGitHubImporter >> importWorkflowFile: aFileReference [
	| workflow |
	ast := YAMLParser parseFileWithErrors: aFileReference.
	workflow := self createWorkflow.
	workflow
		name: ((ast object isDictionary ifTrue: [ ast object ] ifFalse: [ Dictionary new ])
				at: 'name'
				ifAbsent: [ aFileReference basenameWithoutExtension ]).
	^ workflow
]

{ #category : #importing }
GtGitHubImporter >> importWorkflowString: aString [
	ast := YAMLParser parseWithErrors: aString.
	^ self createWorkflow
]

{ #category : #importing }
GtGitHubImporter >> importWorkflows: aFileReference [
	| workflows |
	workflows := GtGitHubWorkflows new.
	workflows directory: aFileReference asFileReference.
	(workflows directory filesMatching: '*.yml;*.yaml')
		do: [ :each | workflows add: (self importWorkflowFile: each) ].
	^ workflows
]

{ #category : #importing }
GtGitHubImporter >> jobNamed: aString [
	^ jobs
		at: aString asString
		ifAbsentPut: [ GtGitHubJob new
				name: aString asString;
				yourself ]
]
