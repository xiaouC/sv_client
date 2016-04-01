_scriptDir = ""
_scriptFile = ""
_fileDir = ""
_name = ""
_param = ""

function getTargetPath()
{
	url = fl.browseForFileURL("open", "打开动画...");
	if(!url)
	{
		return false;
	}
	
	// mc文件夹
	_name = url.substring(url.lastIndexOf("/")+1, url.lastIndexOf("."));	
	_param = "-eeditor/modelviewer -cmain({model=" + _name + "})";
	
	_fileDir = url.substring(0, url.lastIndexOf("/"));	
	
	// script文件夹
	_scriptDir = dir;
	_scriptDir = _scriptDir.replace("file:///", "");
	_scriptDir = _scriptDir.replace("|", ":");
	while(_scriptDir.indexOf("/") >= 0)
	{
		_scriptDir = _scriptDir.replace("/", "\\");
	}
	_scriptDir = _scriptDir + "\\.."
	_scriptFile = _scriptDir + "\\lol2.1.3.exe";
				
	return true;
}

function viewModel()
{
	Sample.executeCmd(_scriptDir, _scriptFile, _param);		
}

if (getTargetPath())
{
	viewModel();
}



