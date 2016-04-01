var showDesc = true
var desc = " --[战斗]被击者播放特效"

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
var uxi = doc.xmlPanel(fl.configURI + "Commands/lol/Target PlayEffect.xml");
if(uxi.dismiss == "accept")
{
	var param = "'" + uxi.effectName + "',";
	if (uxi.layerName.length != 0 )
		param = param + "'" + uxi.layerName + "'";
	else
		param = param + "nil";

	param = param + ","
	if (uxi.scaleValue.length != 0)
		param = param + uxi.scaleValue;
	else
		param = param + "nil";

	var script = "win.fightingFlash.targetPlayEffect(" + param + ")";
	setScript(script)
}
