

var doc = fl.getDocumentDOM();
var uxi = doc.xmlPanel(fl.configURI + "Commands/lol/Skew Flip.xml");
if(uxi.dismiss == "accept")
{
	var flipX = uxi.x;
	var flipY = uxi.y;
	
	var timeline = doc.getTimeline();
	var layers = timeline.layers;
	var frames = timeline.getSelectedFrames();
	var layer = layers[frames[0]];
	for(var fi=frames[1]; fi<frames[2]; ++fi)
	{
		var frame = layer.frames[fi];
		for(var i=0; i<frame.elements.length; ++i)
		{
			var elem = frame.elements[i];
			if(flipX == 'true')
			{
				elem.setPersistentData("skewFlipX", "integer", 1);
			}
			else
			{
				elem.setPersistentData("skewFlipX", "integer", 0);
			}
			if(flipY == 'true')
			{
				elem.setPersistentData("skewFlipY", "integer", 1);
			}
			else
			{
				elem.setPersistentData("skewFlipY", "integer", 0);
			}
		}
	}
}
