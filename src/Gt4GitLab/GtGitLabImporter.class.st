Class {
	#name : #GtGitLabImporter,
	#superclass : #Object,
	#instVars : [
		'pipeline',
		'stages',
		'jobs'
	],
	#category : #'Gt4GitLab-Importer'
}

{ #category : #importing }
GtGitLabImporter >> addIncludedFilesFrom: ast into: files [
	(ast isKindOf: YAMLMappingListNode)
		ifTrue: [ ast mappings
				do: [ :each | 
					each isErrorNode
						ifFalse: [ each keyObject = 'include'
								ifTrue: [ each valueObject ifNotNil: [ :obj | self addIncludes: obj into: files ] ] ] ] ]
]

{ #category : #importing }
GtGitLabImporter >> addIncludes: obj into: files [
	| fn |
	obj isString
		ifTrue: [ fn := obj asFileReference.
			fn exists ifTrue: [ self loadFromFile: fn into: files ].
			^ self ].
	"obj isDictionary
		ifTrue: [ obj do: [ :each | self addIncludes: each into: files ] ]."
	(obj isKindOf: SequenceableCollection)
		ifTrue: [ obj do: [ :each | self addIncludes: each into: files ] ]
]

{ #category : #importing }
GtGitLabImporter >> importPipelineFile: aFileReference [
	| files |
	pipeline := GtGitLabPipeline new.
	files := self loadFromFile: aFileReference.
	self loadStagesFrom: files.
	self loadJobsFrom: files.
	pipeline files: files.
	^ pipeline
]

{ #category : #importing }
GtGitLabImporter >> importPipelineString: aString [
	| files |
	pipeline := GtGitLabPipeline new.
	files := self loadFromString: aString.
	self loadStagesFrom: files.
	self loadJobsFrom: files.
	pipeline files: files.
	^ pipeline
]

{ #category : #initialization }
GtGitLabImporter >> initialize [
	super initialize.
	stages := Dictionary new.
	jobs := Dictionary new
]

{ #category : #importing }
GtGitLabImporter >> jobNamed: aString [
	^ jobs
		at: aString
		ifAbsentPut: [ GtGitLabJob new
				name: aString;
				yourself ]
]

{ #category : #importing }
GtGitLabImporter >> loadFromFile: aFileReference [
	| files |
	files := OrderedCollection new.
	self loadFromFile: aFileReference into: files.
	^ files
]

{ #category : #importing }
GtGitLabImporter >> loadFromFile: aFileReference into: files [
	| ast |
	ast := YAMLParser parseFileWithErrors: aFileReference.
	files add: ast.
	self addIncludedFilesFrom: ast into: files
]

{ #category : #importing }
GtGitLabImporter >> loadFromString: aString [
	| files |
	files := OrderedCollection new.
	self loadFromString: aString into: files.
	^ files
]

{ #category : #importing }
GtGitLabImporter >> loadFromString: aString into: files [
	| ast |
	ast := YAMLParser parseWithErrors: aString.
	files add: ast.
	self addIncludedFilesFrom: ast into: files
]

{ #category : #importing }
GtGitLabImporter >> loadJobsFrom: files [
	files
		do: [ :file | 
			file isErrorNode
				ifFalse: [ file object isDictionary
						ifTrue: [ file object
								keysAndValuesDo: [ :key :value | 
									(key isString
										and: [ (key beginsWith: '.') not
												and: [ value isDictionary and: [ value includesKey: 'stage' ] ] ])
										ifTrue: [ | job stageName |
											job := self jobNamed: key.
											job ast: (file nodeForObject: value) parent.
											stageName := value at: 'stage'.
											job stage: (self stageNamed: stageName).
											job scripts
												addAll: ((value at: 'script' ifAbsent: [  ]) ifNil: [ #() ]).
											((value at: 'dependencies' ifAbsent: [  ]) ifNil: [ #() ])
												do: [ :each | job addDependency: (self jobNamed: each) ].
											pipeline addJob: job ] ] ] ] ]
]

{ #category : #importing }
GtGitLabImporter >> loadStagesFrom: files [
	files
		do: [ :each | 
			each isErrorNode
				ifFalse: [ each object isDictionary
						ifTrue: [ each object
								at: 'stages'
								ifPresent: [ :obj | 
									(obj isString not and: [ obj isCollection ])
										ifTrue: [ obj
												inject: nil
												into: [ :previous :name | 
													| stage |
													stage := self stageNamed: name.
													stage previousStage: previous.
													stage ast: (each nodeForObject: name).
													pipeline addStage: stage.
													stage ] ].
									^ self ] ] ] ]
]

{ #category : #importing }
GtGitLabImporter >> stageNamed: aString [
	^ stages
		at: aString
		ifAbsentPut: [ GtGitLabStage new
				name: aString;
				pipeline: pipeline;
				yourself ]
]
