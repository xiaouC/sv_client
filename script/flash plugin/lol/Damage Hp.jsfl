var showDesc = true
var desc = " --[战斗]被击者扣血"

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
var uxi = doc.xmlPanel(fl.configURI + "Commands/lol/Damage Hp.xml");
if(uxi.dismiss == "accept")
{
	var script = "win.fightingFlash.mainTargetDamageHp(" + uxi.hp + ",";
	if (uxi.action.length != 0)
		script = script + "'" + uxi.action + "',";
	else
		script = script + "nil,";
		
	if (uxi.freeze.length != 0)
		script = script + uxi.freeze;
	else
		script = script + "nil";
		
	script = script + ")";
	setScript(script);
}
