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
  vmImage: 'windows-latest'

variables:
  solution: '**/*.sln'
  buildPlatform: 'Any CPU'
  buildConfiguration: 'Release'

steps:
- task: NuGetToolInstaller@1

- task: NuGetCommand@2
  inputs:
    restoreSolution: '$(solution)'

- task: VSBuild@1
  displayName: 'Build solution **\*.sln'
  inputs:
    solution: '$(solution)'
    platform: '$(buildPlatform)'
    configuration: '$(buildConfiguration)'
- task: CopyFiles@2
  displayName: 'Copy Files to: $(build.artifactstagingdirectory)'
  inputs:
    SourceFolder: '$(system.defaultworkingdirectory)'
    Contents: '**\bin\$(buildConfiguration)\**'
    TargetFolder: '$(build.artifactstagingdirectory)'
  condition: succeededOrFailed()
- task: PublishBuildArtifacts@1
  displayName: 'Publish Artifact'
  inputs:
    PathtoPublish: '$(build.artifactstagingdirectory)'
  condition: succeededOrFailed()

```

## Release Continue Deploy
![Continue Deploy](Continue.png)

## SQL Package
```
/TargetTimeout:3600 /p:CommandTimeout=3600 /p:GenerateSmartDefaults=true /p:BlockOnPossibleDataLoss=false /p:IgnoreAnsiNulls=True /p:IgnoreComments=True

```
## 設定變數保護
![Variables](Variables.png)
