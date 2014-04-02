class org.brianmckenna.HNChumby extends MovieClip
{
    static var URL = "https://news.ycombinator.com/rss";
    static var NSTORIES = 10;
    static var SREFRESH = 60;
    static var BARSIZE = 16;
    
    static var timeline;
    static var feed;

    static function enterFrame()
    {
        // Having an enterFrame stops Chumby complaining.
    }

    static function addBackground()
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
    
    static function onFeedLoad(success)
    {
        if (success) {
            var channel = feed.childNodes[1].firstChild;
            var nodes = findElementsByName(channel, "item");

            for(var i = 0; i < NSTORIES; i++) {
                var item = nodes[i].firstChild;

                // First child should be title.
                timeline["link" + i].text = item.firstChild.nodeValue.toString();
            }
        }
    }
    
    static function update()
    {
        feed.load(URL);
        
        setTimeout(update, SREFRESH * 1000);
    }

    static function main(clip)
    {
        timeline = clip;
    
        timeline.onEnterFrame = enterFrame;

        addBackground();

        var barHeight = BARSIZE * 1.5;
        var fontSize = (Stage.height - barHeight) / (NSTORIES * 1.5);

        var topFormat = new TextFormat();
        topFormat.bold = true;
        topFormat.size = BARSIZE;

        timeline.createTextField("top", 100, 0, 0, Stage.width, barHeight);
        timeline["top"].text = "Hacker News";
        timeline["top"].selectable = false;
        timeline["top"].setTextFormat(topFormat);
        timeline["top"].background = true;
        timeline["top"].backgroundColor = 0xff6600;

        var rankFormat = new TextFormat();
        rankFormat.color = 0x828282;
        rankFormat.align = "right";
        rankFormat.size = fontSize;

        var linkFormat = new TextFormat();
        linkFormat.size = fontSize;

        var height = (Stage.height - barHeight) / NSTORIES;
        for (var i = 0; i < NSTORIES; i++) {
            timeline.createTextField("rank" + i, i, 0, barHeight + (height * i), fontSize * 2, height);
            timeline["rank" + i].text = (i + 1) + ".";
            timeline["rank" + i].selectable = false;
            timeline["rank" + i].setTextFormat(rankFormat);

            timeline.createTextField("link" + i, NSTORIES + i, fontSize * 2, barHeight + (height * i), Stage.width, height);
            timeline["link" + i].selectable = false;
            timeline["link" + i].setNewTextFormat(linkFormat);
        }
        
        feed = new XML();
        feed.onLoad = onFeedLoad;
        
        update();
    }
}
