var showDesc = true
var desc = " --[战斗]攻击者移动回来"

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
var uxi = doc.xmlPanel(fl.configURI + "Commands/lol/MoveTo Target.xml");
if(uxi.dismiss == "accept")
{
	var script = "win.fightingFlash.moveBack(" + uxi.offset + "," + uxi.time + ")";	
	setScript(script)
}
