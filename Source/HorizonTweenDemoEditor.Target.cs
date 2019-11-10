// Fill out your copyright notice in the Description page of Project Settings.

using UnrealBuildTool;
using System.Collections.Generic;

public class HorizonTweenDemoEditorTarget : TargetRules
{
	public HorizonTweenDemoEditorTarget(TargetInfo Target) : base(Target)
    {
		Type = TargetType.Editor;
        ExtraModuleNames.AddRange(new string[] { "HorizonTweenDemo" });
        DefaultBuildSettings = BuildSettingsVersion.V2;
        // StrictIncludes for Plugin Demo Build to check if all source files have self-contained headers
        // -NoPCH -NoSharedPCH -DisableUnity
        {
            bUsePCHFiles = false;
            bUseSharedPCHs = false;
            bUseUnityBuild = false;
        }
    }

	
}
