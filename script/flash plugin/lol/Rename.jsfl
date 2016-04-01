

var doc = fl.getDocumentDOM();
var uxi = doc.xmlPanel(fl.configURI + "Commands/lol/Rename.xml");
if(uxi.dismiss == "accept")
{
	var items = doc.library.getSelectedItems();
	for(var i = 0; i<items.length; i++)
	{
		var item = items[i];
		var pos = item.name.lastIndexOf("/");
		var realName = item.name.substring(pos+1);
		item.name = uxi.prefixName+realName.replace('元件 ', '')
	}
}