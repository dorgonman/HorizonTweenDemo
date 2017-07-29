----------------------------------------------  
<h2 align="center">				
			HorizonTweenPlugin<br>
					4.17.0   <br>
			http://dorgon.horizon-studio.net  <br>
				dorgonman@hotmail.com  <br>
</h2>
----------------------------------------------  

The goal of this plugin is to provide on the fly tween animation for UE4 with full control of tween event.

You can find document here: [doc/doxygen/html/index.html](http://horizon-studio.net/ue4/horizon_tween_plugin/doc/doxygen/html/index.html)  

-----------------------  
System Requirements
-----------------------  

Tested UnrealEngine version: 4.12, 4.13, 4.14, 4.15, 4.16, 4.17

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
*4.17.0
- UPDATE: Update to engine 4.17.0, and plugin's VersionName will also follow engine's version.
- UPDATE: Now BP user can call GetCurrentLerp in any TweenEvent for customize their own tween event.
- UPDATE: Refactor parameter name: pTarget to TweenTarget for BP display in TweenSystem's tween creating function.
- NEW: implement StopTweenEventByObject, PlayTweenEventByObject, ResumeTweenEventByObject, RemoveTweenEventByObject, FinishTweenEventByObject in TweenSystem. If your UObject are associated with a TweenEvent in TweenSystem, then it will execute corresponding action.


*1.2.1
- upgrade engine version to 4.16

*1.2.0
- UPDATE: upgrade engine version to 4.15
- NEW: Add HorizonTweenSystemProxy for blueprint user, now you can create an async node in EventGraph for all TweenEvent. All tween creation method put under HorizonPlugin|TweenSystemProxy category. Please check http://horizon-studio.net/ue4/horizon_tween_plugin/doc/doxygen/html/index.html for more detail.

*1.1.0
- UPDATE: upgrade engine to 4.14
- MEW: add FinishTweenEventByName and FinishAllTweenEvent with param bTweenToEnd that can control if we want to set current tween alpha to 1 before finish the event.

*1.0.1 - FIX package error by adding category to all parameter, ref: https://answers.unrealengine.com/que...de-plugin.html
*1.0.0
 - NEW: First Version including core features.