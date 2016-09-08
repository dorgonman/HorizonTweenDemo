----------------------------------------------  
<h2 align="center">				
			HorizonTweenPlugin<br>
					1.0.0   <br>
			http://dorgon.horizon-studio.net  <br>
				dorgonman@hotmail.com  <br>
</h2>
----------------------------------------------  
The goal of thie plugin is to provide on the fly tweening animation for UE4 with full control of tween event.

-----------------------  
System Requirements
-----------------------

Tested UnrealEngine version: 4.12, 4.13

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
List of Modules:
HorizonTween (Runtime)

Intended Platform: All Platforms
Platforms Tested: Win32, Win64, Android, Mac
Demo Project: https://github.com/dorgonman/HorizonTweenDemo
DemoVideo: https://www.youtube.com/watch?v=GQBd2qAEpCg&feature=youtu.be

-----------------------
What does your plugin do/What is the intent of your plugin
-----------------------


The core feature in this plugin:  

* Tween for Actor, SceneComponent and UMG Widget, no C++ code required. (MoveFromTo, RotationFromTo, ScaleFromTo, ColorFromTo and MoveSplinePath)

* Blueprint only, no C++ code required. Of course, you can also use it in C++.  

* Event Callback:OnTweenStart, OnTweenUpdate, OnTweenLoop OnTweenFinished, so you can fire your own custom event at any point.(Power by UE4 Delegate system).  

   For Blueprint user, you can bind event this way:  

   ![BindCallback](https://github.com/dorgonman/HorizonTweenDemo/blob/master/doc/doxygen/Resources/Demo10_BP_BindEvent.png)  

   For C++ user, you can bind Callback using following method:  [Check all supported callback binding method here](https://docs.unrealengine.com/latest/INT/Programming/UnrealArchitecture/Delegates/Multicast/index.html)

  ```cpp  
 	   //need mark UFUNCTION() in header
 	   void AYourClass::MyTweenStartFunc(UHorizonTweenEvent* pTweenEvent){
 	   		//fire you custom function here when tween start
 	   }
 	   void AYourClass::OnMyTweenLoop(UHorizonTweenEvent* pTweenEvent){
 	   		//fire you custom function here when begin tween loop
 	   }
	   void AYourClass::YourFunction(UHorizonTweenEvent* pEvent){


	   		pEvent->OnTweenStartNative.AddUFunction(this, "MyTweenStartFunc");

	   		pEvent->OnTweenLoopNative.AddUObject(this, &AYourClass::OnMyTweenLoop);


			pEvent->OnTweenUpdateNative.AddLambda([](UHorizonTweenEvent* pTweenEvent) {
				//fire you custom function here when tween update/
			});
			
			pEvent->OnTweenFinishedNative.AddLambda([this](UHorizonTweenEvent* pTweenEvent) {
				//fire you custom function here when tween finished.
			});

	   }
  ```  
* Collision detection support for Actor and SceneComponent, use flag bSweep, bTeleport, bCollideAndFinishEvent for tween event control. You can also check SweepHitResult in OnTweenUpdate callback to fire your own custom function if you want additional behavior.  

* Support tween along spline path for Actor, SceneComponent and Widget.  

* Support multiple TweenStart and TweenEnd for TweenEvent param that helping user design fancy tweening animation.  

* TweenSystem event control method: StopTweenEventByName, PlayTweenEventByName, PauseTweenEventByName, ResumeTweenEventByName, RemoveTweenEventByName, StopAllTweenEvent, PlayAllTweenEvent, PauseAllTweenEvent, ResumeAllTweenEvent, RemoveAllTweenEvent.  

-----------------------
Contact and Support
-----------------------

email: dorgonman@hotmail.com


-----------------------
 Version History
-----------------------
- NEW: First Version including core features.
