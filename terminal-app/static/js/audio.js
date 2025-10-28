function stopAudio(audio) {
	audio.pause();
	audio.currentTime = 0;
}

function fadeOutAudio(audio, duration) {
	const steps = 50;
	const stepTime = duration / steps;
	const initialAudioVolume = audio.volume;
	const volumeStep = initialAudioVolume / steps;
	const fade = setInterval(() => {
		audio.volume = Math.max(0, audio.volume - volumeStep);
		if (audio.volume === 0) {
			clearInterval(fade);
			stopAudio(audio);
		}
	}, stepTime);
}

function resumeBackgroundSound() {
	if (!isBackgroundSoundMuted()) {
		backgroundSound.play();
		backgroundSound.volume = 0.4;
	}
}
