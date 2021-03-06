#install
param($installPath, $toolsPath, $package, $project)

#Debug

if($project -eq $null)
{
	$project = Get-Project
}

$project.Save()


[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.Build") | out-null



$msbuild = [Microsoft.Build.Evaluation.ProjectCollection]::GlobalProjectCollection.GetLoadedProjects($project.FullName) | Select-Object -First 1

$projectXml = New-Object System.Xml.XmlDocument
$projectXml.Load($project.FullName)
$namespace = 'http://schemas.microsoft.com/developer/msbuild/2003'


#<Import Project="$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v$(VisualStudioVersion)\TypeScript\Microsoft.TypeScript.Default.props" Condition="Exists('$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v$(VisualStudioVersion)\TypeScript\Microsoft.TypeScript.Default.props')" />

#<Import Project="$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v$(VisualStudioVersion)\TypeScript\Microsoft.TypeScript.targets" Condition="Exists('$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v$(VisualStudioVersion)\TypeScript\Microsoft.TypeScript.targets')" />
$imports = Select-Xml "//msb:Project/msb:Import[contains(@Project,'\Microsoft.TypeScript.Default.props')]" $projectXml -Namespace @{msb = $namespace}

if ($imports)
{
	Write-Host "Microsoft.TypeScript.Default.props already added doing nothing"
}
else
{
	$importElement = $msbuild.Xml.AddImport('$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v$(VisualStudioVersion)\TypeScript\Microsoft.TypeScript.Default.props') 
	$importElement.Condition = 'Exists(''$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v$(VisualStudioVersion)\TypeScript\Microsoft.TypeScript.Default.props'')'
	Write-Host "Microsoft.TypeScript.Default.props added"
}

$imports2 = Select-Xml "//msb:Project/msb:Import[contains(@Project,'\Microsoft.TypeScript.targets')]" $projectXml -Namespace @{msb = $namespace}

if ($imports2)
{
	Write-Host "Microsoft.TypeScript.targets already added doing nothing"
}
else
{
	$importElement = $msbuild.Xml.AddImport('$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v$(VisualStudioVersion)\TypeScript\Microsoft.TypeScript.targets') 
	$importElement.Condition = 'Exists(''$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v$(VisualStudioVersion)\TypeScript\Microsoft.TypeScript.targets'')'
	Write-Host "Microsoft.TypeScript.targets added"
}

$project.Save()