# SQL SUMMIT 2024

## Azure DevOps
![Azure DevOps](AzureDevOps.png)

## Git
![Git Flow](Git.png)

## SQL Pipeline
```
trigger:
- master
- demo
- develop


pool:
  vmImage: ubuntu-latest

variables:
  buildConfiguration: 'Release'
  sourceDirector: 'src/' #如果有設定要記得加入 /

steps:
- task: UseDotNet@2
  displayName: 'Use .Net Core 7'
  inputs:
    packageType: 'sdk'
    version: '7.x'

- task: DotNetCoreCLI@2
  displayName: 'Restore Package'
  inputs:
    command: 'restore'
    projects: '$(sourceDirector)**/*.sln'
    feedsToUse: 'select'

- task: DotNetCoreCLI@2
  displayName: 'Build Project'
  inputs:
    command: 'build'
    projects: '$(sourceDirector)**/*.sln'
    arguments: '--configuration Release'
- task: DotNetCoreCLI@2
  displayName: 'Publish Project'
  inputs:
    command: 'publish'
    projects: '$(sourceDirector)**/*.sln'
    publishWebProjects: true
    arguments: '--configuration $(buildConfiguration) --output $(build.artifactstagingdirectory)'
    zipAfterPublish: True
- task: PublishBuildArtifacts@1
  displayName: 'Publish Artifact'
  inputs:
    PathtoPublish: '$(build.artifactstagingdirectory)'
  condition: succeededOrFailed()

```
