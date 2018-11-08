![VSTS CI status](https://hsgame.visualstudio.com/UE4HorizonPlugin/_apis/build/status/HorizonTweenPluginDemo-CI)

public feed: nuget.org  

[![nuget.org package in feed in ](https://img.shields.io/nuget/v/UE4Editor-HorizonTweenDemo.svg)](https://www.nuget.org/packages/UE4Editor-HorizonTweenDemo/)

private feed(only for internal use): 

[![Azure Artifacts package in  feed in ](https://hsgame.feeds.visualstudio.com/_apis/public/Packaging/Feeds/d5ed5eb7-dd62-4af0-a6a4-8862be2b9f7f/Packages/8a06a9fa-1629-42ad-a67b-0ced8c52bdfd/Badge)](https://hsgame.visualstudio.com/_Packaging?feed=d5ed5eb7-dd62-4af0-a6a4-8862be2b9f7f&package=8a06a9fa-1629-42ad-a67b-0ced8c52bdfd&preferRelease=true&_a=package)



Note: 

master branch may be unstable since it is in development, please switch to tags, for example: release/4.21.0


----------------------------------------------  
How to Run Demo Project before purchase:(Only for Win64 editor build, no source code)
1. [Download nuget executable](https://www.nuget.org/downloads) and copy the exe into C:\Windows\system32\ or any place listed in your PATH environment.
2. Double click install_package_from_nuget.org.bat, and check if UE4Editor-*.dll are installed to Binaries\Win64 and Plugins\HorizonTweenPlugin\Binaries\Win64\
3. Double click HorizonTweenPluginDemo.uproject  
----------------------------------------------

 

----------------------------------------------  
<h2 align="center">				
			HorizonTweenPlugin<br>
					4.21.0   <br>
			http://dorgon.horizon-studio.net  <br>
				dorgonman@hotmail.com  <br>
</h2>
----------------------------------------------  

The goal of this plugin is to provide on the fly tween animation for UE4 with full control of tween event.

You can find document here: [doc/doxygen/html/index.html](http://horizon-studio.net/ue4/horizon_tween_plugin/doc/doxygen/html/index.html)  

-----------------------  
System Requirements
-----------------------  

Supported UnrealEngine version: 4.12-4.21

-----------------------
Installation Guide
-----------------------  

put HorizonTweenPlugin into YOUR_PROJECT/Plugins folder, 
and then add module to your project 
YOUR_PROJECT.Build.cs:
PublicDependencyModuleNames.AddRange(new string[] { "HorizonTween"});

-----------------------
User Guide
-----------------------  

Just drag HorizonTweenSystem to your level and start create your tween animation.

-----------------------
Technical Details
-----------------------  

List of Modules: HorizonTween (Runtime)  

Intended Platform: All Platforms  

Platforms Tested: Windows, Android, Mac  

Demo Project: https://github.com/dorgonman/HorizonTweenDemo 

DemoVideo: https://www.youtube.com/watch?v=8AbLq0jagak&feature=youtu.be  

-----------------------
What does your plugin do/What is the intent of your plugin
-----------------------  

The core feature in this plugin:  

* Tween for Actor, SceneComponent and UMG Widget, no C++ code required. (MoveFromTo, RotationFromTo, ScaleFromTo, ColorFromTo and MoveSplinePath)

* Blueprint only, no C++ code required. Of course, you can also use it in C++.  

* Event Callback:OnTweenStart, OnTweenUpdate, OnTweenLoop OnTweenFinished, so you can fire your own custom event at any point.(Power by UE4 Delegate system).  

* Collision detection support for Actor and SceneComponent, use flag bSweep, bTeleport, bCollideAndFinishEvent for tween event control. You can also check SweepHitResult in OnTweenUpdate callback to fire your own custom function if you want additional behavior.  

* Support tween along spline path for Actor, SceneComponent and Widget.  

* Support multiple TweenStart and TweenEnd for TweenEvent param that helping user design fancy tweening animation.  

* TweenSystem event control method: StopTweenEventByName, PlayTweenEventByName, PauseTweenEventByName, ResumeTweenEventByName, RemoveTweenEventByName, StopAllTweenEvent, PlayAllTweenEvent, PauseAllTweenEvent, ResumeAllTweenEvent, RemoveAllTweenEvent.  

* About 30 type of Lerp mode are implemented: Linear Lerp, BounceInOut, InterpSinInOut...you can also design custom curve in UE4 editor if default implemented lerp mode didn't meet required.  

* Implemented PlayMode: Forward, Reverse and PingPong.  

* Use NumOfLoop, Duration, DelayInit and DelayLoop in TweenEvent parameter to control loop behavior.  

* Use bSweep, bTeleport, bCollideAndFinishEvent and SweepHitResult in TweenEvent parameter to control collision behavior.  

-----------------------
Contact and Support
-----------------------  

email: dorgonman@hotmail.com


-----------------------
 Version History
----------------------- 
*4.21.0  

	BugFix: CurrentAlpha in UHorizonTweenEvent::Finish for EHorizonTweenPlayMode::PingPong

	BugFix: Expose bUseCustomCurve for BP to fix bUseCustomCurve are set to true by engine.  

	BugFix: CurrentAlpha in Reverse PlayMode of first update is 0(should be 1)

	BugFix: CurrentDuration and CurrentAlpha value in UHorizonTweenEvent::Finish(bool bTweenToEnd = true)

	Update to 4.21


*4.20.1  

	BugFix: Expose bUseCustomCurve for BP to fix bUseCustomCurve are set to true by engine.

	BugFix: CurrentDuration and CurrentAlpha value in UHorizonTweenEvent::Finish(bool bTweenToEnd = true)

	BugFix: CurrentAlpha in UHorizonTweenEvent::Finish for EHorizonTweenPlayMode::PingPong




*4.20.0  

	New: Flag to Pause TweenEvent when TweenLoop is triggered(TweenEventParam.bPauseOnTweenLoop)

*4.19.0  

	New: MultiTween Event for Actor, SceneCompoent and Widget, [check video demo here](https://www.youtube.com/watch?v=Tg0sqlCbAHU)

	New: Implement GetTimeRange for FHorizonTweenEventCustomCurve and FHorizonTweenEventCustomColorCurve

	New: Add UHorizonTweenEvent::GetTweenSystem

	Refactor: change .h and .cpp folder structure

	Refactor: meta = (EditCondition = "bUseCustomCurve") for Custom curve

	Refactor EventMacro

	Refactor: Change widget dependency module from PrivateDependencyModuleName to PublicDependencyModuleName

	Refactor Classes folders

*4.18.0  

	REFACTOR: Change the inheritance of AHorizonTweenSystem from AActor to AInfo.


*4.17.0  

	UPDATE: Update to engine 4.17.0, and plugin's VersionName will also follow engine's version.

	UPDATE: Now BP user can call GetCurrentLerp in any TweenEvent for customize their own tween event.

	UPDATE: Refactor parameter name: pTarget to TweenTarget for BP display in TweenSystem's tween creating function.

	NEW: implement StopTweenEventByObject, PlayTweenEventByObject, ResumeTweenEventByObject, RemoveTweenEventByObject, FinishTweenEventByObject in TweenSystem. If your UObject are associated with a TweenEvent in TweenSystem, then it will execute corresponding action.

	NEW: implement global DefaultTweenSystem and CreateDefaultTweenEventFunctions for all exist tween events.

	New: implement CreateTweenBaseTypes(float FVector, FVector2D, FRotator, SplinePath)

	Refactor: redesign blueprint function Category, all functions in plugins are put into relative Category group. Currently all Plugin functions are grouped into following Category: HorizonPlugin|TweenFunctionLibrary, HorizonPlugin|TweenSystemLibrary, HorizonPlugin|TweenSystemLibraryProxy, HorizonPlugin|TweenSystemProxy. TweenFunctions in TweenSystemLibrary and TweenSystemLibraryProxy will use global DefaultTweenSystem to create TweenEvents.

	Deprecated: paramImpl.bShortestPath in CreateTweenActorRotatorFromToEventWithParam and CreateTweenSceneComponentRotatorFromToEventWithParam are deprecated and will be removed in future plugin release, please recreate paramImpl and use bUseShortestPath instead.


*1.2.1  

	upgrade engine version to 4.16

*1.2.0  

	UPDATE: upgrade engine version to 4.15

	NEW: Add HorizonTweenSystemProxy for blueprint user, now you can create an async node in EventGraph for all TweenEvent. All tween creation method put under HorizonPlugin|TweenSystemProxy category. Please check http://horizon-studio.net/ue4/horizon_tween_plugin/doc/doxygen/html/index.html for more detail.

*1.1.0  

	UPDATE: upgrade engine to 4.14

	MEW: add FinishTweenEventByName and FinishAllTweenEvent with param bTweenToEnd that can control if we want to set current tween alpha to 1 before finish the event.

*1.0.1   

	FIX package error by adding category to all parameter, ref: https://answers.unrealengine.com/que...de-plugin.html

*1.0.0  

	NEW: First Version including core features.
