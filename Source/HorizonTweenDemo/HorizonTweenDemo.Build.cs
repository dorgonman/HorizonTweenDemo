// Fill out your copyright notice in the Description page of Project Settings.

using System;
using System.IO;
using UnrealBuildTool;

public class HorizonTweenDemo : ModuleRules
{
	public HorizonTweenDemo(ReadOnlyTargetRules Target)
        : base(Target)
    {
        PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;

        PublicDependencyModuleNames.AddRange(new string[] { "Core", "CoreUObject", "Engine", "InputCore" });

		PrivateDependencyModuleNames.AddRange(new string[] {  });
		string ProjectPath = Path.GetFullPath(Path.Combine(ModuleDirectory, "../../"));
		if(Target.ProjectFile != null)
		{
			ProjectPath = Path.GetDirectoryName(Target.ProjectFile.ToString());

		}
        // https://docs.unrealengine.com/en-US/Platforms/Mobile/UnrealPluginLanguage/index.html
        AdditionalPropertiesForReceipt.Add("AndroidPlugin", Path.Combine(ProjectPath, "Source", "Game_UPL.xml"));

	}
}
