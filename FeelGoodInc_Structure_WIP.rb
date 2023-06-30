# Bring in midi sampler and live MIDI harmonizer
run_file "C:\\users\\ckior\\Documents\\Sonic Pi\\sonic-pi-experiments\\Multi_drum_sampler_v0.1.rb"
run_file "C:\\users\\ckior\\Documents\\Sonic Pi\\sonic-pi-experiments\\BlondeRebelKit_Map.rb"
# run_file "C:\\users\\ckior\\Documents\\Sonic Pi\\sonic-pi-experiments\\Midi_Harmonizer.rb"

# Feel Good Inc.

# drum sequence
kick_patterns =  {
  "main" => [0.7, 0, 0, 0, 0, 0, 0.7, 0, 0.7, 0, 0, 0, 0, 0, 0, 0],
  "pre" => [0.7, 0, 0, 0, 0, 0, 0.7, 0, 0.7, 0, 0, 0, 0,]
}

snare_pattern = [0, 0, 0, 0, 0.7, 0, 0, 0, 0, 0, 0, 0, 0.7, 0, 0, 0]
hh_pattern = [0, 0, 0.5, 0, 0, 0, 0.3, 0, 0.5, 0, 0.3, 0, 0, 0, 0.5, 0]
sequence_rate = 0.25
sequence_length = 16
kick_note = 36
snare_note = 38
hh_note = 42
sample_map = get :drums_sample_map

# bass sequence (song in Emin)
bass_riff_a = {
  "notes" => [:e2, :e2, :fs2, :g2, :c3, :b2, :a2, :a2, :c3, :b2, :g2, :e2],
  "rhythms" => [ 1.5, 0.5, 0.5, 1.0, 1, 3.5, 1.5, 0.5, 0.5, 1.0, 1, 3.5]
}

bass_riff_b = {
  "notes" => [:e2, :e2, :fs2, :g2, :c3, :b2, :a2, :a2, :c3, :b2, :g2, :e2, :e3],
  "rhythms" => [ 1.5, 0.5, 0.5, 1.0, 1, 3.5, 1.5, 0.5, 0.5, 1.0, 1, 1, 2.5]
}

bass_riff_pre = {
  "notes" => [:e3, :d3, :b2, :g2, :e2],
  "rhythms" => [ 0.5, 1, 1, 1, 4.5]
}

# Verse 16 beats
define :verse1_groove do
  in_thread do
    sleep 32
    24.times do
      with_fx :compressor, amp: 0.7 do
        sequence_length.times do
          idx = tick % sequence_length
          multi_drum_sampler kick_note, kick_patterns["main"][idx], sample_map if kick_patterns["main"][idx] != 0
          multi_drum_sampler snare_note, snare_pattern[idx], sample_map if snare_pattern[idx] != 0
          multi_drum_sampler hh_note, hh_pattern[idx], sample_map if hh_pattern[idx] != 0
          sleep sequence_rate
        end
      end
    end
  end
  
  in_thread do
    4.times do
      with_fx :flanger, delay: 10, stereo_invert_wave: 1, amp: 0.6 do
        with_fx :octaver, subsub_amp: 0, super_amp: 0.5, mix: 0.6 do
          use_synth :tb303
          use_synth_defaults amp: 0.6, sustain: 0, sustain_level: 0, decay: 0.5, release: 0.1, res: 0.2, cutoff: 60
          play_pattern_timed bass_riff_a["notes"], bass_riff_a["rhythms"]
          play_pattern_timed bass_riff_b["notes"], bass_riff_b["rhythms"]
        end
      end
    end
  end
end

define :verse2_groove do
  in_thread do
    32.times do
      with_fx :compressor, amp: 0.7 do
        sequence_length.times do
          idx = tick % sequence_length
          multi_drum_sampler kick_note, kick_patterns["main"][idx], sample_map if kick_patterns["main"][idx] != 0
          multi_drum_sampler snare_note, snare_pattern[idx], sample_map if snare_pattern[idx] != 0
          multi_drum_sampler hh_note, hh_pattern[idx], sample_map if hh_pattern[idx] != 0
          sleep sequence_rate
        end
      end
    end
  end
  
  in_thread do
    4.times do
      with_fx :flanger, delay: 10, stereo_invert_wave: 1, amp: 0.6 do
        with_fx :octaver, subsub_amp: 0, super_amp: 0.5, mix: 0.6 do
          use_synth :tb303
          use_synth_defaults amp: 0.6, sustain: 0, sustain_level: 0, decay: 0.5, release: 0.1, res: 0.2, cutoff: 60
          play_pattern_timed bass_riff_a["notes"], bass_riff_a["rhythms"]
          play_pattern_timed bass_riff_b["notes"], bass_riff_b["rhythms"]
        end
      end
    end
  end
end

define :pre_chorus do
  in_thread do
    sleep 4
    with_fx :compressor, amp: 0.7 do
      sequence_length.times do
        idx = tick % sequence_length
        multi_drum_sampler kick_note, kick_patterns["pre"][idx], sample_map if kick_patterns["pre"][idx] != 0
        sleep sequence_rate
      end
    end
  end
  
  in_thread do
    with_fx :flanger, delay: 10, stereo_invert_wave: 1, amp: 0.6 do
      with_fx :octaver, subsub_amp: 0, super_amp: 0.5, mix: 0.6 do
        use_synth :tb303
        use_synth_defaults amp: 0.6, sustain: 0, sustain_level: 0, decay: 0.5, release: 0.1, res: 0.2, cutoff: 60
        play_pattern_timed bass_riff_pre["notes"], bass_riff_pre["rhythms"]
      end
    end
  end
  
end

define :chorus do
  in_thread do
    4.times do
      use_synth :saw
      play_chord chord(:e3, :minor)
      sleep 4
      play_chord chord(:d3, :major)
      sleep 4
      play_chord chord(:a3, :minor)
      sleep 4
      play_chord chord(:b3, :minor)
      sleep 4
    end
  end
  
  in_thread do
    sleep 32
    8.times do
      with_fx :compressor, amp: 0.7 do
        sequence_length.times do
          idx = tick % sequence_length
          multi_drum_sampler kick_note, kick_patterns["main"][idx], sample_map if kick_patterns["main"][idx] != 0
          multi_drum_sampler snare_note, snare_pattern[idx], sample_map if snare_pattern[idx] != 0
          multi_drum_sampler hh_note, hh_pattern[idx], sample_map if hh_pattern[idx] != 0
          sleep sequence_rate
        end
      end
    end
  end
  
end

loop do
  use_bpm 140
  verse1_groove
  sleep 128
  
  pre_chorus
  sleep 8
  
  chorus
  sleep 64
  
  sleep 4
  
  verse2_groove
  sleep 128
  
  pre_chorus
  sleep 8
  
  chorus
  sleep 64
  
  sleep 4
  
  verse2_groove
  sleep 128
end

