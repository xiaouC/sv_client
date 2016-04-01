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

function exportMovieClip(fileURL)
{
	var doc = fl.getDocumentDOM();
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
			FLfile.createFolder(imageFileURL.substring(0, imageFileURL.lastIndexOf("/")))
			fl.trace(imageFileURL)			
			item.exportToFile(imageFileURL);
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
					var libraryItemName;
					if(elem.libraryItem)
					{
						libraryItemName = elem.libraryItem.name;
					}
					writeFile("                <element " + getAttributeString("name", elem.name) + getAttributeString("elementType", elem.elementType) + getAttributeString("instanceType", elem.instanceType) + getAttributeString("libraryItemName", libraryItemName) + getAttributeString("width", elem.width) + getAttributeString("height", elem.height) + getAttributeString("x", elem.x) + getAttributeString("y", elem.y) + getAttributeString("rotation", elem.rotation) + getAttributeString("scaleX", elem.scaleX) + getAttributeString("scaleY", elem.scaleY) + getAttributeString("skewX", elem.skewX) + getAttributeString("skewY", elem.skewY) + getAttributeString("top", elem.top) + getAttributeString("left", elem.left) + getAttributeString("transformX", elem.transformX) + getAttributeString("transformY", elem.transformY) + "/>");
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

function getTargetPath()
{
	url = fl.browseForFileURL("save", "将动画另存为...");
	if(!url)
	{
		return false;
	}
	
	// mc文件夹
	dir = url.substring(0, url.lastIndexOf("/"));	
	
	// script文件夹
	_scriptDir = dir;
	_scriptDir = _scriptDir.replace("file:///", "");
	_scriptDir = _scriptDir.replace("|", ":");
	while(_scriptDir.indexOf("/") >= 0)
	{
		_scriptDir = _scriptDir.replace("/", "\\");
	}
	_scriptDir = _scriptDir + "\\..\\script"
	_scriptFile = _scriptDir + "\\parsexml.bat";
	
	// xml临时文件
	_fileDir = dir + "/temp";
	_fileURL = _fileDir + url.substring(url.lastIndexOf("/"));	
	var ending = _fileURL.slice(-4);
	if (ending != '.xml')
		_fileURL += '.xml';
			
	return true;
}

function parseXml()
{
	Sample.executeCmd(_scriptDir, _scriptFile, "");		
}

if (getTargetPath())
{
	FLfile.createFolder(_fileDir);
	exportMovieClip(_fileURL);	
	//parseXml(_fileDir);
}



