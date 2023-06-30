use_bpm 120

# drum sequence
kick_pattern = [0.7, 0, 0, 0, 0.7, 0, 0, 0, 0.7, 0, 0, 0, 0.7, 0, 0, 0]
snare_pattern = [0.1, 0.2, 0.1, 0.2, 0.7, 0, 0, 0.2, 0, 0.2, 0, 0, 0.7, 0, 0.1, 0.7]
hh_pattern = [0.2, 0.3, 0.4, 0.5, 0.2, 0.3, 0.4, 0.5, 0.2, 0.3, 0.4, 0.5, 0.2, 0.3, 0.4, 0.5]
sequence_rate = 0.25
sequence_length = 16
kick_note = 36
snare_note = 38
hh_note = 42
sample_map = get :drums_sample_map

# bass sequence (song in Emin)
bass_riff_a = {
  "notes" => [:e2, :e2, :g2, :e2, :d2, :c2, :b1],
  "rhythms" => [ 1.5, 0.5, 0.75, 0.75, 0.5, 2, 2]
}

bass_riff_b = {
  "notes" => [:e2, :e2, :g2, :e2, :d2, :c2, :d2, :c2, :b1],
  "rhythms" => [ 1.5, 0.5, 0.75, 0.75, 0.5, 0.75, 0.75, 0.5, 2]
}

live_loop :drums do
  with_fx :compressor, amp: 0.7 do
    sequence_length.times do
      idx = tick % sequence_length
      multi_drum_sampler kick_note, kick_pattern[idx], sample_map if kick_pattern[idx] != 0
      ##| multi_drum_sampler snare_note, snare_pattern[idx], sample_map if snare_pattern[idx] != 0
      ##| multi_drum_sampler hh_note, hh_pattern[idx], sample_map if hh_pattern[idx] != 0
      sleep sequence_rate
    end
  end
end

live_loop :bass, sync: "/live_loop/drums" do
  with_fx :flanger, delay: 10, stereo_invert_wave: 1, amp: 0.6 do
    with_fx :octaver, subsub_amp: 0, super_amp: 0.5, mix: 0.6 do
      use_synth :tb303
      use_synth_defaults amp: 0.6, sustain: 0, sustain_level: 0, decay: 0.5, release: 0.1, res: 0.2, cutoff: 60
      play_pattern_timed bass_riff_a["notes"], bass_riff_a["rhythms"]
      play_pattern_timed bass_riff_b["notes"], bass_riff_b["rhythms"]
    end
  end
end


