package;

import openfl.display.Stage;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.display.OpenGLView;
import openfl.Lib;
import openfl.display.FPS;

import com.babylonhx.Engine;
import com.babylonhx.Scene;
import com.babylonhx.math.Vector3;
import com.babylonhx.utils.Keycodes;

import flixel.FlxGame;
import flixel.FlxState;

import com.babylonhx.bones.Skeleton;
import com.babylonhx.materials.StandardMaterial;
import com.babylonhx.mesh.Mesh;
import com.babylonhx.mesh.AbstractMesh;
import com.babylonhx.particles.ParticleSystem;
import com.babylonhx.loading.SceneLoader;
import com.babylonhx.loading.plugins.BabylonFileLoader;

/**
 * ...
 * @author Krtolica Vujadin
 */

class MainOpenFL extends Sprite {
	
	var scene:Scene;
	var engine:Engine;
	
	// taken from HaxeFlixel example
	var gameWidth:Int = 640; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 480; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = PlayState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	
	public function new() {
		super();
				
		stage.addChild(this);
		
		engine = new Engine(stage, false);	
		scene = new Scene(engine);
		
		engine.width = stage.stageWidth;
		engine.height = stage.stageHeight;
		
		stage.addEventListener(Event.RESIZE, resize);
		//stage.addEventListener(Event.ENTER_FRAME, update);
		
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchStart);
		stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
				
		// hack to show 2D on top of 3D
		var ground = Mesh.CreateGround("ground1", 0.1, 0.1, 1, scene, false);
		ground.enableEdgesRendering();
		
		// this part is needed for android
		#if mobile
		var lines = Mesh.CreateLines("lines", [
			new Vector3(-0.1, 0, 0),
			new Vector3(0.1, 0, 0)
		], scene);
		lines.alpha = 0.01;
		#end
		// end of hack
		
		createDemo();
	}
		
	private function setupGame():Void {
		var stageWidth:Int = stage.stageWidth;
		var stageHeight:Int = stage.stageHeight;
		
		if (zoom == -1) {
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}
		var mat = new StandardMaterial("ground", scene);
		stage.addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));
		
		var bitmap = new openfl.display.Bitmap (openfl.Assets.getBitmapData ("assets/openfl.png"));
		addChild (bitmap);
		
		bitmap.x = (stage.stageWidth - bitmap.width) / 2;
		bitmap.y = (stage.stageHeight - bitmap.height) / 2;
	}
	
	function createDemo() {
		new samples.BasicScene(scene);
		
		setupGame();
				
		stage.addChild(new openfl.display.FPS(10, 10, 0xffffff));
	}
	
	function resize(e){
		engine.width = stage.stageWidth;
		engine.height = stage.stageHeight;
	}
	
	function onKeyDown(e:KeyboardEvent) {
		for(f in Engine.keyDown) {
			f(e.charCode);
		}		
	}	
	
	function onKeyUp(e:KeyboardEvent) {
		for(f in Engine.keyUp) {
			f(e.charCode);
		}
	}	
	
	function onMouseDown(e:MouseEvent) {
		for(f in Engine.mouseDown) {
			f(e.localX, e.localY, 0);
		}
	}	
	
	function onMouseMove(e:MouseEvent) {
		for(f in Engine.mouseMove) {
			f(e.localX, e.localY);
		}
	}	
	
	function onMouseUp(e:MouseEvent) {
		for(f in Engine.mouseUp) {
			f(e.localX, e.localY, 0);
		}
	}
	
	function onMouseWheel(e:MouseEvent) {
		for (f in Engine.mouseWheel) {
			f(e.delta);
		}
	}
	
	function onTouchStart(e:TouchEvent) {
		for(f in Engine.touchDown) {
			f(e.localX, e.localY, 0);
		}
	}
	
	function onTouchEnd(e:TouchEvent) {		
		for(f in Engine.touchUp) {
			f(e.localX, e.localY, 0);
		}
	}	
	
	function onTouchMove(e:TouchEvent) {
		for(f in Engine.touchMove) {
			f(e.localX, e.localY);
		}		
	}
	
	function update(e) {
		engine._renderLoop();
	}
	
}
