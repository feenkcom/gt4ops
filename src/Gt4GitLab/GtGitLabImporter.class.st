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
					each keyObject = 'include'
						ifTrue: [ each valueObject ifNotNil: [ :obj | self addIncludes: obj into: files ] ] ] ]
]

{ #category : #importing }
GtGitLabImporter >> addIncludes: obj into: files [
	| fn |
	obj isString
		ifTrue: [ fn := obj asFileReference.
			fn exists ifTrue: [ self loadFilesFrom: fn into: files ].
			^ self ].
	"obj isDictionary
		ifTrue: [ obj do: [ :each | self addIncludes: each into: files ] ]."
	(obj isKindOf: SequenceableCollection)
		ifTrue: [ obj do: [ :each | self addIncludes: each into: files ] ]
]

{ #category : #importing }
GtGitLabImporter >> importPipeline: aFileReference [
	| files |
	pipeline := GtGitLabPipeline new.
	files := self loadFilesFrom: aFileReference.
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
GtGitLabImporter >> loadFilesFrom: aFileReference [
	| files |
	files := OrderedCollection new.
	self loadFilesFrom: aFileReference into: files.
	^ files
]

{ #category : #importing }
GtGitLabImporter >> loadFilesFrom: aFileReference into: files [
	| ast |
	ast := YAMLParser parseFile: aFileReference.
	files add: ast.
	self addIncludedFilesFrom: ast into: files
]

{ #category : #importing }
GtGitLabImporter >> loadJobsFrom: files [
	files
		do: [ :file | 
			file object
				keysAndValuesDo: [ :key :value | 
					(key isString
						and: [ (key beginsWith: '.') not
								and: [ value isDictionary and: [ value includesKey: 'stage' ] ] ])
						ifTrue: [ | job stageName |
							job := self jobNamed: key.
							job ast: (file nodeForObject: value) parent.
							stageName := value at: 'stage'.
							job stage: (self stageNamed: stageName).
							job scripts addAll: (value at: 'script' ifAbsent: [ #() ]).
							(value at: 'dependencies' ifAbsent: [ #() ])
								do: [ :each | job addDependency: (self jobNamed: each) ].
							pipeline addJob: job ] ] ]
]

{ #category : #importing }
GtGitLabImporter >> loadStagesFrom: files [
	files
		do: [ :each | 
			each object
				at: 'stages'
				ifPresent: [ :obj | 
					obj
						inject: nil
						into: [ :previous :name | 
							| stage |
							stage := self stageNamed: name.
							stage previousStage: previous.
							stage ast: (each nodeForObject: name).
							pipeline addStage: stage.
							stage ].
					^ self ] ]
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
