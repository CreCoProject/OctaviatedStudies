// Load the Buch of Musical Sounds
(~sounm = [
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/613651__melokacool__firealarm-2.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/613652__melokacool__burglar-alarm.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/534550__jwade722__siren.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/316453__littlerobotsoundfactory__human-evil-13.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/627797__leonardmedia-nl__voice-sound-ladies-and-gentlemen-we-are-proudly-presenting.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/255877__jagadamba__female-voice-whispering-lab-geaks.wav"
].collect( Buffer.read(s, _) )
)

// Load the Bunch of Rhytmical Sounds
(~sounr = [
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/531947__straget__the-rain-falls-against-the-parasol.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/243627__lebaston100__heavy-rain.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/663150__voxlab__nazi-wehrmacht-march-stomp-pulse-2-rr4.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/370189__238310__stationary-truck.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/529215__nox-sound__vehicle-motorpump-idle-engine-stereo-02.wav",
"/home/crecothl/OctaveSuperCollider/OctaveSuperColliderEasyWaveMaterial/660126__tom-kaszuba__motor-on-boiler.wav"
].collect( Buffer.read(s, _) )
)

// The Bufer play help Synth
(
 SynthDef(\help_PlayBuf, {| out = 0, bufsound = 0, soundamp = 1,  soundfreq = 1, bufamp = 0, ampamp = 1, ampfreq = 1, bufmaster = 0, temp = 1|
	var d, d1, d2;
	// Play the Musical Sound File to Control the Tempo of the master Sound
	d1 =1 + (soundamp * Amplitude.kr( PlayBuf.ar(1, bufsound, soundfreq * BufRateScale.kr(bufsound), loop: 1, doneAction: Done.freeSelf)));
	// Play the Rhythmical Sound File to Control the Amplitude of the master Sound
	d2 = ampamp * Amplitude.kr(PlayBuf.ar(1, bufamp, ampfreq * BufRateScale.kr(bufamp), loop: 1, doneAction: Done.freeSelf));
	// Play the master Sounds with the given Drivers for Tempo and Amplitude
	d = d2 * PlayBuf.ar(1, bufmaster, d1 * BufRateScale.kr(bufmaster)*temp, loop: 1, doneAction: Done.freeSelf);
	// Give the Sound to the Audio Output
	Out.ar(0, [d/3, d/3])
}).add;
)

// Wraper of the Octaviated Process
// our Function to build mutltiple Instances
// Each Function addrsed to one Play Buf Synth
(~my_routine_maker = {
	// needed Variables
	var as, aa, am, c;
	// Routine to Controll the Playing Synth
	Routine.run({
		// Stream for chose one Buffer of Sound to Chose Rhythmical Amplitude
		aa = Prand(~sounr.asArray, inf).asStream;
		// Stream for chose one Buffer of Sound to Chose Musical Sounds
		// for Tempo Control and to master Synth
		as = Prand(~sounm.asArray, inf).asStream;
		// Initalize great Synth with all needed Parameters
		// BufSound for Rhythmical Driver with soundfreq as Tempo and SoundAmp as Amplitude
		//   of this Signal
		// BufAmp for Amplitude Driver with ampFreq as Tempo and ampAmp as Amplitude of this
		//   Signal
		// BufMaster with temp as Tempo for the master Sound File
		c =  Synth(\help_PlayBuf, [\bufsound, as.next, \soundfreq, (2**(-2.2.rand2.round(1)))/10, \soundamp, (10/(2**(1.3.rand2.round(1)))), \bufamp, aa.next, \ampfreq, (2**(-2.2.rand2.round(1)))/10, \ampamp, (10/(2**(1.3.rand2.round(1)))), \bufmaster, as.next,  \temp, 1 ]);
		// Loop for ever to change Play Rate and Bufer to play
		loop({
			// wait before setting since an initial was already provided.
			// And wait for next Loop
			// And Set Tempo such that it would sound nice
			9.36.rand2.wait;
			// Set new Parameters of the Great Synth
			// BufSound for Rhythmical Driver with soundfreq as Tempo and SoundAmp as Amplitude
			//   of this Signal
			// BufAmp for Amplitude Driver with ampFreq as Tempo and ampAmp as Amplitude of this
			//   Signal
			// BufMaster with temp as Tempo for the master Sound File
			c.set(\bufsound, as.next, \soundfreq, (2**(-2.2.rand2.round(1)))/10, \soundamp, (10/(2**(1.3.rand2.round(1)))), \bufamp, aa.next, \ampfreq, (2**(-2.2.rand2.round(1)))/10, \ampamp, (10/(2**(1.3.rand2.round(1)))), \bufmaster, aa.next,  \temp, 1 );
		});
	})
   };
)
// multiple Instantiation of our Function
// Such that a Bunch of Sounds are played
3.do({ ~my_routine_maker.() });