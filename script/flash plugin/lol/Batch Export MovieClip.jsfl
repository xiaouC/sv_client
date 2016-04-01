function getAttributeString(name, value)
{
	return name + "=\"" + value + "\" ";
}

_scriptDir = ""
_scriptFile = ""
_fileURL = ""
_fileDir = ""
_fileData = ""

function createFile(fileURL)
{
	_fileURL = fileURL;
	_fileData = ""
	//fl.outputPanel.clear();
	
}

function writeFile(message)
{
	_fileData += message + "\n";	
	//fl.trace(message);
}

function closeFile()
{
	FLfile.remove(_fileURL);
	FLfile.write(_fileURL, _fileData);	
}

function exportMovieClip(flaURL, fileURL)
{
	var doc = fl.openDocument(flaURL);
	//var doc = fl.getDocumentDOM();
	var lib = doc.library;
	var items = lib.items;
	createFile(fileURL);
	writeFile("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
	writeFile("<symbols " + getAttributeString("frameRate", doc.frameRate) + ">");
	for(var si=0; si<items.length; ++si)
	{
		var item = items[si];
		var type = item.itemType;
		if(type == "bitmap")
		{
			var imageFileURL = fileURL.substring(0, fileURL.lastIndexOf("/")+1) + item.name;			
			item.exportToFile(imageFileURL);
			FLfile.createFolder(imageFileURL.substring(0, imageFileURL.lastIndexOf("/")))
			continue;
		}
		
		if(type != "movie clip" && type != "graphic")
		{
			continue;
		}
	
		var name = item.name;
		if(name.indexOf("outside") >= 0)
		{
			continue;
		}
		var className = item.linkageClassName;
		var timeline = item.timeline;
		var layers = timeline.layers;
		writeFile("    <symbol " + getAttributeString("type", type) + getAttributeString("name", name) + ">");		
		for(var i=0; i<layers.length; ++i)
		{
			var layer = layers[i];
			writeFile("        <layer " + getAttributeString("name", layer.name) + ">");		
			var oldStartFrame = -1;
			var oldDuration = -1;
			for(var j=0; j<layer.frames.length; ++j)
			{		
				var frame = layer.frames[j];
				if(oldStartFrame == frame.startFrame && oldDuration == frame.duration)
				{
					continue;
				}
				oldStartFrame = frame.startFrame;
				oldDuration = frame.duration;
				writeFile("            <frame " + getAttributeString("startFrame", frame.startFrame) + getAttributeString("duration", frame.duration) + getAttributeString("tweenType", frame.tweenType) + ">");
				writeFile("                <script><![CDATA[" + frame.actionScript + "]]></script>");
				for(var k=0; k<frame.elements.length; ++k)
				{
					var elem = frame.elements[k];	 
					var skewFlipX = 0;
					if(elem.hasPersistentData("skewFlipX") && elem.getPersistentData("skewFlipX") == 1)
					{
						skewFlipX = 1;
					}
					var skewFlipY = 0;
					if(elem.hasPersistentData("skewFlipY") && elem.getPersistentData("skewFlipY") == 1)
					{
						skewFlipY = 1;
					}

					if(!elem.libraryItem)
					{
						fl.trace(name + "," + layer.name + "," + j + "," + k)
					}
					writeFile("                <element " + getAttributeString("elementType", elem.elementType) + getAttributeString("instanceType", elem.instanceType) + getAttributeString("libraryItemName", elem.libraryItem.name) + getAttributeString("width", elem.width) + getAttributeString("height", elem.height) + getAttributeString("x", elem.x) + getAttributeString("y", elem.y) + getAttributeString("rotation", elem.rotation) + getAttributeString("scaleX", elem.scaleX) + getAttributeString("scaleY", elem.scaleY) + getAttributeString("skewX", elem.skewX) + getAttributeString("skewY", elem.skewY) + getAttributeString("top", elem.top) + getAttributeString("left", elem.left) + getAttributeString("skewFlipX", skewFlipX) + getAttributeString("skewFlipY", skewFlipY) + getAttributeString("colorMode", elem.colorMode) + getAttributeString("colorAlphaPercent", elem.colorAlphaPercent) + getAttributeString("colorRedPercent", elem.colorRedPercent) + getAttributeString("colorRedAmount", elem.colorRedAmount) + getAttributeString("colorGreenPercent", elem.colorGreenPercent) + getAttributeString("colorGreenAmount", elem.colorGreenAmount) + getAttributeString("colorBluePercent", elem.colorBluePercent) + getAttributeString("colorBlueAmount", elem.colorBlueAmount) + "/>");
				}
				writeFile("            </frame>");		
			}
			writeFile("        </layer>");		
		}
		writeFile("    </symbol>");		
	}
	writeFile("</symbols>");
	closeFile();
	fl.trace("export " + fileURL + " finish");
}

function parseXml()
{
	Sample.executeCmd(_scriptDir, _scriptFile, "");		
}

function batchExport()
{
	// mc文件夹
	var dstFolder = fl.browseForFolderURL("选择mc目录");
	if(dstFolder == null)
	{
		return false;
	}
	
	// script文件夹
	_scriptDir = dstFolder;
	_scriptDir = _scriptDir.replace("file:///", "");
	_scriptDir = _scriptDir.replace("|", ":");
	while(_scriptDir.indexOf("/") >= 0)
	{
		_scriptDir = _scriptDir.replace("/", "\\");
	}
	_scriptDir = _scriptDir + "\\..\\script"
	_scriptFile = _scriptDir + "\\parsexml.bat";
	_fileDir = dstFolder + "/temp";
	FLfile.createFolder(_fileDir)
	
	// fla 目录	
	var srcFolder = fl.browseForFolderURL("选择fla目录");	
	if(srcFolder == null)
	{
		return false;
	}
	var srcFiles = FLfile.listFolder(srcFolder, "files");
	for(var i=0; i<srcFiles.length; ++i)
	{
		var name = srcFiles[i].substring(0, srcFiles[i].lastIndexOf("."));
		var ext = srcFiles[i].substring(srcFiles[i].lastIndexOf("."), srcFiles[i].length);
		if(ext == ".fla")
		{
			var srcFile = srcFolder + "/" + srcFiles[i];
			fl.trace("开始导出" + srcFile + "...");
			
			// xml临时文件
			_fileURL = _fileDir + "/" + name + ".xml";
			
			// 导出
			exportMovieClip(srcFile, _fileURL);	
		}
	}
	
	parseXml(_fileDir);
	fl.trace("导出结束");
	
	return true	
}

batchExport();



