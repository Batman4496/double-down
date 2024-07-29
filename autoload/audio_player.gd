extends Node2D

func play_music(music_path: String):
	var stream = load(music_path);
	
	if $MusicPlayer.playing:
		$AnimationPlayer.play("fade");
		$MusicPlayer.stop();
		
	$MusicPlayer.stream = stream;
	$MusicPlayer.play();
	$AnimationPlayer.play_backwards("fade");
	
func play_sfx(sfx_path: String):
	var stream = load(sfx_path);
	
	if $SFXPlayer.playing:
		$SFXPlayer.stop();
		
	$SFXPlayer.stream = stream;
	$SFXPlayer.play();
