Class {
	#name : #GtGitLabPipeline,
	#superclass : #Object,
	#instVars : [
		'stages',
		'jobs',
		'files'
	],
	#category : #'Gt4GitLab-Model'
}

{ #category : #accessing }
GtGitLabPipeline >> addJob: aJob [
	jobs add: aJob
]

{ #category : #accessing }
GtGitLabPipeline >> addStage: aStage [
	stages add: aStage
]

{ #category : #accessing }
GtGitLabPipeline >> ast [
	^ files notEmpty ifTrue: [ files first ] ifFalse: [ nil ]
]

{ #category : #accessing }
GtGitLabPipeline >> astView: anObject [
	| nodeMap styler |
	nodeMap := Dictionary new.
	self stages
		do: [ :each | each ast ifNotNil: [ :node | nodeMap at: node put: each ] ].
	self jobs
		do: [ :each | each ast ifNotNil: [ :node | nodeMap at: node put: each ] ].
	styler := (GtSmaCCParserStyler forParser: YAMLParser)
			stylerRules: {GtSmaCCNodeStylerRule
						nodeClassName: #YAMLParseNode
						styleBlock: [ :styleable :node :text | 
							nodeMap
								at: node
								ifPresent: [ :obj | 
									| position |
									position := ((node isKindOf: YAMLMappingNode)
											ifTrue: [ node key ]
											ifFalse: [ node ]) stopPosition.
									text
										attribute: (BrTextAdornmentDynamicAttribute new
												beAppend;
												beNotOverwritableByStyler;
												stencil: [ BrButton new
														background: BrGlamorousColors defaultButtonBorderColor;
														size: 8 @ 8;
														geometry: BlEllipseGeometry new;
														margin: (BlInsets left: 2 right: 2);
														action: [ :button | button phlow spawnObject: obj ] ])
										from: position
										to: position ] ]}.
	^ anObject ast
		gtSourceEditorWithHighlight: BrGlamorousColors neutralBackgroundColor
		styler: (GtCompositeSmaCCASTStyler new
				stylers: {GtSmaCCParserStyler yamlStylerWithAliasExpander: YAMLParser.
						styler})
]

{ #category : #accessing }
GtGitLabPipeline >> files [
	^ files
]

{ #category : #accessing }
GtGitLabPipeline >> files: anObject [
	files := anObject
]

{ #category : #accessing }
GtGitLabPipeline >> gtAstViewFor: aView [
	<gtView>
	self ast ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Source';
		priority: 10;
		stencil: [ self astView: self ]
]

{ #category : #accessing }
GtGitLabPipeline >> gtGraphViewFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Pipeline';
		priority: 10;
		painting: [ :mondrian | 
			mondrian nodes
				shape: [ :stage | 
					BlElement new
						constraintsDo: [ :c | c margin: (BlInsets all: 10) ];
						border: (BlBorder paint: Color black width: 1);
						addChild: (BrLabel new
								hMatchParent;
								vFitContent;
								padding: (BlInsets all: 5);
								text: stage name asRopedText;
								border: (BlBorder paint: Color black width: 1);
								background: BrGlamorousColors neutralBackgroundColor;
								aptitude: BrGlamorousLabelAptitude new);
						yourself ];
				with: stages
					forEach: [ :each | 
						mondrian nodes
							shape: [ :job | 
								BrLabel new
									margin: (BlInsets
											top: 5
											left: 10
											bottom: 5
											right: 10);
									text: job name asRopedText;
									aptitude: BrGlamorousLabelAptitude new;
									geometry: (BlRoundedRectangleGeometry cornerRadius: 2) ];
							with: each jobs.
						mondrian layout vertical ].
			mondrian edges
				fromNearestBounds;
				toNearestBounds;
				shape: [ :each | 
					BlLineElement new
						toHead: (BlArrowheadSimpleArrow new
								border: (BlBorder paint: (Color gray alpha: 0.5) width: 10));
						border: (BlBorder paint: (Color gray alpha: 0.5) width: 2) ];
				connectToAll: [ :each | each nextStage ifNil: [ #() ] ifNotNil: [ :stage | {stage} ] ] ]
]

{ #category : #initialization }
GtGitLabPipeline >> initialize [
	super initialize.
	files := OrderedCollection new.
	stages := OrderedCollection new.
	jobs := OrderedCollection new
]

{ #category : #accessing }
GtGitLabPipeline >> jobs [
	^ jobs
]

{ #category : #accessing }
GtGitLabPipeline >> jobs: anObject [
	jobs := anObject
]

{ #category : #accessing }
GtGitLabPipeline >> stages [
	^ stages
]

{ #category : #accessing }
GtGitLabPipeline >> stages: anObject [
	stages := anObject
]
