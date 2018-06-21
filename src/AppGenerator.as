﻿package
{
	import appManager.mains.App;
	
	import com.mteamapp.StringFunctions;
	
	import component.*;
	import component.AppIconGenerator;
	import component.xmlPack.ManifestGenerate;
	
	import contents.TextFile;
	import contents.alert.Alert;
	
	import dynamicFrame.FrameGenerator;
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.system.System;
	
	
	public class AppGenerator extends Sprite
	{
		
		private static const iconSizes:Array = [16
												,29
												,32
												,36
												,57
												,114
												,512
												,48
												,72
												,50
												,58
												,100
												,144
												,1024
												,40
												,76
												,80
												,120
												,128
												,152
												,180
												,60
												,75
												,87
												,167] ;
		
		private var iconGenerator:AppIconGenerator ;

		private var manifestGenerate:ManifestGenerate;
		private var mainXMLFile:File;
		private var manifestExporterMC:MovieClip ;
		private var loadMobileProvisionMC:MovieClip ;
		
		//Checklist part
		private var distriqt_push:ACheckBox ;
		
		private const xmlFolder:File = File.applicationDirectory.resolvePath('SampleXML');
		
		public function AppGenerator()
		{
			super();
			
			FrameGenerator.createFrame(stage);
			
			iconSizes.sort(Array.NUMERIC);
			
			iconGenerator = Obj.findThisClass(AppIconGenerator,this);
			iconGenerator.setIconList(iconSizes);
			
			
			manifestGenerate = new ManifestGenerate(iconSizes,'29');
			
			//stage.addEventListener(MouseEvent.CLICK,convertSampleXML);
			
			manifestExporterMC = Obj.get("export_manifest_mc",this);
			manifestExporterMC.addEventListener(MouseEvent.CLICK,exportSavedManifest);
			manifestExporterMC.visible = false ;
			
			var manifestLoaderMC:MovieClip = Obj.get("load_manifest_mc",this) ;
			manifestLoaderMC.buttonMode = true ;
			manifestLoaderMC.addEventListener(MouseEvent.CLICK,loadExistingManifest);
			
			loadMobileProvisionMC = Obj.get("load_privision_mc",this);
			loadMobileProvisionMC.gotoAndStop(2);
			loadMobileProvisionMC.addEventListener(MouseEvent.CLICK,loadMobileProvission);
			
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			
			///////////////
			distriqt_push = Obj.get("distriqt_push_mc",this);
			distriqt_push.setUp(false,'Distriqt Push Notification');
		}
		
		private function loadMobileProvission(e:MouseEvent):void
		{
			FileManager.browse(mobileProvissionSelected,["*.mobileprovision"],"Select your mobile provission");
			function mobileProvissionSelected(fil:File):void
			{
				var status:Boolean = manifestGenerate.addMobileProvission(FileManager.loadFile(fil));
				if(status)
				{
					loadMobileProvisionMC.gotoAndStop(1);
					manifestExporterMC.visible = true ;
				}
				else
					loadMobileProvisionMC.gotoAndStop(2);
					
			}
		}
		
		private function exportSavedManifest(e:MouseEvent):void
		{		
			FileManager.browseToSave(saveFileThere,"Select a destination for your new Manifest file",'xml');
			trace("mainXMLFile : "+mainXMLFile.nativePath);
			var districtFolder:File;
			if(distriqt_push.status)
			{
				districtFolder = xmlFolder.resolvePath('distriqtNotification');
				manifestGenerate.addAndroidPermission(TextFile.load(districtFolder.resolvePath("android_manifest.xml")));
				manifestGenerate.addIosEntitlements(TextFile.load(districtFolder.resolvePath("ios_Entitlements.xml")));
				manifestGenerate.addInfoAdditions(TextFile.load(districtFolder.resolvePath("ios_infoAdditions.xml")));
				manifestGenerate.addExtension(TextFile.load(File.applicationDirectory.resolvePath("SampleXML/distriqtNotification/distriqtNotificationOneSignal-extension.xml")));
			}
			
			var newManifest:String = manifestGenerate.toString();
			System.setClipboard(newManifest);
			
			if(distriqt_push.status)
			{
				manifestGenerate.addIosEntitlements(TextFile.load(districtFolder.resolvePath("ios_Entitlements-dist.xml")));
			}
			
			var newDistManifest:String = manifestGenerate.toString() ;
			
			function saveFileThere(fileTarget:File):void
			{
				TextFile.save(fileTarget,newManifest);
				var distName:String = fileTarget.name.split('.'+fileTarget.extension).join('');
				fileTarget = fileTarget.parent.resolvePath(distName+'-dist.xml');
				TextFile.save(fileTarget,newDistManifest);
			}
		}
		
		private function loadExistingManifest(e:MouseEvent):void
		{
			FileManager.browse(loadThisManifestXML,['*.xml']);
			
			function loadThisManifestXML(fileTarget:File):void
			{
				mainXMLFile = fileTarget ;
				trace("Loaded file is : "+fileTarget.nativePath);
				trace("mainXML file is : "+mainXMLFile.nativePath);
				//convertSampleXML();
				manifestExporterMC.visible = true ;
				manifestGenerate.convert(TextFile.load(mainXMLFile));
			}
		}
	}
}