# SQL SUMMIT 2024

## Azure DevOps
![Azure DevOps](AzureDevOps.png)

## Git
![Git Flow](Git.png)

## Azure SQL Database
![SQL Database](SQLDatabaseFree.png)

## SQL Pipeline
```
trigger:
- master
- develop

pool:
  vmImage: 'windows-latest'  # 不能用 ubuntu

variables:
  solution: '**/*.sln'
  buildPlatform: 'Any CPU'
  buildConfiguration: 'Release'

steps:
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
