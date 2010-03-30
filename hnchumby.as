class org.brianmckenna.HNChumby extends MovieClip
{
    static var NSTORIES = 10;

    static function enterFrame()
    {
	// Having an enterFrame stops Chumby complaining.
    }

    static function addBackground(timeline)
    {
	timeline.beginFill(0xf6f6ef);
	timeline.lineTo(0, Stage.height);
	timeline.lineTo(Stage.width, Stage.height);
	timeline.lineTo(Stage.width, 0);
	timeline.endFill();
    }

    static function findElementsByName(parent, name)
    {
	var nodes = [];

	for (var i = 0; i < parent.childNodes.length; i++) {
	    if (parent.childNodes[i].nodeName == name) {
		nodes.push(parent.childNodes[i]);
	    }
	}

	return nodes;
    }

    static function main(timeline)
    {
	timeline.onEnterFrame = enterFrame;

	var url = "http://brianmckenna.org/hnchumby.php";

	addBackground(timeline);

	var fontSize = Stage.height / (NSTORIES * 1.5);

	var rankFormat = new TextFormat();
	rankFormat.color = 0x828282;
	rankFormat.align = "right";
	rankFormat.size = fontSize;

	var linkFormat = new TextFormat();
	linkFormat.size = fontSize;

	var height = (Stage.height / NSTORIES);
	for (var i = 0; i < NSTORIES; i++) {
	    timeline.createTextField("rank" + i, i, 0, height * i, fontSize * 2, height);
	    timeline["rank" + i].text = (i + 1) + ".";
	    timeline["rank" + i].selectable = false;
	    timeline["rank" + i].setTextFormat(rankFormat);

	    timeline.createTextField("link" + i, NSTORIES + i, fontSize * 2, height * i, 600, height);
	    timeline["link" + i].selectable = false;
	    timeline["link" + i].setNewTextFormat(linkFormat);
	}

	var feed = new XML();
	feed.onLoad = function(success) {
	    if (success) {
		var channel = feed.firstChild.firstChild;
		var nodes = HNChumby.findElementsByName(channel, "item");

		for(var i = 0; i < HNChumby.NSTORIES; i++) {
		    var item = nodes[i].firstChild;

		    // First child should be title.
		    timeline["link" + i].text = item.firstChild.nodeValue.toString();
		}
	    }
	};
	feed.load(url);
    }
}
