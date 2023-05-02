Class {
	#name : #GtGitHubCompletionStrategy,
	#superclass : #GtYAMLCompletionStrategy,
	#category : #'Gt4GitHub-Completer'
}

{ #category : #initialization }
GtGitHubCompletionStrategy >> initialize [
	super initialize.
	self loadCompleterFrom: '
name:
run-name:
on:
    fork:
    label,issues:
        types: - created,opened,labelel,edited,deleted
    page_build:
    pull_request,pull_request_target:
        branches,branches-ignore: 
    push:
        branches,tags,branches-ignore,tags-ignore: 
    pull_request,pull_request_target:
        paths,paths-ignore: 
    schedule:
        - cron:
    workflow_call:
        inputs:
            <*>:
                type: boolean,number,string
        outputs:
            <*>:
                description:
                value:
        secrets:
            <*>:
                required: true,false
    workflow_run:
        branches,branches-ignore: 
    workflow_dispatch:
        inputs:
            <*>:
                required: true,false
                type: boolean,choice,environment,string
permissions: &permissions
    actions: read,write,none
    checks: read,write,none
    contents: read,write,none
    deployments: read,write,none
    id-token: read,write,none
    issues: read,write,none
    discussions: read,write,none
    packages: read,write,none
    pages: read,write,none
    pull-requests: read,write,none
    repository-projects: read,write,none
    security-events: read,write,none
    statuses: read,write,none
env:
defaults:
    run:
        shell:
        working-directory:
concurrency:
    group:
    cancel-in-progress: true,false
jobs:
    <job_id>:
        name:
        permissions: *permissions
        needs: - <job_id>?
        if:
        runs-on:
            group:
            labels:
        environment:
            name:
            url:
        concurrency:
            group:
            cancel-in-progress: true,false
        outputs:
        env:
        defaults:
            run:
                shell:
                working-directory:
        steps:
            - id:
              if:
              name:
              uses:
              run:
              shell:
              with:
                  args:
                  entrypoint:
              env:
              continue-on-error:
              timeout-minutes:
        timeout-minutes:
        strategy:
            matrix:
                include:
                exclude:
            fail-fast:
            max-parallel:
        continue-on-error:
        container:
            image:
            credentials:
            env:
            ports:
            volumes:
            options:
        services:
            <*>:
                image:
                credentials:
                env:
                ports:
                volumes:
                options:
        uses:
        with:
            <*>:
                type:
        secrets:
            inherit:name:
run-name:
on:
    fork:
    label,issues:
        types: - created,opened,labelel,edited,deleted
    page_build:
    pull_request,pull_request_target:
        branches,branches-ignore: 
    push:
        branches,tags,branches-ignore,tags-ignore: 
    pull_request,pull_request_target:
        paths,paths-ignore: 
    schedule:
        - cron:
    workflow_call:
        inputs:
            <*>:
                type: boolean,number,string
        outputs:
            <*>:
                description:
                value:
        secrets:
            <*>:
                required: true,false
    workflow_run:
        branches,branches-ignore: 
    workflow_dispatch:
        inputs:
            <*>:
                required: true,false
                type: boolean,choice,environment,string
permissions: &permissions
    -read-all,write-all:
    actions: read,write,none
    checks: read,write,none
    contents: read,write,none
    deployments: read,write,none
    id-token: read,write,none
    issues: read,write,none
    discussions: read,write,none
    packages: read,write,none
    pages: read,write,none
    pull-requests: read,write,none
    repository-projects: read,write,none
    security-events: read,write,none
    statuses: read,write,none
env:
defaults:
    run:
        shell:
        working-directory:
concurrency:
    group:
    cancel-in-progress: true,false
jobs:
    <job_id>:
        name:
        permissions: *permissions
        needs: - <job_id>?
        if:
        runs-on:
            group:
            labels:
        environment:
            name:
            url:
        concurrency:
            group:
            cancel-in-progress: true,false
        outputs:
        env:
        defaults:
            run:
                shell:
                working-directory:
        steps:
            - id:
              if:
              name:
              uses:
              run:
              shell:
              with:
                  args:
                  entrypoint:
              env:
              continue-on-error:
              timeout-minutes:
        timeout-minutes:
        strategy:
            matrix:
                include:
                exclude:
            fail-fast:
            max-parallel:
        continue-on-error:
        container:
            image:
            credentials:
            env:
            ports:
            volumes:
            options:
        services:
            <*>:
                image:
                credentials:
                env:
                ports:
                volumes:
                options:
        uses:
        with:
            <*>:
                type:
        secrets:
            inherit:
'
]
