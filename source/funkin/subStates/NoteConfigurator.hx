package funkin.subStates;

import flixel.FlxSubState;
import funkin.objects.play.Note;

class NoteConfigurator extends FlxSubState {
	public var notesShown:Array<Note> = [];
	public var skinsNamed:Array<String> = ["normal"];

	public function new():Void {
		super();

		// -- CREATE BACKGROUND -- //
		var bg1:FlxSprite;
		var bg2:FlxSprite;

		add(bg1 = new FlxSprite().makeSolid(FlxG.width, FlxG.height, 0xFF000000));
		add(bg2 = new FlxSprite().loadGraphic(AssetHelper.getAsset("menus/bgBlack", IMAGE)));

		bg1.antialiasing = false;
		// bg2.blend = DIFFERENCE;
		bg1.alpha = 0.7;
		bg2.alpha = 0.07;

		for (i in [bg1, bg2])
			i.scrollFactor.set();
	}

	override function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.state.persistentUpdate = true;
			close();
		}
	}
}
