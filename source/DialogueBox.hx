package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		bgFade.setGraphicSize(Std.int(bgFade.width*(1+(1-FlxG.camera.zoom))));
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

			default:
				hasDialog=true;
				box.frames = Paths.getSparrowAtlas("speech_bubble_talking");
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal','speech bubble normal', 24);
		}

		box.animation.play('normalOpen');
		if(PlayState.SONG.song.toLowerCase()=='thorns' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='senpai')
			box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		else
			box.setGraphicSize(Std.int(box.width*(1+(1-FlxG.camera.zoom))));
		box.updateHitbox();
		this.dialogueList = dialogueList;

		if (!hasDialog)
			return;

		portraitLeft = new FlxSprite(0, 40);

		if(PlayState.SONG.song.toLowerCase()=='thorns' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='senpai')
		{
			portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
			portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width  * 0.9));
		}else{
			portraitLeft.frames = Paths.getSparrowAtlas('ports');
			portraitLeft.animation.addByPrefix('enter', PlayState.SONG.player2, 24, false);
		}


		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width*(1+(1-FlxG.camera.zoom))));
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(Std.int(FlxG.width/2), 40);
		if(PlayState.SONG.song.toLowerCase()=='thorns' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='senpai')
		{
			portraitRight.x = 0;
			portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width  * 0.9));
		}else{
			portraitRight.frames = Paths.getSparrowAtlas('bfPort');
			portraitRight.animation.addByPrefix('enter', 'bfPort', 24, false);
		}
		portraitRight.setGraphicSize(Std.int(portraitRight.width*(1+(1-FlxG.camera.zoom))));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		add(box);
		if(PlayState.SONG.song.toLowerCase()=='thorns' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='senpai')
		{
			portraitLeft.screenCenter(X);
			box.screenCenter(X);
			handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
			add(handSelect);
		}else{
			box.screenCenter(XY);
			box.y += 200;
			portraitRight.y += 180;
			portraitRight.x += 125;
			portraitLeft.x += 50;
			portraitLeft.y += 150;
		}

		if(PlayState.SONG.song.toLowerCase()=='thorns'){
			var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
			face.setGraphicSize(Std.int(face.width * 6));
			add(face);
		}


		if (!talkingRight)
		{
			//box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.setGraphicSize(Std.int(dropText.width*(1+(1-FlxG.camera.zoom))));
		if(PlayState.SONG.song.toLowerCase()=='thorns' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='senpai'){
			dropText.font = 'Pixel Arial 11 Bold';
		}else{
			dropText.setFormat(Paths.font("vcr.ttf"), 32);
		}
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.setGraphicSize(Std.int(swagDialogue.width*(1+(1-FlxG.camera.zoom))));
		if(PlayState.SONG.song.toLowerCase()=='thorns' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='senpai'){
			swagDialogue.font = 'Pixel Arial 11 Bold';
		}else{
			swagDialogue.setFormat(Paths.font("vcr.ttf"), 32);
		}
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);

			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	var curLeft = '';
	var curRight = '';
	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
		case 'dad':
			portraitRight.visible = false;
			if (!portraitLeft.visible)
			{
				portraitLeft.visible = true;
				portraitLeft.animation.play('enter');
			}
			case 'bf':
				box.flipX = false;
				portraitLeft.visible = false;
				if(curRight != 'bf' && PlayState.SONG.song.toLowerCase()!='thorns' && PlayState.SONG.song.toLowerCase()!='roses' && PlayState.SONG.song.toLowerCase()!='senpai'){
						curRight='bf';
						portraitRight.frames = Paths.getSparrowAtlas('bfPort');
            portraitRight.animation.addByPrefix('enter', 'bfPort', 24, true);
						portraitRight.visible=false;
				}
				if (!portraitRight.visible)
				{
						portraitRight.visible = true;
						portraitRight.animation.play('enter');
				}
			case 'bf-scared':
				box.flipX = false;
				portraitLeft.visible = false;
				if(curRight != 'bf-scared'){
						curRight='bf-scared';
						portraitRight.frames = Paths.getSparrowAtlas('bfPort');
            portraitRight.animation.addByPrefix('enter', 'bfNervousPort', 24, true);
						portraitRight.visible=false;
				}
				if (!portraitRight.visible)
				{
						portraitRight.visible = true;
						portraitRight.animation.play('enter');
				}
			default:
				box.flipX = true;
				portraitRight.visible = false;
				if(curLeft != curCharacter){
						curLeft=curCharacter;
						portraitLeft.frames = Paths.getSparrowAtlas('ports');
            portraitLeft.animation.addByPrefix('enter', curCharacter+"0", 24, true);
						portraitLeft.visible=false;
				}
				if (!portraitLeft.visible)
				{
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1].toLowerCase();
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
