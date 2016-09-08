package com.epicgames.ue4;

import com.YourCompany.HorizonTweenDemo.OBBDownloaderService;
import com.YourCompany.HorizonTweenDemo.DownloaderActivity;


public class DownloadShim
{
	public static OBBDownloaderService DownloaderService;
	public static DownloaderActivity DownloadActivity;
	public static Class<DownloaderActivity> GetDownloaderType() { return DownloaderActivity.class; }
}

