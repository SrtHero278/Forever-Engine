package funkin.components;

import flixel.math.FlxMath;
import haxe.ds.StringMap;

/**
	typedef Judgement = {
	var name:String;
	var score:Int;
	var accuracy:Float;
	var splash:Bool;
	}
**/
enum Judgement {
	Judgement(name:String, score:Int, accuracy:Float, splash:Bool);
}

enum Rank {
	Rank(name:String, accuracy:Float);
}

class ScoreManager {
	public static final rankings:Array<Rank> = [
		Rank("S+", 100),
		Rank("S", 95),
		Rank("A", 90),
		Rank("B", 85),
		Rank("C", 80),
		Rank("D", 75),
		Rank("E", 70),
		Rank("F", 65),
	];

	public static final judgements:Array<Judgement> = [
		Judgement("sick", 350, 100, true),
		Judgement("good", 150, 80, true),
		Judgement("bad", 0, 45, true),
		Judgement("shit", -150, 0, true)
	];

	public static final timings:StringMap<Array<Float>> = [
		"fnf" => [33.33, 91.67, 133.33, 166.67],
		"etterna" => [45.0, 90.0, 135.0, 180.0],
	];

	public var score:Int = 0;
	public var health(default, set):Float = 1.0;
	public var maxHealth:Float = 2.0;

	public var totalNotesHit:Int = 0;
	public var accuracyWindow:Float = 0.0;

	public var averageMs(get, never):Float;
	public var totalMs:Float = 0.0;
	public var accuracy(get, never):Float;

	public var misses(get, set):Int; // real misses.

	public var combo:Int = 0;
	public var comboBreaks(get, default):Int = 0;

	public var rank:String = "N/A";

	public var judgementsHit:StringMap<Int> = new StringMap<Int>();

	public function new():Void {
		judgementsHit.clear();
		for (judgement in judgements)
			judgementsHit.set(judgement.getParameters()[0], 0);
		judgementsHit.set("miss", 0);
	}

	public static function judgeNote(timeStamp:Float):Judgement {
		var judgement:Judgement = judgements.last();
		final timings = timings.get("fnf");

		for (i in 0...timings.length) {
			if (timeStamp > timings[i])
				continue;
			else if (timings[i] != Math.NaN) {
				judgement = judgements[i];
				break;
			}
		}

		return judgement;
	}

	public function updateRank():Void {
		for (i in 0...rankings.length) {
			var eRank:Array<Dynamic> = rankings[i].getParameters();
			if (eRank[1] <= accuracy) {
				rank = eRank[0];
				break;
			}
		}
	}

	public function increaseJudgeHits(name:String, increment:Int = 1):Void {
		if (judgementsHit.exists(name))
			judgementsHit.set(name, judgementsHit.get(name) + increment);
		else
			trace('[ScoreManager:increaseJudgeHits]: there\'s no judgement going by the name of "${name}"...');
	}

	// -- GETTERS & SETTERS, DO NOT MESS WITH THESE -- //

	@:dox(hide) @:noCompletion function get_misses():Int
		return judgementsHit.exists("miss") ? judgementsHit.get("miss") : 0;

	@:dox(hide) @:noCompletion function set_misses(v:Int):Int {
		if (judgementsHit.exists("miss"))
			judgementsHit.set("miss", v);
		return judgementsHit.exists("miss") ? judgementsHit.get("miss") : 0;
	}

	@:dox(hide) function get_accuracy():Float
		return accuracyWindow == 0.0 ? 0.00 : Math.abs(accuracyWindow / (totalNotesHit + misses));

	@:dox(hide) function get_averageMs():Float
		return totalMs / totalNotesHit;

	@:dox(hide) function get_comboBreaks():Int
		return misses + comboBreaks;

	@:dox(hide) function set_health(v:Float):Float
		return health = FlxMath.bound(v, 0.0, maxHealth);
}
