Class {
	#name : #GtGitHubWorkflow,
	#superclass : #Object,
	#instVars : [
		'jobs',
		'name',
		'triggers',
		'ast'
	],
	#category : #'Gt4GitHub-Model'
}

{ #category : #jobs }
GtGitHubWorkflow >> addJob: aJob [
	jobs add: aJob.
	aJob workflow: self
]

{ #category : #accessing }
GtGitHubWorkflow >> addTrigger: anEvent [
	triggers add: anEvent.
	anEvent workflow: self
]

{ #category : #accessing }
GtGitHubWorkflow >> ast [
	^ ast
]

{ #category : #accessing }
GtGitHubWorkflow >> ast: anObject [
	ast := anObject
]

{ #category : #views }
GtGitHubWorkflow >> astView: anObject [
	| nodeMap styler |
	nodeMap := Dictionary new.
	triggers
		do: [ :each | 
			each ast
				ifNotNil: [ :node | 
					nodeMap
						at: ((node isKindOf: YAMLMappingNode) ifTrue: [ node key ] ifFalse: [ node ])
						put: each ] ].
	jobs
		do: [ :each | 
			each ast ifNotNil: [ :node | nodeMap at: node key put: each ].
			each steps
				do: [ :step | step ast ifNotNil: [ :node | nodeMap at: node parent put: step ] ] ].
	styler := (GtSmaCCParserStyler forParser: YAMLParser)
			stylerRules: {GtSmaCCNodeStylerRule
						nodeClassName: #YAMLParseNode
						styleBlock: [ :styleable :node :text | 
							nodeMap
								at: node
								ifPresent: [ :obj | 
									| position |
									position := node stopPosition.
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

{ #category : #views }
GtGitHubWorkflow >> gtAstViewFor: aView [
	<gtView>
	self ast ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Source';
		priority: 10;
		stencil: [ self astView: self ]
]

{ #category : #accessing }
GtGitHubWorkflow >> gtDisplayOn: aStream [
	aStream << name
]

{ #category : #views }
GtGitHubWorkflow >> gtGraphViewFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Dependencies';
		priority: 10;
		painting: [ :mondrian | 
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
						background: BrGlamorousColors neutralBackgroundColor;
						geometry: (BlRoundedRectangleGeometry cornerRadius: 2) ];
				with: jobs.
			mondrian edges
				fromNearestBounds;
				toNearestBounds;
				shape: [ :each | 
					BlLineElement new
						fromHead: (BlArrowheadSimpleArrow new
								border: (BlBorder paint: (Color gray alpha: 0.5) width: 10));
						border: (BlBorder paint: (Color gray alpha: 0.5) width: 2) ];
				connectToAll: [ :each | each dependencies ].
			mondrian layout horizontalDominanceTree
				nodeDistance: 20;
				levelDistance: 30;
				reverse: true ]
]

{ #category : #views }
GtGitHubWorkflow >> gtJobsView: aView [
	<gtView>
	^ aView list
		title: 'Jobs';
		items: [ jobs ]
]

{ #category : #views }
GtGitHubWorkflow >> gtTriggersView: aView [
	<gtView>
	^ aView list
		title: 'Triggers';
		items: [ triggers ]
]

{ #category : #initialization }
GtGitHubWorkflow >> initialize [
	super initialize.
	jobs := OrderedCollection new.
	triggers := OrderedCollection new
]

{ #category : #accessing }
GtGitHubWorkflow >> name [
	^ name
]

{ #category : #accessing }
GtGitHubWorkflow >> name: anObject [
	name := anObject
]

{ #category : #jobs }
GtGitHubWorkflow >> removeJob: aJob [
	jobs remove: aJob ifAbsent: [  ].
	aJob workflow: nil
]

{ #category : #accessing }
GtGitHubWorkflow >> removeTrigger: anEvent [
	triggers remove: anEvent ifAbsent: [  ].
	anEvent workflow: nil
]

{ #category : #accessing }
GtGitHubWorkflow >> triggers [
	^ triggers
]

{ #category : #accessing }
GtGitHubWorkflow >> triggers: anObject [
	triggers := anObject
]
