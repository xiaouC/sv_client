var showDesc = true
var desc = " --[战斗]屏幕闪烁"

function setScript(script)
{
	if(showDesc) script += desc;
	script += "\n"
	
	var timeline = fl.getDocumentDOM().getTimeline();
	var layers = timeline.layers;
	var frames = timeline.getSelectedFrames();
	var layer = layers[frames[0]];
	var frame = layer.frames[frames[1]];
	frame.actionScript = frame.actionScript + script;
}

var doc = fl.getDocumentDOM();
var script = "win.fightingFlash.lightScreen(0,0.5)";
setScript(script)

