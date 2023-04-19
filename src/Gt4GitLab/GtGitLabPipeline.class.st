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
GtGitLabPipeline >> files [
	^ files
]

{ #category : #accessing }
GtGitLabPipeline >> files: anObject [
	files := anObject
]

{ #category : #accessing }
GtGitLabPipeline >> gtGraphViewFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Pipeline';
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
