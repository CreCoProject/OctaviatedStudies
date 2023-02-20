
// PlayBuf helper Synth
// Output of the PlayBuf Method to the first default Audio Outputs
	// Plays the given Bufer with a Octaviated Tempo
	// Loop the Audio File, which will be later Changed by Set Method
(
 SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0, temp = 1 |
	var d, d1, d2;
	// Play Buf Method to play the choosen Sound with the choosen Tempo
	d = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum)*(2**temp), loop: 1, doneAction: Done.freeSelf);
	// Random Choice for the Audio Position
	// Audio Position left Channel
	d1 = rand(0,1)*d;
	// Audio Position right Channel
	d2 = rand(0,1)*d;
	// Audio outout
	Out.ar(0, [d1, d2])
}).add;
)

// Read in the Bunch of Audio-Files
(~sounds = [
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/338986__drfx__music-box-melody-1.mp3",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/624644__sonically-sound__medieval-rpg-music.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/538828__puredesigngirl__dramatic-music.mp3",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/613651__melokacool__firealarm-2.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/613652__melokacool__burglar-alarm.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/534550__jwade722__siren.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/316453__littlerobotsoundfactory__human-evil-13.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/627797__leonardmedia-nl__voice-sound-ladies-and-gentlemen-we-are-proudly-presenting.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/255877__jagadamba__female-voice-whispering-lab-geaks.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/507902__inuetc__heavy-rain-sound-inu-etc.mp3",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/531947__straget__the-rain-falls-against-the-parasol.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/243627__lebaston100__heavy-rain.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/663150__voxlab__nazi-wehrmacht-march-stomp-pulse-2-rr4.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/86009__nextmaking__march-of-army.aiff",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/240732__stib__marching-concrete-loop.aiff",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/370189__238310__stationary-truck.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/529215__nox-sound__vehicle-motorpump-idle-engine-stereo-02.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/660126__tom-kaszuba__motor-on-boiler.wav"
].collect( Buffer.read(s, _) )
)



// Wraper of the Octaviated Process
// our Function to build mutltiple Instances
// Each Function addrsed to one Play Buf Synth
(~my_routine_maker = {
	var a, c;
	// Routine to Controll the Playing Synth
	Routine.run({
		// Stream for chose one Buffer of Sound to Chose
		a = Prand(~sounds.asArray, inf).asStream;
		// Intialice the Synth with a Sound to Play and a Tempo
		c =  Synth(\help_PlayBuf, [\bufnum, a.next, \temp, 1 ]);
		// Loop for ever to change Play Rate and Bufer to play
		loop({
			// wait before setting since an initial was already provided.
			// And wait for next Loop
			// And Set Tempo such that it would sound nice
			2.3.rand2.wait;
			// Set new Temoo and Sound from buffer to play now
			c.set(\temp, -4.4.rand2.round(1), \bufnum, a.next);
		});
	})
   };
)
// multiple Instantiation of our Function
// Such that a Bunch of Sounds are played
5.do({ ~my_routine_maker.() }); 