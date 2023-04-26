Class {
	#name : #GtGitHubWorkflowStyler,
	#superclass : #GtCompositeSmaCCASTStyler,
	#category : #'Gt4GitHub-Styler'
}

{ #category : #initialization }
GtGitHubWorkflowStyler >> initialize [
	super initialize.
	self parserClass: YAMLParser.
	self stylers: {YAMLParser gtStyler}
]

{ #category : #accessing }
GtGitHubWorkflowStyler >> style: aText ast: anAST [
	| workflow nodeMap styler |
	super style: aText ast: anAST.
	workflow := GtGitHubImporter new importWorkflowAST: anAST.
	nodeMap := Dictionary new.
	workflow triggers
		do: [ :each | 
			each ast
				ifNotNil: [ :node | 
					nodeMap
						at: ((node isKindOf: YAMLMappingNode) ifTrue: [ node key ] ifFalse: [ node ])
						put: each ] ].
	workflow jobs
		do: [ :each | 
			each ast ifNotNil: [ :node | nodeMap at: node key put: each ].
			each steps
				do: [ :step | step ast ifNotNil: [ :node | nodeMap at: node parent put: step ] ] ].
	styler := (GtSmaCCParserStyler forParser: YAMLParser)
			stylerRules: {GtSmaCCNodeStylerRule
						nodeClassName: #YAMLParseNode
						styleBlock: [ :styleable :node :txt | 
							nodeMap
								at: node
								ifPresent: [ :obj | 
									| position |
									position := node stopPosition.
									txt
										attribute: (BrTextAdornmentDynamicAttribute new
												beAppend;
												stencil: [ BrButton new
														background: BrGlamorousColors defaultButtonBorderColor;
														size: 8 @ 8;
														geometry: BlEllipseGeometry new;
														margin: (BlInsets left: 2 right: 2);
														action: [ :button | button phlow spawnObject: obj ] ])
										from: position
										to: position ] ]}.
	styler style: aText ast: anAST
]
