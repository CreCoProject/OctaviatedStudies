// Definition of the Synth
(
SynthDef(\MasterSynth, { |out = 0, // Definition of the Output Channels
	impulseFreq = 0, // Paramter for the Amplitude by Impulse driver Frequency
	impulseAmp = 1,  // Parameter for the Amplitude by Impulse driver Amplitude
	freqAmp = 1, // Amplitude of the Frequency driver WhiteNoise
	masterFreq = 1, // Basic Frequency of the Synth
	masterAmp = 1|  // Basic Amplitude of the Synth
	var sig, dri1, dri2; // Declration of the Signals Channels
	// Callculation of the Amplitude driver
	// Octaviated basic Amplitude with multiplay of a Impulse Signal with given
	// Frequency and Amplitude
	dri2 = (2**(1-masterAmp))*FreeVerb.ar(Blip.ar((0.5/(2**impulseFreq)), 36, (2**impulseAmp)));
	// Callculation of the Frequency driver
	// 440Hz as Basic Frequency Octaviated by masterFreq
	// multiplíed by a Sample and Hold random with WhiteNoise
	// Sample and hold driven by the Amplitude driver
	dri1 = 440*(2**masterFreq) * Latch.kr(WhiteNoise.kr((2**freqAmp)), dri2);
	sig = SinOsc.ar(dri1, 0, dri2);
	Out.ar(out, [sig/5, sig/5]);
}).add;
)
a = Synth(\MasterSynth, [masterFreq: -4.4.rand2.round(1), masterAmp: 0.3.rand2.round(1), impulseFreq: -1.3.rand2.round(1), impulseAmp: -3.3.rand2.round(1), freqAmp: -4.0.rand2.round(1)]);

// Wraper of the Octaviated Process
// our Function to build mutltiple Instances
// Each Function addrsed to one Synth
(~my_routine_maker = {
	var c;
	// Routine to Controll the Playing Synth
	Routine.run({
		// Initailze Synth and give Random Settings in Octaviated Paramter Space
		// For all Paramters of the Synth
		// This are Master-Frequency and Amplitude of the Basic Synth
		// Impulse Frequency and Impulse Amplitude for the Amplitude driver
		// Frequency Amplitude for the Frequency Driver
		c = Synth(\MasterSynth, [masterFreq: -4.4.rand2.round(1), masterAmp: 0.3.rand2.round(1), impulseFreq: -3.3.rand2.round(1), impulseAmp: -3.3.rand2.round(1), freqAmp: -4.0.rand2.round(1)]);
		// Loop for ever to change Play Rate and Parameters
		loop({
			// wait before setting since an initial was already provided.
			// And wait before next Loop
			// And Set Tempo such that it would sound nice
			2.3.rand2.wait;
			// Set the new Parameters.
			// This are Master-Frequency and Amplitude of the Basic Synth
			// Impulse Frequency and Impulse Amplitude for the Amplitude driver
			// Frequency Amplitude for the Frequency Driver
			c.set(\masterFreq, -4.4.rand2.round(1), \masterAmp, 0.3.rand2.round(1), \impulseFreq, -3.3.rand2.round(1), \impulseAmp, -3.3.rand2.round(1), \freqAmp, -4.0.rand2.round(1));
		});
	})
   };
)
// multiple Instantiation of our Function
// Such that a Bunch of Sounds are played
3.do({ ~my_routine_maker.() }); 